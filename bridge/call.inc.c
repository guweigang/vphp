static int vphp_bridge_call_debug_enabled(void) {
  const char *path = getenv("VSLIM_CLI_DEBUG_FILE");
  if (path != NULL && path[0] != '\0') {
    return 2;
  }
  const char *flag = getenv("VSLIM_CLI_DEBUG");
  if (flag != NULL && flag[0] != '\0') {
    return 1;
  }
  return 0;
}

static void vphp_bridge_call_debug_log(const char *message) {
  int mode = vphp_bridge_call_debug_enabled();
  FILE *fp = NULL;
  if (mode == 0) {
    return;
  }
  if (mode == 2) {
    const char *path = getenv("VSLIM_CLI_DEBUG_FILE");
    fp = fopen(path, "ab");
    if (fp == NULL) {
      return;
    }
  } else {
    fp = stderr;
  }
  fprintf(fp, "[vphp-bridge-debug] %s\n", message);
  fflush(fp);
  if (mode == 2 && fp != NULL) {
    fclose(fp);
  }
}

static void vphp_bridge_call_debug_log_zval(const char *prefix, zval *zv) {
  char debug_buf[512];
  int type = zv ? Z_TYPE_P(zv) : -1;
  if (zv == NULL) {
    snprintf(debug_buf, sizeof(debug_buf), "%s zval=NULL", prefix);
    vphp_bridge_call_debug_log(debug_buf);
    return;
  }
  if (Z_REFCOUNTED_P(zv)) {
    if (Z_TYPE_P(zv) == IS_OBJECT) {
      zend_class_entry *ce = Z_OBJCE_P(zv);
      snprintf(debug_buf, sizeof(debug_buf),
               "%s zval=%p type=%d refcount=%u gc_flags=0x%x object=%p handlers=%p class=%s",
               prefix, (void *)zv, type, GC_REFCOUNT(Z_COUNTED_P(zv)),
               GC_FLAGS(Z_COUNTED_P(zv)), (void *)Z_OBJ_P(zv),
               Z_OBJ_P(zv) ? (void *)Z_OBJ_HT_P(zv) : NULL,
               (ce && ZSTR_VAL(ce->name)) ? ZSTR_VAL(ce->name) : "(null)");
      vphp_bridge_call_debug_log(debug_buf);
      return;
    }
    snprintf(debug_buf, sizeof(debug_buf),
             "%s zval=%p type=%d refcount=%u gc_flags=0x%x", prefix,
             (void *)zv, type, GC_REFCOUNT(Z_COUNTED_P(zv)),
             GC_FLAGS(Z_COUNTED_P(zv)));
    vphp_bridge_call_debug_log(debug_buf);
    return;
  }
  snprintf(debug_buf, sizeof(debug_buf), "%s zval=%p type=%d non_refcounted",
           prefix, (void *)zv, type);
  vphp_bridge_call_debug_log(debug_buf);
}

static zend_class_entry *vphp_get_ce_from_zval(zval *zv) {
  if (!zv) {
    return NULL;
  }
  if (Z_TYPE_P(zv) == IS_OBJECT) {
    return Z_OBJCE_P(zv);
  }
  if (Z_TYPE_P(zv) == IS_STRING) {
    return vphp_lookup_class_by_name(Z_STRVAL_P(zv), Z_STRLEN_P(zv));
  }
  return NULL;
}

int vphp_call_php_func(const char *name, int name_len, zval *retval,
                       int param_count, zval **params_ptrs) {
  zval func_name;
  zval *params = NULL;

  ZVAL_STRINGL(&func_name, name, name_len);
  if (param_count > 0) {
    params = (zval *)safe_emalloc(param_count, sizeof(zval), 0);
    for (int i = 0; i < param_count; i++) {
      if (params_ptrs[i]) {
        ZVAL_COPY(&params[i], params_ptrs[i]);
      } else {
        ZVAL_NULL(&params[i]);
      }
    }
  }
  int result = call_user_function(EG(function_table), NULL, &func_name, retval,
                                  param_count, params);
  zval_ptr_dtor(&func_name);
  if (params) {
    for (int i = 0; i < param_count; i++) {
      zval_ptr_dtor(&params[i]);
    }
    efree(params);
  }
  return result;
}

int vphp_call_static_method(const char *class_name, int class_name_len,
                            const char *method, int method_len, zval *retval,
                            int param_count, zval **params_ptrs) {
  zend_string *callable =
      zend_strpprintf(0, "%.*s::%.*s", class_name_len, class_name, method_len,
                      method);
  zval callable_zv;
  ZVAL_STR(&callable_zv, callable);
  int result =
      vphp_call_callable(&callable_zv, retval, param_count, params_ptrs);
  zval_ptr_dtor(&callable_zv);
  return result;
}

int vphp_new_instance(const char *class_name, int class_name_len, zval *retval,
                      int param_count, zval **params_ptrs) {
  zend_class_entry *ce = vphp_lookup_class_by_name(class_name, class_name_len);
  zval *params = NULL;
  zval ctor_name;
  zval ctor_retval;

  if (!ce) {
    return -1;
  }

  object_init_ex(retval, ce);
  if (!ce->constructor) {
    return param_count == 0 ? SUCCESS : -1;
  }

  ZVAL_STRINGL(&ctor_name, "__construct", sizeof("__construct") - 1);
  if (param_count > 0) {
    params = (zval *)safe_emalloc(param_count, sizeof(zval), 0);
    for (int i = 0; i < param_count; i++) {
      if (params_ptrs[i]) {
        ZVAL_COPY(&params[i], params_ptrs[i]);
      } else {
        ZVAL_NULL(&params[i]);
      }
    }
  }
  ZVAL_UNDEF(&ctor_retval);
  int result = call_user_function(EG(function_table), retval, &ctor_name,
                                  &ctor_retval, param_count, params);
  zval_ptr_dtor(&ctor_name);
  zval_ptr_dtor(&ctor_retval);
  if (params) {
    for (int i = 0; i < param_count; i++) {
      zval_ptr_dtor(&params[i]);
    }
    efree(params);
  }
  return result;
}

int vphp_include_file(const char *filename, int filename_len, zval *retval,
                      int once) {
  zend_file_handle file_handle;
  zend_string *filename_str = zend_string_init(filename, filename_len, 0);
  zend_string *resolved_path = zend_resolve_path(filename_str);
  zend_string_release(filename_str);
  if (once && resolved_path &&
      zend_hash_exists(&EG(included_files), resolved_path)) {
    ZVAL_TRUE(retval);
    zend_string_release(resolved_path);
    return SUCCESS;
  }
  zend_stream_init_filename(&file_handle, filename);
  file_handle.primary_script = 0;
  if (resolved_path) {
    file_handle.opened_path = resolved_path;
  }
  ZVAL_UNDEF(retval);
  return zend_execute_scripts(once ? ZEND_INCLUDE_ONCE : ZEND_INCLUDE, retval, 1,
                              &file_handle);
}

int vphp_call_method(zval *obj, const char *method, int method_len,
                     zval *retval, int param_count, zval **params_ptrs) {
  zval *params = NULL;

  if (!obj || Z_TYPE_P(obj) != IS_OBJECT) {
    return -1;
  }
  ZVAL_UNDEF(retval);
  if (param_count > 0) {
    params = (zval *)safe_emalloc(param_count, sizeof(zval), 0);
    for (int i = 0; i < param_count; i++) {
      if (params_ptrs[i]) {
        ZVAL_COPY(&params[i], params_ptrs[i]);
      } else {
        ZVAL_NULL(&params[i]);
      }
    }
  }
  int result = SUCCESS;
  zval method_name;
  ZVAL_STRINGL(&method_name, method, method_len);
  result = call_user_function(EG(function_table), obj, &method_name, retval,
                              param_count, params);
  zval_ptr_dtor(&method_name);
  if (params) {
    for (int i = 0; i < param_count; i++) {
      zval_ptr_dtor(&params[i]);
    }
    efree(params);
  }
  if (EG(exception) != NULL) {
    return SUCCESS;
  }
  return result;
}

int vphp_is_callable(zval *callable) {
  return callable ? (vphp_zend_is_callable(callable) ? 1 : 0) : 0;
}

int vphp_call_callable(zval *callable, zval *retval, int param_count,
                       zval **params_ptrs) {
  zval *params = NULL;
  zend_fcall_info fci;
  zend_fcall_info_cache fcc;
  char *error = NULL;
  char debug_buf[256];

  if (!callable) {
    vphp_bridge_call_debug_log("vphp_call_callable callable=NULL");
    return -1;
  }
  snprintf(debug_buf, sizeof(debug_buf),
           "vphp_call_callable enter callable=%p retval=%p param_count=%d type=%d",
           (void *)callable, (void *)retval, param_count, Z_TYPE_P(callable));
  vphp_bridge_call_debug_log(debug_buf);
  vphp_bridge_call_debug_log_zval("vphp_call_callable callable_state", callable);
  ZVAL_UNDEF(retval);
  if (zend_fcall_info_init(callable, 0, &fci, &fcc, NULL, &error) != SUCCESS) {
    snprintf(debug_buf, sizeof(debug_buf),
             "vphp_call_callable init_fail callable=%p error=%s", (void *)callable,
             error != NULL ? error : "(null)");
    vphp_bridge_call_debug_log(debug_buf);
    if (error != NULL) {
      efree(error);
    }
    return -1;
  }
  snprintf(debug_buf, sizeof(debug_buf),
           "vphp_call_callable init_ok callable=%p object=%p function_handler=%p",
           (void *)callable, (void *)fci.object, (void *)fcc.function_handler);
  vphp_bridge_call_debug_log(debug_buf);
  if (fcc.object != NULL) {
    zval callable_obj;
    ZVAL_OBJ(&callable_obj, fcc.object);
    vphp_bridge_call_debug_log_zval("vphp_call_callable fcc_object_state",
                                    &callable_obj);
  }
  if (param_count > 0) {
    params = (zval *)safe_emalloc(param_count, sizeof(zval), 0);
    for (int i = 0; i < param_count; i++) {
      if (params_ptrs[i]) {
        ZVAL_COPY(&params[i], params_ptrs[i]);
        snprintf(debug_buf, sizeof(debug_buf),
                 "vphp_call_callable param[%d] src=%p dst=%p", i,
                 (void *)params_ptrs[i], (void *)&params[i]);
        vphp_bridge_call_debug_log(debug_buf);
        vphp_bridge_call_debug_log_zval("vphp_call_callable param_state",
                                        &params[i]);
      } else {
        ZVAL_NULL(&params[i]);
      }
    }
  }
  snprintf(debug_buf, sizeof(debug_buf),
           "vphp_call_callable params_ready callable=%p params=%p count=%d",
           (void *)callable, (void *)params, param_count);
  vphp_bridge_call_debug_log(debug_buf);
  fci.retval = retval;
  fci.param_count = param_count;
  fci.params = params;
  snprintf(debug_buf, sizeof(debug_buf),
           "vphp_call_callable before_zend_call callable=%p retval=%p", (void *)callable,
           (void *)retval);
  vphp_bridge_call_debug_log(debug_buf);
  int result = zend_call_function(&fci, &fcc);
  snprintf(debug_buf, sizeof(debug_buf),
           "vphp_call_callable after_zend_call callable=%p result=%d retval_type=%d exception=%p",
           (void *)callable, result, retval != NULL ? Z_TYPE_P(retval) : -1,
           (void *)EG(exception));
  vphp_bridge_call_debug_log(debug_buf);
  if (params) {
    for (int i = 0; i < param_count; i++) {
      zval_ptr_dtor(&params[i]);
    }
    efree(params);
  }
  vphp_bridge_call_debug_log("vphp_call_callable exit");
  return result;
}

const char *vphp_get_object_class_name(zval *zv, int *len) {
  zend_class_entry *ce = vphp_get_ce_from_zval(zv);
  if (!ce) {
    *len = 0;
    return "";
  }
  *len = ZSTR_LEN(ce->name);
  return ZSTR_VAL(ce->name);
}

const char *vphp_get_parent_class_name(zval *zv, int *len) {
  zend_class_entry *ce = vphp_get_ce_from_zval(zv);
  if (!ce || !ce->parent) {
    *len = 0;
    return "";
  }
  *len = ZSTR_LEN(ce->parent->name);
  return ZSTR_VAL(ce->parent->name);
}

int vphp_class_is_internal(zval *zv) {
  zend_class_entry *ce = vphp_get_ce_from_zval(zv);
  if (!ce) {
    return 0;
  }
  return (ce->type == ZEND_INTERNAL_CLASS) ? 1 : 0;
}

void *vphp_get_this_object(zend_execute_data *execute_data) {
  zval *this_obj = getThis();
  return this_obj ? (void *)Z_OBJ_P(this_obj) : NULL;
}

void *vphp_get_current_this_object(void) {
  zend_execute_data *execute_data = EG(current_execute_data);
  if (execute_data == NULL) {
    return NULL;
  }
  zval *this_obj = getThis();
  return this_obj ? (void *)Z_OBJ_P(this_obj) : NULL;
}

void *vphp_get_active_ce(zend_execute_data *ex) {
  if (ex && ex->func && ex->func->common.scope) {
    return (void *)ex->func->common.scope;
  }
  return NULL;
}

static void ZEND_FASTCALL vphp_closure_handler(zend_execute_data *execute_data,
                                               zval *return_value) {
  zend_internal_function *zf = (zend_internal_function *)execute_data->func;
  void *v_thunk = zf->reserved[0];
  void *bridge_ptr = zf->reserved[1];

  if (bridge_ptr) {
    void (*bridge)(void *, zend_execute_data *, zval *) =
        (void (*)(void *, zend_execute_data *, zval *))bridge_ptr;
    bridge(v_thunk, execute_data, return_value);
  }
}

void vphp_create_closure_FULL_AUTO_V2(zval *zv, void *v_thunk,
                                      void *bridge_ptr) {
  zend_internal_function *zf =
      (zend_internal_function *)pecalloc(1, sizeof(zend_internal_function), 1);
  zf->type = ZEND_INTERNAL_FUNCTION;
  zf->handler = vphp_closure_handler;
  zf->fn_flags = ZEND_ACC_CLOSURE | ZEND_ACC_PUBLIC;
  zf->function_name = zend_string_init("VPHPClosure", 11, 1);
  zf->num_args = 0;
  zf->required_num_args = 0;
  zf->arg_info = NULL;
  zf->reserved[0] = v_thunk;
  zf->reserved[1] = bridge_ptr;

  zend_create_closure(zv, (zend_function *)zf, NULL, NULL, NULL);
}

void vphp_create_closure_with_arity(zval *zv, void *v_thunk, void *bridge_ptr,
                                    int num_args, int required_args) {
  zend_internal_function *zf =
      (zend_internal_function *)pecalloc(1, sizeof(zend_internal_function), 1);
  zf->type = ZEND_INTERNAL_FUNCTION;
  zf->handler = vphp_closure_handler;
  zf->fn_flags = ZEND_ACC_CLOSURE | ZEND_ACC_PUBLIC;
  zf->function_name = zend_string_init("VPHPClosure", 11, 1);
  zf->num_args = num_args;
  zf->required_num_args = required_args;
  zf->arg_info = NULL;
  zf->reserved[0] = v_thunk;
  zf->reserved[1] = bridge_ptr;

  zend_create_closure(zv, (zend_function *)zf, NULL, NULL, NULL);
}

static const zend_internal_arg_info vphp_variadic_closure_arginfo[] = {
    {(const char *)(uintptr_t)(0),
     ZEND_TYPE_INIT_NONE(_ZEND_ARG_INFO_FLAGS(0, 0, 0)), NULL},
    ZEND_ARG_VARIADIC_TYPE_INFO(0, args, IS_MIXED, 0)};

void vphp_create_variadic_closure(zval *zv, void *v_thunk, void *bridge_ptr) {
  zend_internal_function *zf =
      (zend_internal_function *)pecalloc(1, sizeof(zend_internal_function), 1);
  zf->type = ZEND_INTERNAL_FUNCTION;
  zf->handler = vphp_closure_handler;
  zf->fn_flags = ZEND_ACC_CLOSURE | ZEND_ACC_PUBLIC;
  zf->function_name = zend_string_init("VPHPClosure", 11, 1);
  zf->num_args = 1;
  zf->required_num_args = 0;
  zf->arg_info = (zend_internal_arg_info *)vphp_variadic_closure_arginfo + 1;
  zf->reserved[0] = v_thunk;
  zf->reserved[1] = bridge_ptr;

  zend_create_closure(zv, (zend_function *)zf, NULL, NULL, NULL);
}
