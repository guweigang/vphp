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
  zend_function *fn_proxy = NULL;

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
  if (param_count == 0) {
    zend_call_method_with_0_params(Z_OBJ_P(obj), Z_OBJCE_P(obj), &fn_proxy, method,
                                   retval);
  } else if (param_count == 1) {
    zend_call_method_with_1_params(Z_OBJ_P(obj), Z_OBJCE_P(obj), &fn_proxy, method,
                                   retval, &params[0]);
  } else if (param_count == 2) {
    zend_call_method_with_2_params(Z_OBJ_P(obj), Z_OBJCE_P(obj), &fn_proxy, method,
                                   retval, &params[0], &params[1]);
  } else {
    zval method_name;
    ZVAL_STRINGL(&method_name, method, method_len);
    result = call_user_function(EG(function_table), obj, &method_name, retval,
                                param_count, params);
    zval_ptr_dtor(&method_name);
  }
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

  if (!callable) {
    return -1;
  }
  ZVAL_UNDEF(retval);
  if (zend_fcall_info_init(callable, 0, &fci, &fcc, NULL, &error) != SUCCESS) {
    if (error != NULL) {
      efree(error);
    }
    return -1;
  }
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
  fci.retval = retval;
  fci.param_count = param_count;
  fci.params = params;
  int result = zend_call_function(&fci, &fcc);
  if (params) {
    for (int i = 0; i < param_count; i++) {
      zval_ptr_dtor(&params[i]);
    }
    efree(params);
  }
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
