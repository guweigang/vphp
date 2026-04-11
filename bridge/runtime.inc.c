static zend_class_entry *vphp_type_scope_ce(zend_execute_data *execute_data,
                                            const char *name) {
  zend_class_entry *scope = execute_data && execute_data->func
                                ? execute_data->func->common.scope
                                : NULL;
  zend_class_entry *called_scope =
      execute_data ? vphp_zend_get_called_scope(execute_data) : NULL;

  if (scope == NULL || name == NULL) {
    return NULL;
  }
  if (strcmp(name, "self") == 0) {
    return scope;
  }
  if (strcmp(name, "parent") == 0) {
    return scope->parent;
  }
  if (strcmp(name, "static") == 0) {
    return called_scope ? called_scope : scope;
  }
  return NULL;
}

static zend_string *vphp_normalize_literal_type_name(const char *literal_name) {
  size_t len = 0;
  size_t i = 0;
  size_t out_len = 0;
  char *buffer = NULL;
  zend_string *normalized = NULL;

  if (literal_name == NULL) {
    return NULL;
  }

  len = strlen(literal_name);
  buffer = emalloc(len + 1);
  for (i = 0; i < len; i++) {
    if (literal_name[i] == '\\' && i + 1 < len && literal_name[i + 1] == '\\') {
      buffer[out_len++] = '\\';
      i++;
      continue;
    }
    buffer[out_len++] = literal_name[i];
  }
  buffer[out_len] = '\0';
  normalized = zend_string_init(buffer, out_len, 0);
  efree(buffer);
  return normalized;
}

static zend_class_entry *vphp_lookup_type_ce(zend_execute_data *execute_data,
                                             zend_type type) {
  const char *literal_name = NULL;
  zend_string *name = NULL;
  zend_class_entry *ce = NULL;

  if (ZEND_TYPE_HAS_NAME(type)) {
    name = ZEND_TYPE_NAME(type);
    return vphp_zend_lookup_class(name);
  }
  if (!ZEND_TYPE_HAS_LITERAL_NAME(type)) {
    return NULL;
  }

  literal_name = ZEND_TYPE_LITERAL_NAME(type);
  name = vphp_normalize_literal_type_name(literal_name);
  ce = vphp_type_scope_ce(execute_data, ZSTR_VAL(name));
  if (ce != NULL) {
    zend_string_release(name);
    return ce;
  }
  if (execute_data && execute_data->func && execute_data->func->common.scope &&
      strcmp(ZSTR_VAL(execute_data->func->common.scope->name), ZSTR_VAL(name)) ==
          0) {
    zend_string_release(name);
    return execute_data->func->common.scope;
  }
  ce = vphp_zend_lookup_class(name);
  zend_string_release(name);
  return ce;
}

static bool vphp_value_matches_named_type(zend_execute_data *execute_data,
                                          zend_type type, zval *value,
                                          bool is_return_type) {
  zval *check = value;
  zend_class_entry *ce = NULL;
  zend_string *expected_name = NULL;
  bool release_expected_name = false;

  if (check == NULL) {
    return false;
  }
  ZVAL_DEREF(check);
  if (Z_TYPE_P(check) != IS_OBJECT) {
    return false;
  }
  vphp_preload_auto_interfaces_for_class(Z_OBJCE_P(check));
  vphp_apply_auto_interface_bindings_for_class(Z_OBJCE_P(check));

  if (ZEND_TYPE_HAS_NAME(type)) {
    expected_name = ZEND_TYPE_NAME(type);
  } else if (ZEND_TYPE_HAS_LITERAL_NAME(type)) {
    expected_name = vphp_normalize_literal_type_name(ZEND_TYPE_LITERAL_NAME(type));
    release_expected_name = true;
  }
  if (expected_name != NULL &&
      zend_string_equals_ci(Z_OBJCE_P(check)->name, expected_name)) {
    if (release_expected_name) {
      zend_string_release(expected_name);
    }
    return true;
  }

  ce = vphp_lookup_type_ce(execute_data, type);
  if (ce == NULL) {
    bool unresolved_match = vphp_object_matches_unresolved_named_type(
        Z_OBJCE_P(check), expected_name);
    if (release_expected_name) {
      zend_string_release(expected_name);
    }
    return unresolved_match;
  }
  vphp_preload_auto_interfaces_for_class(Z_OBJCE_P(check));
  vphp_apply_auto_interface_bindings_for_class(Z_OBJCE_P(check));
  if ((ce->ce_flags & ZEND_ACC_INTERFACE) &&
      vphp_zend_class_implements_interface(Z_OBJCE_P(check), ce)) {
    if (release_expected_name) {
      zend_string_release(expected_name);
    }
    return true;
  }
  if (instanceof_function(Z_OBJCE_P(check), ce) != 0) {
    if (release_expected_name) {
      zend_string_release(expected_name);
    }
    return true;
  }
  if (expected_name != NULL) {
    zval retval;
    zval expected_zv;
    zval *params[2] = {check, &expected_zv};
    int result = 0;

    ZVAL_UNDEF(&retval);
    ZVAL_STR_COPY(&expected_zv, expected_name);
    result = vphp_call_php_func("is_a", 4, &retval, 2, params);
    zval_ptr_dtor(&expected_zv);
    if (result == SUCCESS) {
      bool matched = zend_is_true(&retval) != 0;
      zval_ptr_dtor(&retval);
      if (matched) {
        if (release_expected_name) {
          zend_string_release(expected_name);
        }
        return true;
      }
    }
  }
  if (release_expected_name) {
    zend_string_release(expected_name);
  }
  return false;
}

static bool vphp_value_matches_mask(uint32_t mask, zval *value, bool strict,
                                    bool is_return_type) {
  zval *check = value;
  uint32_t scalar_mask = 0;

  if (check == NULL) {
    return false;
  }
  ZVAL_DEREF(check);

  if ((mask & MAY_BE_ANY) == MAY_BE_ANY) {
    return true;
  }
  if ((mask & MAY_BE_TRUE) && Z_TYPE_P(check) == IS_TRUE) {
    return true;
  }
  if ((mask & MAY_BE_FALSE) && Z_TYPE_P(check) == IS_FALSE) {
    return true;
  }
  if ((mask & MAY_BE_STRING) && Z_TYPE_P(check) == IS_STRING) {
    return true;
  }
  if ((mask & MAY_BE_LONG) && Z_TYPE_P(check) == IS_LONG) {
    return true;
  }
  if ((mask & MAY_BE_DOUBLE) && Z_TYPE_P(check) == IS_DOUBLE) {
    return true;
  }
  if ((mask & MAY_BE_BOOL) == MAY_BE_BOOL &&
      (Z_TYPE_P(check) == IS_TRUE || Z_TYPE_P(check) == IS_FALSE)) {
    return true;
  }
  if ((mask & MAY_BE_ARRAY) && Z_TYPE_P(check) == IS_ARRAY) {
    return true;
  }
  if ((mask & MAY_BE_OBJECT) && Z_TYPE_P(check) == IS_OBJECT) {
    return true;
  }
  if ((mask & MAY_BE_RESOURCE) && Z_TYPE_P(check) == IS_RESOURCE) {
    return true;
  }
  if ((mask & MAY_BE_CALLABLE) && vphp_zend_is_callable(check)) {
    return true;
  }
  if ((mask & MAY_BE_VOID) && is_return_type && Z_TYPE_P(check) == IS_NULL) {
    return true;
  }

  if ((mask & MAY_BE_BOOL) == MAY_BE_BOOL) {
    scalar_mask |= MAY_BE_BOOL;
  }
  scalar_mask |= mask & (MAY_BE_LONG | MAY_BE_DOUBLE | MAY_BE_STRING);
  if (scalar_mask != 0 &&
      vphp_zend_verify_scalar_type_hint(scalar_mask, check, strict)) {
    return true;
  }

  return false;
}

static bool vphp_value_matches_type(zend_execute_data *execute_data,
                                    zend_type type, zval *value,
                                    bool is_return_type) {
  zval *check = value;
  uint32_t mask = ZEND_TYPE_PURE_MASK(type);
  bool strict = execute_data && execute_data->prev_execute_data
                    ? ZEND_CALL_USES_STRICT_TYPES(execute_data->prev_execute_data)
                    : false;

  if (!ZEND_TYPE_IS_SET(type)) {
    return true;
  }
  if (check == NULL) {
    return false;
  }
  ZVAL_DEREF(check);

  if (Z_TYPE_P(check) == IS_NULL) {
    return ZEND_TYPE_ALLOW_NULL(type) || (mask & MAY_BE_NULL) != 0;
  }

  if (ZEND_TYPE_HAS_LIST(type)) {
    const zend_type *subtype = NULL;

    if (ZEND_TYPE_IS_INTERSECTION(type)) {
      ZEND_TYPE_LIST_FOREACH(ZEND_TYPE_LIST(type), subtype) {
        if (!vphp_value_matches_type(execute_data, *subtype, check,
                                     is_return_type)) {
          return false;
        }
      }
      ZEND_TYPE_LIST_FOREACH_END();
      return true;
    }

    ZEND_TYPE_LIST_FOREACH(ZEND_TYPE_LIST(type), subtype) {
      if (vphp_value_matches_type(execute_data, *subtype, check,
                                  is_return_type)) {
        return true;
      }
    }
    ZEND_TYPE_LIST_FOREACH_END();
    return false;
  }

  if (ZEND_TYPE_IS_ITERABLE_FALLBACK(type) && vphp_zend_is_iterable(check)) {
    return true;
  }
  if (ZEND_TYPE_HAS_NAME(type) || ZEND_TYPE_HAS_LITERAL_NAME(type)) {
    if (vphp_value_matches_named_type(execute_data, type, check, is_return_type)) {
      return true;
    }
  }
  if (vphp_value_matches_mask(mask, check, strict, is_return_type)) {
    return true;
  }
  if (vphp_zend_check_user_type_slow(&type, check, is_return_type)) {
    return true;
  }
  return false;
}

bool vphp_validate_internal_call(zend_execute_data *execute_data) {
  const zend_function *func = execute_data ? execute_data->func : NULL;
  uint32_t arg_count = 0;
  uint32_t min_args = 0;
  uint32_t max_args = 0;
  bool variadic = false;
  uint32_t i = 0;

  if (func == NULL) {
    return true;
  }

  arg_count = ZEND_CALL_NUM_ARGS(execute_data);
  min_args = func->common.required_num_args;
  max_args = func->common.num_args;
  variadic = max_args > 0 &&
             ZEND_ARG_IS_VARIADIC(&func->common.arg_info[max_args - 1]);

  if (arg_count < min_args || (!variadic && arg_count > max_args)) {
    vphp_zend_wrong_parameters_count_error(min_args,
                                           variadic ? (uint32_t)-1 : max_args);
    return false;
  }

  for (i = 0; i < arg_count; i++) {
    zend_arg_info *arg_info = NULL;
    zval *arg = NULL;

    if (func->common.arg_info == NULL) {
      break;
    }

    if (variadic && i >= max_args - 1) {
      arg_info = &func->common.arg_info[max_args - 1];
    } else if (i < max_args) {
      arg_info = &func->common.arg_info[i];
    } else {
      break;
    }

    if (!ZEND_TYPE_IS_SET(arg_info->type)) {
      continue;
    }
    arg = ZEND_CALL_ARG(execute_data, i + 1);
    if (vphp_value_matches_type(execute_data, arg_info->type, arg, false)) {
      continue;
    }

    vphp_zend_verify_arg_error(func, arg_info, i + 1, arg);
    return false;
  }

  return true;
}

bool vphp_validate_internal_return(zend_execute_data *execute_data,
                                   zval *return_value) {
  const zend_function *func = execute_data ? execute_data->func : NULL;
  zend_arg_info *ret_info = NULL;
  zval *check = return_value;

  if (func == NULL || func->common.arg_info == NULL) {
    return true;
  }

  ret_info = func->common.arg_info - 1;
  if (!ZEND_TYPE_IS_SET(ret_info->type)) {
    return true;
  }
  if (EG(exception)) {
    return false;
  }
  if (check != NULL) {
    ZVAL_DEREF(check);
  }
  if (ZEND_TYPE_CONTAINS_CODE(ret_info->type, IS_VOID)) {
    if (check != NULL && Z_TYPE_P(check) == IS_UNDEF) {
      return true;
    }
    vphp_zend_verify_return_error(func, return_value);
    return false;
  }
  if (ZEND_TYPE_CONTAINS_CODE(ret_info->type, IS_NEVER)) {
    vphp_zend_verify_never_error(func);
    return false;
  }
  if (vphp_value_matches_type(execute_data, ret_info->type, return_value,
                              true)) {
    return true;
  }

  vphp_zend_verify_return_error(func, return_value);
  return false;
}

void vphp_mark_void_return(zval *return_value) {
  if (return_value == NULL) {
    return;
  }
  ZVAL_UNDEF(return_value);
}

uint32_t vphp_get_num_args(zend_execute_data *ex) {
  return ZEND_CALL_NUM_ARGS(ex);
}

zval *vphp_get_arg_ptr(zend_execute_data *ex, uint32_t index) {
  return ZEND_CALL_ARG(ex, index);
}

void vphp_throw(char *msg, int code) {
  zend_throw_exception(NULL, msg, (zend_long)code);
}

void vphp_throw_class(char *class_name, char *msg, int code) {
  zend_class_entry *ce = NULL;
  zend_string *cls = NULL;
  if (class_name != NULL) {
    cls = zend_string_init(class_name, strlen(class_name), 0);
    ce = vphp_autoload_class(cls);
    if (ce != NULL) {
      vphp_preload_auto_interfaces_for_class(ce);
    }
    zend_string_release(cls);
  }
  zend_throw_exception(ce, msg, (zend_long)code);
}

void vphp_throw_object(zval *exception) {
  zval copy;
  if (exception == NULL || Z_TYPE_P(exception) != IS_OBJECT) {
    zend_throw_exception(NULL, "exception object must be a valid object", 0);
    return;
  }
  ZVAL_COPY(&copy, exception);
  zend_throw_exception_object(&copy);
}

void vphp_error(int level, char *msg) { php_error(level, "%s", msg); }

void vphp_output_write(const char *msg, int len) {
  if (msg == NULL || len <= 0) {
    return;
  }
  PHPWRITE(msg, len);
}

bool vphp_has_exception() { return EG(exception) != NULL; }

static int vphp_runtime_debug_enabled(void) {
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

static void vphp_runtime_debug_log(const char *message) {
  int mode = vphp_runtime_debug_enabled();
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
  fprintf(fp, "[vphp-runtime-debug] %s\n", message);
  fflush(fp);
  if (mode == 2 && fp != NULL) {
    fclose(fp);
  }
}

static void vphp_runtime_debug_log_pools(const char *phase) {
  char debug_buf[256];
  snprintf(debug_buf, sizeof(debug_buf),
           "request_shutdown %s owned_len=%d autorelease_len=%d registry=%u reverse=%u sidecar=%u",
           phase, vphp_owned_pool.len, vphp_autorelease_pool.len,
           vphp_registry_initialized
               ? zend_hash_num_elements(&vphp_object_registry)
               : 0,
           vphp_registry_initialized
               ? zend_hash_num_elements(&vphp_reverse_registry)
               : 0,
           vphp_sidecar_registry_initialized
               ? zend_hash_num_elements(&vphp_sidecar_registry)
               : 0);
  vphp_runtime_debug_log(debug_buf);
}

static const char *vphp_runtime_debug_zval_class_name(zval *z) {
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

static void vphp_runtime_debug_dump_owned_pool(const char *phase, int limit) {
  char debug_buf[512];
  int emitted = 0;
  for (int i = vphp_owned_pool.len - 1; i >= 0; i--) {
    zval *z = vphp_owned_pool.items[i];
    const char *origin = "(unknown)";
    uint32_t refcount = 0;
    if (z == NULL) {
      continue;
    }
    if (vphp_owned_pool.origins != NULL && vphp_owned_pool.origins[i] != NULL) {
      origin = vphp_owned_pool.origins[i];
    }
    if (Z_REFCOUNTED_P(z)) {
      refcount = GC_REFCOUNT(Z_COUNTED_P(z));
    }
    if (Z_TYPE_P(z) == IS_STRING) {
      size_t src_len = Z_STRLEN_P(z);
      size_t copy_len = src_len < 96 ? src_len : 96;
      char snippet[97];
      memset(snippet, 0, sizeof(snippet));
      if (copy_len > 0) {
        memcpy(snippet, Z_STRVAL_P(z), copy_len);
      }
      snprintf(debug_buf, sizeof(debug_buf),
               "owned_pool %s idx=%d z=%p type=%d class=%s refcount=%u origin=%s strlen=%zu str=\"%s%s\"",
               phase, i, (void *)z, Z_TYPE_P(z),
               vphp_runtime_debug_zval_class_name(z), refcount, origin, src_len,
               snippet, src_len > copy_len ? "..." : "");
    } else if (Z_TYPE_P(z) == IS_ARRAY) {
      zend_array *arr = Z_ARRVAL_P(z);
      zend_ulong idx_key = 0;
      zend_string *str_key = NULL;
      zval *item = NULL;
      char keys[160];
      size_t used = 0;
      int key_count = 0;
      memset(keys, 0, sizeof(keys));
      ZEND_HASH_FOREACH_KEY_VAL(arr, idx_key, str_key, item) {
        char piece[48];
        (void)item;
        if (key_count >= 4 || used >= sizeof(keys) - 1) {
          break;
        }
        if (str_key != NULL) {
          snprintf(piece, sizeof(piece), "%s%.*s", key_count == 0 ? "" : ",",
                   24, ZSTR_VAL(str_key));
        } else {
          snprintf(piece, sizeof(piece), "%s%lu", key_count == 0 ? "" : ",",
                   (unsigned long)idx_key);
        }
        size_t piece_len = strlen(piece);
        if (piece_len == 0 || used + piece_len >= sizeof(keys) - 1) {
          break;
        }
        memcpy(keys + used, piece, piece_len);
        used += piece_len;
        keys[used] = '\0';
        key_count++;
      }
      ZEND_HASH_FOREACH_END();
      snprintf(debug_buf, sizeof(debug_buf),
               "owned_pool %s idx=%d z=%p type=%d class=%s refcount=%u origin=%s array_count=%u keys=%s",
               phase, i, (void *)z, Z_TYPE_P(z),
               vphp_runtime_debug_zval_class_name(z), refcount, origin,
               (unsigned)zend_hash_num_elements(arr),
               used > 0 ? keys : "(none)");
    } else if (Z_TYPE_P(z) == IS_LONG) {
      snprintf(debug_buf, sizeof(debug_buf),
               "owned_pool %s idx=%d z=%p type=%d class=%s refcount=%u origin=%s long=%lld",
               phase, i, (void *)z, Z_TYPE_P(z),
               vphp_runtime_debug_zval_class_name(z), refcount, origin,
               (long long)Z_LVAL_P(z));
    } else {
      snprintf(debug_buf, sizeof(debug_buf),
               "owned_pool %s idx=%d z=%p type=%d class=%s refcount=%u origin=%s",
               phase, i, (void *)z, Z_TYPE_P(z),
               vphp_runtime_debug_zval_class_name(z), refcount, origin);
    }
    vphp_runtime_debug_log(debug_buf);
    emitted++;
    if (limit > 0 && emitted >= limit) {
      break;
    }
  }
}

static void vphp_runtime_debug_dump_autorelease_range(const char *phase, int mark,
                                                      int limit) {
  char debug_buf[512];
  int emitted = 0;
  if (mark < 0) {
    mark = 0;
  }
  for (int i = vphp_autorelease_pool.len - 1; i >= mark; i--) {
    zval *z = vphp_autorelease_pool.items[i];
    uint32_t refcount = 0;
    if (z == NULL) {
      continue;
    }
    if (Z_REFCOUNTED_P(z)) {
      refcount = GC_REFCOUNT(Z_COUNTED_P(z));
    }
    snprintf(debug_buf, sizeof(debug_buf),
             "autorelease_pool %s idx=%d z=%p type=%d class=%s refcount=%u",
             phase, i, (void *)z, Z_TYPE_P(z),
             vphp_runtime_debug_zval_class_name(z), refcount);
    vphp_runtime_debug_log(debug_buf);
    emitted++;
    if (limit > 0 && emitted >= limit) {
      break;
    }
  }
}

static bool vphp_owned_contains(zval *z) {
  if (z == NULL) {
    return false;
  }
  for (int i = vphp_owned_pool.len - 1; i >= 0; i--) {
    if (vphp_owned_pool.items[i] == z) {
      return true;
    }
  }
  return false;
}

static void vphp_owned_add(zval *z, char *origin) {
  if (z == NULL || vphp_owned_contains(z)) {
    if (origin != NULL) {
      efree(origin);
    }
    return;
  }
  if (vphp_owned_pool.len >= vphp_owned_pool.cap) {
    int new_cap = vphp_owned_pool.cap == 0 ? 64 : vphp_owned_pool.cap * 2;
    size_t bytes = (size_t)new_cap * sizeof(zval *);
    size_t origin_bytes = (size_t)new_cap * sizeof(char *);
    int old_cap = vphp_owned_pool.cap;
    if (vphp_owned_pool.items == NULL) {
      vphp_owned_pool.items = (zval **)pemalloc(bytes, 1);
    } else {
      vphp_owned_pool.items =
          (zval **)perealloc(vphp_owned_pool.items, bytes, 1);
    }
    if (vphp_owned_pool.origins == NULL) {
      vphp_owned_pool.origins = (char **)pemalloc(origin_bytes, 1);
      if (vphp_owned_pool.origins != NULL) {
        memset(vphp_owned_pool.origins, 0, origin_bytes);
      }
    } else {
      vphp_owned_pool.origins =
          (char **)perealloc(vphp_owned_pool.origins, origin_bytes, 1);
      if (vphp_owned_pool.origins != NULL && new_cap > old_cap) {
        memset(vphp_owned_pool.origins + old_cap, 0,
               (size_t)(new_cap - old_cap) * sizeof(char *));
      }
    }
    if (vphp_owned_pool.items == NULL) {
      vphp_owned_pool.cap = 0;
      vphp_owned_pool.len = 0;
      if (origin != NULL) {
        efree(origin);
      }
      return;
    }
    vphp_owned_pool.cap = new_cap;
  }
  vphp_owned_pool.items[vphp_owned_pool.len] = z;
  if (vphp_owned_pool.origins != NULL) {
    vphp_owned_pool.origins[vphp_owned_pool.len] = origin;
  } else if (origin != NULL) {
    efree(origin);
  }
  vphp_owned_pool.len++;
}

static bool vphp_owned_remove(zval *z) {
  if (z == NULL || vphp_owned_pool.len == 0) {
    return false;
  }
  for (int i = vphp_owned_pool.len - 1; i >= 0; i--) {
    if (vphp_owned_pool.items[i] == z) {
      if (vphp_owned_pool.origins != NULL && vphp_owned_pool.origins[i] != NULL) {
        efree(vphp_owned_pool.origins[i]);
      }
      vphp_owned_pool.items[i] = vphp_owned_pool.items[vphp_owned_pool.len - 1];
      if (vphp_owned_pool.origins != NULL) {
        vphp_owned_pool.origins[i] =
            vphp_owned_pool.origins[vphp_owned_pool.len - 1];
        vphp_owned_pool.origins[vphp_owned_pool.len - 1] = NULL;
      }
      vphp_owned_pool.items[vphp_owned_pool.len - 1] = NULL;
      vphp_owned_pool.len--;
      return true;
    }
  }
  return false;
}

int vphp_autorelease_mark(void) { return vphp_autorelease_pool.len; }

void vphp_autorelease_add(zval *z) {
  if (z == NULL) {
    return;
  }
  if (!vphp_owned_contains(z)) {
    return;
  }
  for (int i = vphp_autorelease_pool.len - 1; i >= 0; i--) {
    if (vphp_autorelease_pool.items[i] == z) {
      return;
    }
  }
  if (vphp_autorelease_pool.len >= vphp_autorelease_pool.cap) {
    int new_cap =
        vphp_autorelease_pool.cap == 0 ? 32 : vphp_autorelease_pool.cap * 2;
    size_t bytes = (size_t)new_cap * sizeof(zval *);
    if (vphp_autorelease_pool.items == NULL) {
      vphp_autorelease_pool.items = (zval **)pemalloc(bytes, 1);
    } else {
      vphp_autorelease_pool.items =
          (zval **)perealloc(vphp_autorelease_pool.items, bytes, 1);
    }
    if (vphp_autorelease_pool.items == NULL) {
      vphp_autorelease_pool.cap = 0;
      vphp_autorelease_pool.len = 0;
      return;
    }
    vphp_autorelease_pool.cap = new_cap;
  }
  vphp_autorelease_pool.items[vphp_autorelease_pool.len++] = z;
}

void vphp_autorelease_forget(zval *z) {
  if (z == NULL || vphp_autorelease_pool.len == 0) {
    return;
  }
  for (int i = vphp_autorelease_pool.len - 1; i >= 0; i--) {
    if (vphp_autorelease_pool.items[i] == z) {
      vphp_autorelease_pool.items[i] = NULL;
    }
  }
}

void vphp_autorelease_drain(int mark) {
  if (mark < 0 || mark > vphp_autorelease_pool.len) {
    return;
  }
  if (vphp_runtime_debug_enabled() != 0 && vphp_autorelease_pool.len > mark) {
    char debug_buf[128];
    snprintf(debug_buf, sizeof(debug_buf),
             "autorelease_drain mark=%d len=%d", mark, vphp_autorelease_pool.len);
    vphp_runtime_debug_log(debug_buf);
    vphp_runtime_debug_dump_autorelease_range("before_drain", mark, 32);
  }
  if (EG(exception) != NULL) {
    for (int i = vphp_autorelease_pool.len - 1; i >= mark; i--) {
      zval *z = vphp_autorelease_pool.items[i];
      if (z != NULL) {
        (void)vphp_owned_remove(z);
      }
      vphp_autorelease_pool.items[i] = NULL;
    }
    vphp_autorelease_pool.len = mark;
    return;
  }
  for (int i = vphp_autorelease_pool.len - 1; i >= mark; i--) {
    zval *z = vphp_autorelease_pool.items[i];
    if (z != NULL) {
      vphp_release_zval(z);
    }
  }
  vphp_autorelease_pool.len = mark;
}

void vphp_runtime_counters(int *autorelease_len, int *owned_len,
                           unsigned int *obj_registry_len,
                           unsigned int *rev_registry_len) {
  if (autorelease_len != NULL) {
    *autorelease_len = vphp_autorelease_pool.len;
  }
  if (owned_len != NULL) {
    *owned_len = vphp_owned_pool.len;
  }
  if (obj_registry_len != NULL) {
    *obj_registry_len = vphp_registry_initialized
                            ? zend_hash_num_elements(&vphp_object_registry)
                            : 0;
  }
  if (rev_registry_len != NULL) {
    *rev_registry_len = vphp_registry_initialized
                            ? zend_hash_num_elements(&vphp_reverse_registry)
                            : 0;
  }
}

void vphp_request_startup(void) {
  vphp_apply_registered_auto_interface_bindings(0);
  vphp_flush_pending_auto_interface_bindings();
  vphp_last_class_table_count = zend_hash_num_elements(CG(class_table));
}

void vphp_request_shutdown(void) {
  char debug_buf[256];
  vphp_runtime_debug_log_pools("enter");
  if (vphp_owned_pool.len > 0) {
    vphp_runtime_debug_dump_owned_pool("enter", 24);
  }
  vphp_autorelease_drain(0);
  vphp_runtime_debug_log_pools("after_autorelease_drain");
  if (vphp_owned_pool.len > 0) {
    vphp_runtime_debug_dump_owned_pool("after_autorelease_drain", 24);
  }
  vphp_last_class_table_count = 0;
  vphp_runtime_binding_applying = 0;
  vphp_runtime_internal_call_depth = 0;
  vphp_runtime_autoloading = 0;
  if (vphp_pending_auto_iface_bindings != NULL) {
    efree(vphp_pending_auto_iface_bindings);
    vphp_pending_auto_iface_bindings = NULL;
  }
  vphp_pending_auto_iface_bindings_len = 0;
  vphp_pending_auto_iface_bindings_cap = 0;
  vphp_runtime_debug_log_pools("before_sidecar_cleanup");
  if (vphp_sidecar_registry_initialized) {
    vphp_object_wrapper *binding = NULL;
    zend_ulong obj_key = 0;
    ZEND_HASH_FOREACH_NUM_KEY_PTR(&vphp_sidecar_registry, obj_key, binding) {
      if (binding == NULL) {
        snprintf(debug_buf, sizeof(debug_buf),
                 "request_shutdown sidecar skip_null obj=%p", (void *)obj_key);
        vphp_runtime_debug_log(debug_buf);
        continue;
      }
      snprintf(debug_buf, sizeof(debug_buf),
               "request_shutdown sidecar binding obj=%p binding=%p v_ptr=%p owns=%d original_handlers=%p",
               (void *)obj_key, (void *)binding, binding->v_ptr,
               binding->owns_v_ptr, (void *)binding->original_handlers);
      vphp_runtime_debug_log(debug_buf);
      if (vphp_registry_initialized) {
        zend_hash_index_del(&vphp_reverse_registry, obj_key);
        snprintf(debug_buf, sizeof(debug_buf),
                 "request_shutdown sidecar reverse_del obj=%p", (void *)obj_key);
        vphp_runtime_debug_log(debug_buf);
      }
      if (binding->v_ptr != NULL && vphp_registry_initialized) {
        zend_hash_index_del(&vphp_object_registry, (zend_ulong)binding->v_ptr);
        snprintf(debug_buf, sizeof(debug_buf),
                 "request_shutdown sidecar object_del v_ptr=%p", binding->v_ptr);
        vphp_runtime_debug_log(debug_buf);
      }
    }
    ZEND_HASH_FOREACH_END();
    vphp_runtime_debug_log("request_shutdown sidecar clean begin");
    zend_hash_clean(&vphp_sidecar_registry);
    vphp_runtime_debug_log("request_shutdown sidecar clean done");
  }
  if (vphp_registry_initialized) {
    vphp_runtime_debug_log("request_shutdown object_registry clean begin");
    zend_hash_clean(&vphp_object_registry);
    vphp_runtime_debug_log("request_shutdown object_registry clean done");
    vphp_runtime_debug_log("request_shutdown reverse_registry clean begin");
    zend_hash_clean(&vphp_reverse_registry);
    vphp_runtime_debug_log("request_shutdown reverse_registry clean done");
  }
  vphp_runtime_debug_log_pools("exit");
  if (vphp_owned_pool.len > 0) {
    vphp_runtime_debug_dump_owned_pool("exit", 24);
  }
  if (vphp_autorelease_pool.items != NULL) {
    pefree(vphp_autorelease_pool.items, 1);
    vphp_autorelease_pool.items = NULL;
  }
  vphp_autorelease_pool.cap = 0;
  vphp_autorelease_pool.len = 0;
  if (vphp_owned_pool.origins != NULL) {
    for (int i = 0; i < vphp_owned_pool.len; i++) {
      if (vphp_owned_pool.origins[i] != NULL) {
        efree(vphp_owned_pool.origins[i]);
      }
    }
    pefree(vphp_owned_pool.origins, 1);
    vphp_owned_pool.origins = NULL;
  }
  if (vphp_owned_pool.items != NULL) {
    pefree(vphp_owned_pool.items, 1);
    vphp_owned_pool.items = NULL;
  }
  vphp_owned_pool.cap = 0;
  vphp_owned_pool.len = 0;
}

void vphp_autorelease_shutdown(void) {
  char debug_buf[256];
  vphp_runtime_debug_log("autorelease_shutdown enter");
  if (vphp_autorelease_pool.items != NULL) {
    snprintf(debug_buf, sizeof(debug_buf),
             "autorelease_shutdown free autorelease_pool.items=%p cap=%d len=%d",
             (void *)vphp_autorelease_pool.items, vphp_autorelease_pool.cap,
             vphp_autorelease_pool.len);
    vphp_runtime_debug_log(debug_buf);
    pefree(vphp_autorelease_pool.items, 1);
    vphp_autorelease_pool.items = NULL;
  }
  vphp_autorelease_pool.cap = 0;
  vphp_autorelease_pool.len = 0;
  if (vphp_owned_pool.items != NULL) {
    snprintf(debug_buf, sizeof(debug_buf),
             "autorelease_shutdown free owned_pool.items=%p cap=%d len=%d",
             (void *)vphp_owned_pool.items, vphp_owned_pool.cap,
             vphp_owned_pool.len);
    vphp_runtime_debug_log(debug_buf);
    pefree(vphp_owned_pool.items, 1);
    vphp_owned_pool.items = NULL;
  }
  if (vphp_owned_pool.origins != NULL) {
    snprintf(debug_buf, sizeof(debug_buf),
             "autorelease_shutdown free owned_pool.origins=%p cap=%d len=%d",
             (void *)vphp_owned_pool.origins, vphp_owned_pool.cap,
             vphp_owned_pool.len);
    vphp_runtime_debug_log(debug_buf);
    for (int i = 0; i < vphp_owned_pool.len; i++) {
      if (vphp_owned_pool.origins[i] != NULL) {
        efree(vphp_owned_pool.origins[i]);
      }
    }
    pefree(vphp_owned_pool.origins, 1);
    vphp_owned_pool.origins = NULL;
  }
  vphp_owned_pool.cap = 0;
  vphp_owned_pool.len = 0;
  vphp_runtime_debug_log("autorelease_shutdown exit");
}

static zend_class_entry *vphp_lookup_class_by_name(const char *class_name,
                                                   int class_name_len) {
  zend_string *zs = zend_string_init(class_name, class_name_len, 0);
  zend_class_entry *ce = vphp_zend_lookup_class(zs);
  zend_string_release(zs);
  return ce;
}

static zend_class_entry *
vphp_find_loaded_class_no_autoload(const char *class_name, int class_name_len) {
  zend_string *name = zend_string_init(class_name, class_name_len, 0);
  zend_string *lower = zend_string_tolower(name);
  zend_class_entry *ce = zend_hash_find_ptr(CG(class_table), lower);
  zend_string_release(lower);
  zend_string_release(name);
  return ce;
}

zend_class_entry *vphp_find_loaded_class_entry(const char *class_name,
                                               int class_name_len) {
  return vphp_find_loaded_class_no_autoload(class_name, class_name_len);
}

zend_class_entry *vphp_require_class_entry(const char *class_name,
                                           int class_name_len, int autoload) {
  zend_class_entry *ce = NULL;

  if (!class_name || class_name_len <= 0) {
    return NULL;
  }
  ce = vphp_find_loaded_class_no_autoload(class_name, class_name_len);
  if (ce != NULL) {
    return ce;
  }
  if (!autoload) {
    return NULL;
  }
  return vphp_lookup_class_by_name(class_name, class_name_len);
}

static int vphp_class_is_descendant_of(zend_class_entry *ce,
                                       zend_class_entry *parent_ce) {
  zend_class_entry *cursor = NULL;

  if (!ce || !parent_ce) {
    return 0;
  }
  cursor = ce->parent;
  while (cursor != NULL) {
    if (cursor == parent_ce) {
      return 1;
    }
    cursor = cursor->parent;
  }
  return 0;
}

static int vphp_class_is_throwable(zend_class_entry *ce) {
  if (!ce) {
    return 0;
  }
  return vphp_zend_class_implements_interface(ce, zend_ce_throwable) ? 1 : 0;
}

static zend_class_entry *vphp_autoload_class(zend_string *name) {
  if (!name) {
    return NULL;
  }
  return vphp_zend_lookup_class_ex(name);
}

static void vphp_preload_auto_interfaces_for_class(zend_class_entry *class_ce) {
  vphp_prepare_auto_interfaces_for_class(class_ce, 1);
}

static void vphp_prepare_auto_interfaces_for_class(zend_class_entry *class_ce,
                                                   int autoload) {
  int matched_any = 0;

  if (!class_ce || vphp_auto_iface_bindings_len == 0 ||
      vphp_runtime_autoloading || vphp_runtime_binding_applying) {
    return;
  }

  vphp_runtime_autoloading = 1;
  vphp_runtime_binding_applying = 1;
  for (uint32_t i = 0; i < vphp_auto_iface_bindings_len; i++) {
    vphp_auto_iface_binding_t *entry = &vphp_auto_iface_bindings[i];
    zend_class_entry *bound_class_ce = vphp_find_loaded_class_no_autoload(
        entry->class_name, entry->class_name_len);
    zend_string *iface_name = NULL;

    if (!bound_class_ce) {
      continue;
    }
    if (class_ce != bound_class_ce &&
        !vphp_class_is_descendant_of(class_ce, bound_class_ce)) {
      continue;
    }

    matched_any = 1;
    iface_name = zend_string_init(entry->iface_name, entry->iface_name_len, 0);
    if (!autoload) {
      zend_class_entry *loaded_iface_ce = vphp_find_loaded_class_no_autoload(
          entry->iface_name, entry->iface_name_len);
      if (loaded_iface_ce != NULL) {
        matched_any = 1;
      }
    } else if (vphp_autoload_class(iface_name) != NULL) {
      matched_any = 1;
    }
    zend_string_release(iface_name);
  }

  vphp_runtime_autoloading = 0;
  vphp_runtime_binding_applying = 0;
  if (matched_any) {
    /*
     * Do not mutate class/interface relationships while Zend is still inside
     * an autoload stack. Composer-style PSR interfaces are loaded one file at
     * a time, and applying zend_do_implement_interface() mid-autoload can
     * corrupt subsequent interface queries/instantiation.
     */
    vphp_apply_registered_auto_interface_bindings(0);
    vphp_flush_pending_auto_interface_bindings();
    vphp_last_class_table_count = zend_hash_num_elements(CG(class_table));
  }
}

static zend_class_entry *vphp_runtime_query_class_from_arg(zval *arg,
                                                           int autoload) {
  if (!arg) {
    return NULL;
  }
  if (Z_TYPE_P(arg) == IS_OBJECT) {
    return Z_OBJCE_P(arg);
  }
  if (Z_TYPE_P(arg) == IS_STRING) {
    if (autoload) {
      return vphp_lookup_class_by_name(Z_STRVAL_P(arg), Z_STRLEN_P(arg));
    }
    return vphp_find_loaded_class_no_autoload(Z_STRVAL_P(arg), Z_STRLEN_P(arg));
  }
  return NULL;
}

static int vphp_runtime_bool_arg(zend_execute_data *execute_data, uint32_t index,
                                 int default_value) {
  zval *arg = NULL;

  if (!execute_data || ZEND_CALL_NUM_ARGS(execute_data) < index) {
    return default_value;
  }
  arg = ZEND_CALL_ARG(execute_data, index);
  if (!arg) {
    return default_value;
  }
  return zend_is_true(arg) ? 1 : 0;
}

static void
vphp_runtime_prepare_internal_query_bindings(zend_execute_data *execute_data) {
  zend_function *func = NULL;
  zend_string *function_name = NULL;
  zend_class_entry *query_ce = NULL;
  zval *query_arg = NULL;

  if (!execute_data || vphp_auto_iface_bindings_len == 0) {
    return;
  }
  func = execute_data->func;
  if (!func || func->type != ZEND_INTERNAL_FUNCTION || func->common.scope != NULL ||
      func->common.function_name == NULL || ZEND_CALL_NUM_ARGS(execute_data) == 0) {
    return;
  }

  function_name = func->common.function_name;
  query_arg = ZEND_CALL_ARG(execute_data, 1);
  if (!query_arg) {
    return;
  }

  if (zend_string_equals_literal(function_name, "class_implements")) {
    int autoload = vphp_runtime_bool_arg(execute_data, 2, 1);

    query_ce = vphp_runtime_query_class_from_arg(query_arg, autoload);
    if (query_ce != NULL) {
      vphp_prepare_auto_interfaces_for_class(query_ce, autoload);
    }
    return;
  }

  if (zend_string_equals_literal(function_name, "is_a") ||
      zend_string_equals_literal(function_name, "is_subclass_of")) {
    int allow_string = zend_string_equals_literal(function_name, "is_subclass_of")
                           ? vphp_runtime_bool_arg(execute_data, 3, 1)
                           : vphp_runtime_bool_arg(execute_data, 3, 0);

    if (Z_TYPE_P(query_arg) == IS_STRING && !allow_string) {
      return;
    }
    query_ce = vphp_runtime_query_class_from_arg(query_arg, 1);
    if (query_ce != NULL) {
      vphp_prepare_auto_interfaces_for_class(query_ce, 1);
    }
  }
}

static int vphp_auto_binding_requires_deferral(zend_class_entry *class_ce,
                                               zend_class_entry *iface_ce) {
  if (!class_ce || !iface_ce) {
    return 0;
  }
  if (vphp_runtime_internal_call_depth == 0) {
    return 0;
  }
  if (!vphp_class_is_throwable(class_ce)) {
    return 0;
  }
  if (!(iface_ce->ce_flags & ZEND_ACC_INTERFACE)) {
    return 0;
  }
  if (iface_ce->num_interfaces == 0) {
    return 0;
  }
  return 1;
}

static void vphp_queue_pending_auto_interface_binding(uint32_t binding_index) {
  if (binding_index >= vphp_auto_iface_bindings_len) {
    return;
  }
  for (uint32_t i = 0; i < vphp_pending_auto_iface_bindings_len; i++) {
    if (vphp_pending_auto_iface_bindings[i].binding_index == binding_index) {
      return;
    }
  }
  if (vphp_pending_auto_iface_bindings_len >=
      vphp_pending_auto_iface_bindings_cap) {
    uint32_t new_cap = vphp_pending_auto_iface_bindings_cap == 0
                           ? 4
                           : vphp_pending_auto_iface_bindings_cap * 2;
    size_t bytes = sizeof(vphp_pending_auto_iface_binding_t) * new_cap;
    if (vphp_pending_auto_iface_bindings == NULL) {
      vphp_pending_auto_iface_bindings = emalloc(bytes);
    } else {
      vphp_pending_auto_iface_bindings =
          erealloc(vphp_pending_auto_iface_bindings, bytes);
    }
    if (vphp_pending_auto_iface_bindings == NULL) {
      vphp_pending_auto_iface_bindings_cap = 0;
      vphp_pending_auto_iface_bindings_len = 0;
      return;
    }
    vphp_pending_auto_iface_bindings_cap = new_cap;
  }
  vphp_pending_auto_iface_bindings[vphp_pending_auto_iface_bindings_len++]
      .binding_index = binding_index;
}

static int vphp_try_apply_auto_interface_binding(vphp_auto_iface_binding_t *entry,
                                                 uint32_t binding_index,
                                                 int autoload, int allow_defer) {
  zend_class_entry *class_ce = NULL;
  zend_class_entry *iface_ce = NULL;

  if (!entry) {
    return 0;
  }

  if (autoload) {
    class_ce =
        vphp_lookup_class_by_name(entry->class_name, entry->class_name_len);
    iface_ce = vphp_lookup_class_by_name(entry->iface_name, entry->iface_name_len);
  } else {
    class_ce = vphp_find_loaded_class_no_autoload(entry->class_name,
                                                  entry->class_name_len);
    iface_ce = vphp_find_loaded_class_no_autoload(entry->iface_name,
                                                  entry->iface_name_len);
  }

  if (!class_ce || !iface_ce) {
    return 0;
  }
  if (vphp_zend_class_implements_interface(class_ce, iface_ce)) {
    return 1;
  }
  if (allow_defer && vphp_auto_binding_requires_deferral(class_ce, iface_ce)) {
    vphp_queue_pending_auto_interface_binding(binding_index);
    return -1;
  }
  return vphp_implement_interface_for_class(class_ce, iface_ce);
}

static void vphp_flush_pending_auto_interface_bindings(void) {
  if (vphp_pending_auto_iface_bindings_len == 0 ||
      vphp_runtime_internal_call_depth > 0) {
    return;
  }

  for (uint32_t i = 0; i < vphp_pending_auto_iface_bindings_len; i++) {
    uint32_t binding_index = vphp_pending_auto_iface_bindings[i].binding_index;
    if (binding_index >= vphp_auto_iface_bindings_len) {
      continue;
    }
    (void)vphp_try_apply_auto_interface_binding(
        &vphp_auto_iface_bindings[binding_index], binding_index, 0, 0);
  }
  vphp_pending_auto_iface_bindings_len = 0;
}

static int vphp_implement_interface_for_class(zend_class_entry *class_ce,
                                              zend_class_entry *iface_ce) {
  int result = 0;

  if (!class_ce || !iface_ce) {
    return 0;
  }

  if (!vphp_zend_class_implements_interface(class_ce, iface_ce)) {
    zend_do_implement_interface(class_ce, iface_ce);
  }
  result = vphp_zend_class_implements_interface(class_ce, iface_ce) ? 1 : 0;

  return result;
}

int vphp_bind_class_interface(const char *class_name, int class_name_len,
                              const char *iface_name, int iface_name_len) {
  zend_string *class_name_str = zend_string_init(class_name, class_name_len, 0);
  zend_string *iface_name_str = zend_string_init(iface_name, iface_name_len, 0);
  zend_class_entry *class_ce = vphp_zend_lookup_class(class_name_str);
  zend_class_entry *iface_ce = vphp_zend_lookup_class(iface_name_str);
  int result = 0;

  zend_string_release(class_name_str);
  zend_string_release(iface_name_str);

  if (!class_ce || !iface_ce) {
    return 0;
  }

  if (vphp_zend_class_implements_interface(class_ce, iface_ce)) {
    return 1;
  }

  result = vphp_implement_interface_for_class(class_ce, iface_ce);
  return result;
}

void vphp_register_auto_interface_binding(const char *class_name,
                                          int class_name_len,
                                          const char *iface_name,
                                          int iface_name_len) {
  if (!class_name || class_name_len <= 0 || !iface_name || iface_name_len <= 0) {
    return;
  }
  for (uint32_t i = 0; i < vphp_auto_iface_bindings_len; i++) {
    vphp_auto_iface_binding_t *entry = &vphp_auto_iface_bindings[i];
    if (entry->class_name_len == class_name_len &&
        entry->iface_name_len == iface_name_len &&
        strncasecmp(entry->class_name, class_name, class_name_len) == 0 &&
        strncmp(entry->iface_name, iface_name, iface_name_len) == 0) {
      return;
    }
  }
  if (vphp_auto_iface_bindings_len >= vphp_auto_iface_bindings_cap) {
    uint32_t new_cap =
        vphp_auto_iface_bindings_cap == 0 ? 8 : vphp_auto_iface_bindings_cap * 2;
    size_t bytes = sizeof(vphp_auto_iface_binding_t) * new_cap;
    if (vphp_auto_iface_bindings == NULL) {
      vphp_auto_iface_bindings = pemalloc(bytes, 1);
    } else {
      vphp_auto_iface_bindings = perealloc(vphp_auto_iface_bindings, bytes, 1);
    }
    if (vphp_auto_iface_bindings == NULL) {
      vphp_auto_iface_bindings_cap = 0;
      vphp_auto_iface_bindings_len = 0;
      return;
    }
    vphp_auto_iface_bindings_cap = new_cap;
  }
  vphp_auto_iface_binding_t *entry =
      &vphp_auto_iface_bindings[vphp_auto_iface_bindings_len++];
  entry->class_name = pemalloc((size_t)class_name_len + 1, 1);
  memcpy(entry->class_name, class_name, class_name_len);
  entry->class_name[class_name_len] = '\0';
  entry->class_name_len = class_name_len;
  entry->iface_name = pemalloc((size_t)iface_name_len + 1, 1);
  memcpy(entry->iface_name, iface_name, iface_name_len);
  entry->iface_name[iface_name_len] = '\0';
  entry->iface_name_len = iface_name_len;
}

static bool vphp_object_matches_unresolved_named_type(zend_class_entry *class_ce,
                                                      zend_string *expected_name) {
  if (class_ce == NULL || expected_name == NULL) {
    return false;
  }
  if (zend_string_equals_ci(class_ce->name, expected_name)) {
    return true;
  }
  for (uint32_t i = 0; i < vphp_auto_iface_bindings_len; i++) {
    vphp_auto_iface_binding_t *entry = &vphp_auto_iface_bindings[i];
    if ((int)ZSTR_LEN(class_ce->name) != entry->class_name_len ||
        (int)ZSTR_LEN(expected_name) != entry->iface_name_len) {
      continue;
    }
    if (strncasecmp(ZSTR_VAL(class_ce->name), entry->class_name,
                    (size_t)entry->class_name_len) != 0) {
      continue;
    }
    if (strncmp(ZSTR_VAL(expected_name), entry->iface_name,
                (size_t)entry->iface_name_len) != 0) {
      continue;
    }
    return true;
  }
  return false;
}

static void vphp_apply_auto_interface_bindings_for_class(zend_class_entry *ce) {
  if (!ce || vphp_auto_iface_bindings_len == 0) {
    return;
  }
  for (uint32_t i = 0; i < vphp_auto_iface_bindings_len; i++) {
    vphp_auto_iface_binding_t *entry = &vphp_auto_iface_bindings[i];
    if ((int)ZSTR_LEN(ce->name) != entry->class_name_len) {
      continue;
    }
    if (strncasecmp(ZSTR_VAL(ce->name), entry->class_name,
                    (size_t)entry->class_name_len) != 0) {
      continue;
    }
    (void)vphp_try_apply_auto_interface_binding(entry, i, 0, 0);
  }
}

static void vphp_apply_registered_auto_interface_bindings(int autoload) {
  if (vphp_auto_iface_bindings_len == 0) {
    return;
  }
  for (uint32_t i = 0; i < vphp_auto_iface_bindings_len; i++) {
    vphp_auto_iface_binding_t *entry = &vphp_auto_iface_bindings[i];
    (void)vphp_try_apply_auto_interface_binding(entry, i, autoload,
                                                autoload ? 0 : 1);
  }
}

void vphp_apply_auto_interface_bindings(int autoload) {
  vphp_apply_registered_auto_interface_bindings(autoload);
  if (!autoload) {
    vphp_flush_pending_auto_interface_bindings();
  }
}

static void vphp_runtime_maybe_apply_bindings(uint32_t class_count_before,
                                              int should_check) {
  uint32_t class_count_after = 0;

  if (should_check && !vphp_runtime_binding_applying) {
    class_count_after = zend_hash_num_elements(CG(class_table));
    if (!(class_count_after == class_count_before &&
          class_count_after == vphp_last_class_table_count)) {
      vphp_last_class_table_count = class_count_after;
      vphp_runtime_binding_applying = 1;
      vphp_apply_registered_auto_interface_bindings(0);
      vphp_runtime_binding_applying = 0;
    }
  }

  vphp_flush_pending_auto_interface_bindings();
}

static void vphp_runtime_binding_execute_ex(zend_execute_data *execute_data) {
  uint32_t class_count_before = 0;
  int should_check = 0;

  if (vphp_auto_iface_bindings_len > 0 && !vphp_runtime_binding_applying) {
    class_count_before = zend_hash_num_elements(CG(class_table));
    should_check = 1;
  }

  if (vphp_prev_execute_ex != NULL) {
    vphp_prev_execute_ex(execute_data);
  } else {
    execute_ex(execute_data);
  }

  vphp_runtime_maybe_apply_bindings(class_count_before, should_check);
}

static void vphp_runtime_binding_execute_internal(zend_execute_data *execute_data,
                                                  zval *return_value) {
  uint32_t class_count_before = 0;
  int should_check = 0;
  int suspend_binding_during_call = 0;
  int prev_binding_applying = 0;
  zend_function *func = NULL;
  zend_string *function_name = NULL;

  if (vphp_auto_iface_bindings_len > 0 && !vphp_runtime_binding_applying) {
    class_count_before = zend_hash_num_elements(CG(class_table));
    should_check = 1;
  }

  func = execute_data != NULL ? execute_data->func : NULL;
  if (func != NULL && func->type == ZEND_INTERNAL_FUNCTION &&
      func->common.scope == NULL && func->common.function_name != NULL) {
    function_name = func->common.function_name;
    if (zend_string_equals_literal(function_name, "interface_exists") ||
        zend_string_equals_literal(function_name, "class_exists") ||
        zend_string_equals_literal(function_name, "trait_exists")) {
      should_check = 0;
      suspend_binding_during_call = 1;
    }
  }

  vphp_runtime_prepare_internal_query_bindings(execute_data);
  vphp_runtime_internal_call_depth++;
  if (suspend_binding_during_call) {
    prev_binding_applying = vphp_runtime_binding_applying;
    vphp_runtime_binding_applying = 1;
  }
  if (vphp_prev_execute_internal != NULL) {
    vphp_prev_execute_internal(execute_data, return_value);
  } else {
    execute_internal(execute_data, return_value);
  }
  if (suspend_binding_during_call) {
    vphp_runtime_binding_applying = prev_binding_applying;
  }
  if (vphp_runtime_internal_call_depth > 0) {
    vphp_runtime_internal_call_depth--;
  }

  vphp_runtime_maybe_apply_bindings(class_count_before, should_check);
}

void vphp_install_runtime_binding_hooks(void) {
  if (vphp_runtime_binding_hook_refs++ > 0) {
    return;
  }
  vphp_prev_execute_ex = zend_execute_ex;
  vphp_prev_execute_internal = zend_execute_internal;
  zend_execute_ex = vphp_runtime_binding_execute_ex;
  zend_execute_internal = vphp_runtime_binding_execute_internal;
}

void vphp_uninstall_runtime_binding_hooks(void) {
  if (vphp_runtime_binding_hook_refs == 0) {
    return;
  }
  vphp_runtime_binding_hook_refs--;
  if (vphp_runtime_binding_hook_refs > 0) {
    return;
  }
  if (zend_execute_ex == vphp_runtime_binding_execute_ex) {
    zend_execute_ex = vphp_prev_execute_ex;
  }
  if (zend_execute_internal == vphp_runtime_binding_execute_internal) {
    zend_execute_internal = vphp_prev_execute_internal;
  }
  vphp_prev_execute_ex = NULL;
  vphp_prev_execute_internal = NULL;
}
