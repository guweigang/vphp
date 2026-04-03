long vphp_get_lval(zval *z) { return Z_LVAL_P(z); }

void vphp_set_lval(zval *z, long val) { ZVAL_LONG(z, val); }

char *vphp_get_strval(zval *z) { return Z_STRVAL_P(z); }

int vphp_get_strlen(zval *z) { return Z_STRLEN_P(z); }

int vphp_get_type(zval *z) { return Z_TYPE_P(z); }

const char *vphp_get_string_ptr(zval *z, int *len) {
  if (z && Z_TYPE_P(z) == IS_STRING) {
    *len = Z_STRLEN_P(z);
    return Z_STRVAL_P(z);
  }
  *len = 0;
  return "";
}

void vphp_set_strval(zval *z, char *str, int len) { ZVAL_STRINGL(z, str, len); }

void vphp_set_bool(zval *z, bool val) {
  if (val) {
    ZVAL_TRUE(z);
  } else {
    ZVAL_FALSE(z);
  }
}

void vphp_set_double(zval *z, double val) { ZVAL_DOUBLE(z, val); }

void vphp_set_null(zval *z) { ZVAL_NULL(z); }

bool vphp_is_null(zval *z) {
  return z == NULL || Z_TYPE_P(z) == IS_NULL || Z_TYPE_P(z) == IS_UNDEF;
}

long vphp_get_int(zval *z) {
  if (!z) {
    return 0;
  }
  if (Z_TYPE_P(z) == IS_LONG) {
    return Z_LVAL_P(z);
  }
  return 0;
}

double vphp_get_double(zval *z) {
  if (!z) {
    return 0.0;
  }
  if (Z_TYPE_P(z) == IS_DOUBLE) {
    return Z_DVAL_P(z);
  }
  if (Z_TYPE_P(z) == IS_LONG) {
    return (double)Z_LVAL_P(z);
  }
  return 0.0;
}

static int vphp_bridge_value_debug_enabled(void) {
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

static void vphp_bridge_value_debug_log(const char *message) {
  int mode = vphp_bridge_value_debug_enabled();
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
  fprintf(fp, "[vphp-value-debug] %s\n", message);
  fflush(fp);
  if (mode == 2 && fp != NULL) {
    fclose(fp);
  }
}

static const char *vphp_debug_zval_class_name(zval *z) {
  zend_class_entry *ce = NULL;
  if (z == NULL || Z_TYPE_P(z) != IS_OBJECT) {
    return "(none)";
  }
  ce = Z_OBJCE_P(z);
  if (ce == NULL || ce->name == NULL) {
    return "(null)";
  }
  return ZSTR_VAL(ce->name);
}

static void vphp_debug_log_release_zval(const char *phase, zval *z, int removed) {
  char debug_buf[256];
  int type = z != NULL ? Z_TYPE_P(z) : -1;
  uint32_t refcount = 0;
  if (z != NULL && Z_REFCOUNTED_P(z)) {
    refcount = GC_REFCOUNT(Z_COUNTED_P(z));
  }
  snprintf(debug_buf, sizeof(debug_buf),
           "vphp_release_zval %s z=%p type=%d class=%s refcount=%u removed=%d",
           phase, (void *)z, type, vphp_debug_zval_class_name(z), refcount,
           removed);
  vphp_bridge_value_debug_log(debug_buf);
}

void vphp_convert_to_string(zval *z) {
  if (z && Z_TYPE_P(z) != IS_STRING) {
    convert_to_string(z);
  }
}

static char *vphp_capture_new_zval_origin(void) {
  zend_execute_data *execute_data = EG(current_execute_data);
  const zend_function *func = execute_data != NULL ? execute_data->func : NULL;
  const zend_class_entry *scope = func != NULL ? func->common.scope : NULL;
  const char *file = zend_get_executed_filename();
  uint32_t line = zend_get_executed_lineno();
  const char *func_name =
      (func != NULL && func->common.function_name != NULL)
          ? ZSTR_VAL(func->common.function_name)
          : "(main)";
  const char *scope_name =
      (scope != NULL && scope->name != NULL) ? ZSTR_VAL(scope->name) : NULL;
  char buf[768];
  int written = 0;
  char *out = NULL;

  if (scope_name != NULL) {
    written = snprintf(buf, sizeof(buf), "%s::%s %s:%u", scope_name, func_name,
                       file != NULL ? file : "(unknown)", (unsigned)line);
  } else {
    written = snprintf(buf, sizeof(buf), "%s %s:%u", func_name,
                       file != NULL ? file : "(unknown)", (unsigned)line);
  }
  if (written < 0) {
    return NULL;
  }
  if ((size_t)written >= sizeof(buf)) {
    written = (int)sizeof(buf) - 1;
  }
  out = (char *)emalloc((size_t)written + 1);
  if (out == NULL) {
    return NULL;
  }
  memcpy(out, buf, (size_t)written);
  out[written] = '\0';
  return out;
}

zval *vphp_new_zval() {
  zval *z = (zval *)emalloc(sizeof(zval));
  if (z == NULL) {
    return NULL;
  }
  ZVAL_UNDEF(z);
  vphp_owned_add(z, vphp_capture_new_zval_origin());
  return z;
}

zval *vphp_new_str(const char *s) {
  zval *z = vphp_new_zval();
  ZVAL_STRING(z, s);
  return z;
}

zval *vphp_new_strl(const char *s, int len) {
  zval *z = vphp_new_zval();
  ZVAL_STRINGL(z, s, len);
  return z;
}

void vphp_release_zval(zval *z) {
  int removed = 0;
  if (!z) {
    return;
  }
  vphp_debug_log_release_zval("enter", z, 0);
  removed = vphp_owned_remove(z);
  if (!removed) {
    vphp_debug_log_release_zval("skip_not_owned", z, 0);
    return;
  }
  vphp_debug_log_release_zval("before_dtor", z, removed);
  zval_ptr_dtor(z);
  vphp_bridge_value_debug_log("vphp_release_zval after_dtor");
  efree(z);
  vphp_bridge_value_debug_log("vphp_release_zval after_efree");
}

void vphp_disown_zval(zval *z) {
  if (z == NULL) {
    return;
  }
  vphp_autorelease_forget(z);
  (void)vphp_owned_remove(z);
}

void vphp_object_init(zval *z) { object_init(z); }

void vphp_update_property_string(zval *obj, const char *name, int name_len,
                                 const char *value) {
  add_property_stringl(obj, name, value, strlen(value));
}

void vphp_add_property_double(zval *obj, const char *name, double val) {
  add_property_double(obj, name, val);
}

int vphp_array_count(zval *z) {
  return (z && Z_TYPE_P(z) == IS_ARRAY) ? zend_hash_num_elements(Z_ARRVAL_P(z))
                                        : 0;
}

zval *vphp_array_get_index(zval *z, uint32_t index) {
  return (z && Z_TYPE_P(z) == IS_ARRAY)
             ? zend_hash_index_find(Z_ARRVAL_P(z), index)
             : NULL;
}

zval *vphp_array_get_key(zval *array, const char *key, int key_len) {
  return (array && Z_TYPE_P(array) == IS_ARRAY)
             ? zend_hash_str_find(Z_ARRVAL_P(array), key, key_len)
             : NULL;
}

void vphp_array_init(zval *z) { array_init(z); }

void vphp_array_push_string(zval *z, const char *val) {
  add_next_index_string(z, val);
}

void vphp_array_push_stringl(zval *z, const char *val, int len) {
  add_next_index_stringl(z, val, len);
}

void vphp_array_push_double(zval *z, double val) {
  add_next_index_double(z, val);
}

void vphp_array_push_long(zval *z, long val) { add_next_index_long(z, val); }

void vphp_array_add_assoc_long(zval *return_value, const char *key, long val) {
  add_assoc_long(return_value, key, val);
}

void vphp_array_add_assoc_bool(zval *return_value, const char *key, int val) {
  add_assoc_bool(return_value, key, val);
}

void vphp_array_add_assoc_double(zval *return_value, const char *key,
                                 double val) {
  add_assoc_double(return_value, key, val);
}

void vphp_array_add_assoc_string(zval *z, const char *key, const char *val) {
  add_assoc_string(z, key, val);
}

void vphp_array_add_assoc_zval(zval *z, const char *key, zval *val) {
  if (z == NULL || key == NULL || val == NULL) {
    return;
  }
  Z_TRY_ADDREF_P(val);
  add_assoc_zval(z, key, val);
}

void vphp_array_add_next_zval(zval *main_array, zval *sub_item) {
  if (main_array == NULL || sub_item == NULL) {
    return;
  }
  Z_TRY_ADDREF_P(sub_item);
  add_next_index_zval(main_array, sub_item);
}

void vphp_return_array_start(zval *return_value) { array_init(return_value); }

void vphp_zval_foreach(zval *z, void *ctx,
                       void (*callback)(void *, zval *, zval *)) {
  if (!z) {
    return;
  }

  if (Z_TYPE_P(z) == IS_ARRAY) {
    HashTable *ht = Z_ARRVAL_P(z);
    zend_string *key;
    zend_ulong index;
    zval *val;
    ZEND_HASH_FOREACH_KEY_VAL(ht, index, key, val) {
      zval key_zv;
      if (key) {
        ZVAL_STR(&key_zv, key);
      } else {
        ZVAL_LONG(&key_zv, index);
      }
      callback(ctx, &key_zv, val);
    }
    ZEND_HASH_FOREACH_END();
    return;
  }

  if (Z_TYPE_P(z) == IS_OBJECT) {
    zend_class_entry *ce = Z_OBJCE_P(z);

    if (ce && ce->get_iterator) {
      zend_object_iterator *iter = ce->get_iterator(ce, z, 0);
      if (iter) {
        if (iter->funcs->rewind) {
          iter->funcs->rewind(iter);
        }
        while (iter->funcs->valid(iter) == SUCCESS) {
          zval key_zv;
          zval *val = iter->funcs->get_current_data(iter);
          if (iter->funcs->get_current_key) {
            iter->funcs->get_current_key(iter, &key_zv);
          } else {
            ZVAL_LONG(&key_zv, iter->index);
          }
          callback(ctx, &key_zv, val);
          zval_ptr_dtor(&key_zv);
          iter->funcs->move_forward(iter);
        }
        zend_iterator_dtor(iter);
        return;
      }
    }

    HashTable *ht = Z_OBJPROP_P(z);
    zend_string *key;
    zend_ulong index;
    zval *val;
    ZEND_HASH_FOREACH_KEY_VAL(ht, index, key, val) {
      zval key_zv;
      if (key) {
        ZVAL_STR(&key_zv, key);
      } else {
        ZVAL_LONG(&key_zv, index);
      }
      callback(ctx, &key_zv, val);
    }
    ZEND_HASH_FOREACH_END();
  }
}

void vphp_array_foreach(zval *z, void *ctx, void (*callback)(void *, zval *)) {
  if (z && Z_TYPE_P(z) == IS_ARRAY) {
    zval *val;
    ZEND_HASH_FOREACH_VAL(Z_ARRVAL_P(z), val) { callback(ctx, val); }
    ZEND_HASH_FOREACH_END();
  }
}

int le_vphp_res;

void vphp_res_dtor(zend_resource *res) {
  if (res == NULL) {
    return;
  }
  vphp_res_t *wrapper = (vphp_res_t *)res->ptr;
  if (wrapper != NULL) {
    if (wrapper->label != NULL && strcmp(wrapper->label, "v_task") == 0 &&
        wrapper->ptr != NULL) {
      efree(wrapper->ptr);
      wrapper->ptr = NULL;
    }
    if (wrapper->label != NULL) {
      efree(wrapper->label);
      wrapper->label = NULL;
    }
    efree(wrapper);
    res->ptr = NULL;
  }
}

void vphp_init_resource_system(int module_number) {
  le_vphp_res = zend_register_list_destructors_ex(
      vphp_res_dtor, NULL, "VPHP Generic Resource", module_number);
}

void vphp_make_res(zval *return_value, void *ptr, const char *label) {
  if (!ptr) {
    RETVAL_NULL();
    return;
  }
  vphp_res_t *wrapper = emalloc(sizeof(vphp_res_t));
  wrapper->ptr = ptr;
  wrapper->label = estrdup(label != NULL ? label : "");
  RETVAL_RES(zend_register_resource(wrapper, le_vphp_res));
}

void *vphp_fetch_res(zval *z) {
  vphp_res_t *wrapper = (vphp_res_t *)zend_fetch_resource(
      Z_RES_P(z), "VPHP Generic Resource", le_vphp_res);
  return wrapper ? wrapper->ptr : NULL;
}

zval *vphp_read_static_property_compat(const char *class_name, int class_name_len,
                                       const char *name, int name_len, zval *rv) {
  zend_class_entry *ce = vphp_lookup_class_by_name(class_name, class_name_len);
  if (!ce) {
    ZVAL_NULL(rv);
    return rv;
  }
  zval *prop = vphp_zend_read_static_property(ce, name, (size_t)name_len);
  if (!prop) {
    ZVAL_NULL(rv);
    return rv;
  }
  ZVAL_COPY(rv, prop);
  return rv;
}

int vphp_write_static_property_compat(const char *class_name, int class_name_len,
                                      const char *name, int name_len,
                                      zval *value) {
  zend_class_entry *ce = vphp_lookup_class_by_name(class_name, class_name_len);
  if (!ce) {
    return -1;
  }
  vphp_zend_update_static_property(ce, name, (size_t)name_len, value);
  return 0;
}

zval *vphp_read_class_constant_compat(const char *class_name, int class_name_len,
                                      const char *name, int name_len, zval *rv) {
  zend_string *class_name_str = zend_string_init(class_name, class_name_len, 0);
  zend_string *const_name_str = zend_string_init(name, name_len, 0);
  zval *constant =
      vphp_zend_get_class_constant(class_name_str, const_name_str);
  zend_string_release(class_name_str);
  zend_string_release(const_name_str);
  if (!constant) {
    ZVAL_NULL(rv);
    return rv;
  }
  ZVAL_COPY(rv, constant);
  return rv;
}

void vphp_update_static_property_long(zend_class_entry *ce, char *name,
                                      int name_len, long val) {
  vphp_zend_update_static_property_long(ce, name, (size_t)name_len, val);
}

void vphp_update_static_property_string(zend_class_entry *ce, char *name,
                                        int name_len, char *val, int val_len) {
  vphp_zend_update_static_property_string(ce, name, (size_t)name_len, val,
                                          (size_t)val_len);
}

void vphp_update_static_property_bool(zend_class_entry *ce, char *name,
                                      int name_len, int val) {
  vphp_zend_update_static_property_bool(ce, name, (size_t)name_len, val != 0);
}

long vphp_get_static_property_long(zend_class_entry *ce, char *name,
                                   int name_len) {
  zval *rv = vphp_zend_read_static_property(ce, name, (size_t)name_len);
  return rv ? zval_get_long(rv) : 0;
}

char *vphp_get_static_property_string(zend_class_entry *ce, char *name,
                                      int name_len) {
  zval *rv = vphp_zend_read_static_property(ce, name, (size_t)name_len);
  if (rv) {
    zend_string *s = zval_get_string(rv);
    return ZSTR_VAL(s);
  }
  return "";
}

int vphp_get_static_property_bool(zend_class_entry *ce, char *name,
                                  int name_len) {
  zval *rv = vphp_zend_read_static_property(ce, name, (size_t)name_len);
  return rv ? zval_is_true(rv) : 0;
}

char *VPHP_Z_STRVAL(zval *z) { return Z_STRVAL_P(z); }

int VPHP_Z_STRLEN(zval *z) { return Z_STRLEN_P(z); }
