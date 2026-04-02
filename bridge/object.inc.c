void vphp_init_registry() {
  if (!vphp_registry_initialized) {
    zend_hash_init(&vphp_object_registry, 16, NULL, NULL, 1);
    zend_hash_init(&vphp_reverse_registry, 16, NULL, NULL, 1);
    vphp_registry_initialized = true;
  }
}

static void vphp_init_sidecar_registry(void) {
  if (vphp_sidecar_registry_initialized) {
    return;
  }
  memset(&vphp_null_wrapper, 0, sizeof(vphp_null_wrapper));
  zend_hash_init(&vphp_sidecar_registry, 16, NULL, NULL, 0);
  vphp_sidecar_registry_initialized = true;
}

static int vphp_object_uses_inline_wrapper(zend_object *obj) {
  return obj != NULL && obj->handlers == &vphp_obj_handlers;
}

static void vphp_init_inherited_handler_registry(void) {
  if (vphp_inherited_handler_registry_initialized) {
    return;
  }
  zend_hash_init(&vphp_inherited_handler_registry, 8, NULL, NULL, 1);
  vphp_inherited_handler_registry_initialized = true;
}

static vphp_object_wrapper *vphp_lookup_sidecar(zend_object *obj) {
  if (!vphp_sidecar_registry_initialized || obj == NULL) {
    return NULL;
  }
  return zend_hash_index_find_ptr(&vphp_sidecar_registry, (zend_ulong)obj);
}

static vphp_object_wrapper *vphp_binding_for_obj(zend_object *obj, int create) {
  vphp_object_wrapper *sidecar = NULL;
  if (obj == NULL) {
    return &vphp_null_wrapper;
  }
  if (vphp_object_uses_inline_wrapper(obj)) {
    return (vphp_object_wrapper *)((char *)(obj)-offsetof(vphp_object_wrapper, std));
  }
  sidecar = vphp_lookup_sidecar(obj);
  if (sidecar != NULL || !create) {
    return sidecar != NULL ? sidecar : &vphp_null_wrapper;
  }
  vphp_init_sidecar_registry();
  sidecar = ecalloc(1, sizeof(vphp_object_wrapper));
  sidecar->magic = VPHP_MAGIC;
  zend_hash_index_update_ptr(&vphp_sidecar_registry, (zend_ulong)obj, sidecar);
  return sidecar;
}

static int vphp_binding_uses_registry(zend_object *obj) {
  return vphp_object_uses_inline_wrapper(obj);
}

void vphp_shutdown_registry() {
  if (vphp_registry_initialized) {
    zend_hash_destroy(&vphp_object_registry);
    zend_hash_destroy(&vphp_reverse_registry);
    vphp_registry_initialized = false;
  }
  if (vphp_sidecar_registry_initialized) {
    zend_hash_destroy(&vphp_sidecar_registry);
    vphp_sidecar_registry_initialized = false;
  }
  if (vphp_inherited_handler_registry_initialized) {
    zend_object_handlers *handlers = NULL;
    ZEND_HASH_FOREACH_PTR(&vphp_inherited_handler_registry, handlers) {
      if (handlers != NULL) {
        pefree(handlers, 1);
      }
    }
    ZEND_HASH_FOREACH_END();
    zend_hash_destroy(&vphp_inherited_handler_registry);
    vphp_inherited_handler_registry_initialized = false;
  }
  if (vphp_auto_iface_bindings != NULL) {
    for (uint32_t i = 0; i < vphp_auto_iface_bindings_len; i++) {
      pefree(vphp_auto_iface_bindings[i].class_name, 1);
      pefree(vphp_auto_iface_bindings[i].iface_name, 1);
    }
    pefree(vphp_auto_iface_bindings, 1);
    vphp_auto_iface_bindings = NULL;
  }
  vphp_auto_iface_bindings_len = 0;
  vphp_auto_iface_bindings_cap = 0;
}

void vphp_register_object(void *v_ptr, zend_object *obj) {
  vphp_init_registry();
  if (v_ptr == NULL || obj == NULL) {
    return;
  }
  zend_hash_index_update_ptr(&vphp_object_registry, (zend_ulong)v_ptr, obj);
  zend_hash_index_update_ptr(&vphp_reverse_registry, (zend_ulong)obj, v_ptr);
}

void vphp_return_obj(zval *return_value, void *v_ptr, zend_class_entry *ce) {
  if (!v_ptr) {
    ZVAL_NULL(return_value);
    return;
  }
  vphp_init_registry();
  zend_object *existing_obj =
      zend_hash_index_find_ptr(&vphp_object_registry, (zend_ulong)v_ptr);
  if (existing_obj) {
    if (!ce || existing_obj->ce == ce) {
      GC_ADDREF(existing_obj);
      ZVAL_OBJ(return_value, existing_obj);
      return;
    }
    zend_hash_index_del(&vphp_object_registry, (zend_ulong)v_ptr);
  }
  object_init_ex(return_value, ce);
  zend_object *new_obj = Z_OBJ_P(return_value);
  vphp_object_wrapper *wrapper = vphp_binding_for_obj(new_obj, 1);
  if (wrapper != &vphp_null_wrapper) {
    wrapper->v_ptr = v_ptr;
  }
  vphp_register_object(v_ptr, new_obj);
}

void vphp_return_bound_object(zval *return_value, void *v_ptr,
                              zend_class_entry *ce, vphp_class_handlers *h,
                              int owns_v_ptr) {
  vphp_return_obj(return_value, v_ptr, ce);
  if (Z_TYPE_P(return_value) == IS_OBJECT && h != NULL) {
    vphp_bind_handlers_with_ownership(Z_OBJ_P(return_value), h, owns_v_ptr);
  }
}

void vphp_return_owned_object(zval *return_value, void *v_ptr,
                              zend_class_entry *ce, vphp_class_handlers *h) {
  vphp_return_bound_object(return_value, v_ptr, ce, h, VPHP_OWNS_VPTR);
}

void vphp_return_borrowed_object(zval *return_value, void *v_ptr,
                                 zend_class_entry *ce,
                                 vphp_class_handlers *h) {
  vphp_return_bound_object(return_value, v_ptr, ce, h, VPHP_BORROWS_VPTR);
}

void vphp_wrap_existing_object(zval *return_value, zend_object *obj) {
  if (return_value == NULL) {
    return;
  }
  if (obj == NULL) {
    ZVAL_NULL(return_value);
    return;
  }
  GC_ADDREF(obj);
  ZVAL_OBJ(return_value, obj);
}

vphp_object_wrapper *vphp_obj_from_obj(zend_object *obj) {
  vphp_object_wrapper *wrapper = vphp_binding_for_obj(obj, 0);
  if (wrapper == &vphp_null_wrapper) {
    return wrapper;
  }
  if (vphp_registry_initialized && obj != NULL) {
    void *rev_ptr =
        zend_hash_index_find_ptr(&vphp_reverse_registry, (zend_ulong)obj);
    if (rev_ptr != NULL) {
      if (wrapper->v_ptr != rev_ptr) {
        wrapper->v_ptr = rev_ptr;
      }
    } else if (wrapper->v_ptr != NULL) {
      zend_object *mapped = zend_hash_index_find_ptr(&vphp_object_registry,
                                                     (zend_ulong)wrapper->v_ptr);
      if (mapped == obj) {
        zend_hash_index_update_ptr(&vphp_reverse_registry, (zend_ulong)obj,
                                   wrapper->v_ptr);
      }
    }
  }
  return wrapper;
}

zend_object *vphp_get_obj_from_zval(zval *zv) { return Z_OBJ_P(zv); }

void *vphp_get_v_ptr_from_zval(zval *zv) {
  if (!zv || Z_TYPE_P(zv) != IS_OBJECT) {
    return NULL;
  }
  vphp_object_wrapper *wrapper = vphp_obj_from_obj(Z_OBJ_P(zv));
  return wrapper ? wrapper->v_ptr : NULL;
}

static const zend_object_handlers *vphp_original_handlers_for(zend_object *obj) {
  vphp_object_wrapper *wrapper = NULL;
  if (obj == NULL) {
    return zend_get_std_object_handlers();
  }
  wrapper = vphp_obj_from_obj(obj);
  if (wrapper != NULL && wrapper != &vphp_null_wrapper &&
      wrapper->original_handlers != NULL) {
    return wrapper->original_handlers;
  }
  return zend_get_std_object_handlers();
}

static zend_object_handlers *vphp_clone_inherited_handlers(
    const zend_object_handlers *original_handlers) {
  zend_object_handlers *cloned = NULL;
  if (original_handlers == NULL) {
    return NULL;
  }
  vphp_init_inherited_handler_registry();
  cloned = zend_hash_index_find_ptr(&vphp_inherited_handler_registry,
                                    (zend_ulong)original_handlers);
  if (cloned != NULL) {
    return cloned;
  }
  cloned = pemalloc(sizeof(zend_object_handlers), 1);
  memcpy(cloned, original_handlers, sizeof(zend_object_handlers));
  cloned->read_property = vphp_read_property;
  cloned->write_property = vphp_write_property;
  cloned->get_properties = vphp_get_properties;
  zend_hash_index_update_ptr(&vphp_inherited_handler_registry,
                             (zend_ulong)original_handlers, cloned);
  return cloned;
}

static const zend_object_handlers *vphp_unwrap_inherited_handlers(
    const zend_object_handlers *handlers) {
  const zend_object_handlers *current = handlers;
  if (current == NULL || !vphp_inherited_handler_registry_initialized) {
    return current;
  }
  for (;;) {
    zend_object_handlers *cloned = NULL;
    zend_ulong original_key = 0;
    int unwrapped = 0;
    ZEND_HASH_FOREACH_NUM_KEY_PTR(&vphp_inherited_handler_registry, original_key,
                                  cloned) {
      if ((const zend_object_handlers *)cloned == current) {
        current = (const zend_object_handlers *)original_key;
        unwrapped = 1;
        break;
      }
    }
    ZEND_HASH_FOREACH_END();
    if (!unwrapped) {
      return current;
    }
  }
}

static const zend_object_handlers *vphp_fallback_handlers(
    const zend_object_handlers *handlers) {
  return handlers != NULL ? handlers : zend_get_std_object_handlers();
}

static zend_object *vphp_resolve_inherited_parent_object(
    zend_class_entry *ce,
    zend_object *(*self_create_object)(zend_class_entry *)) {
  zend_class_entry *cursor = ce != NULL ? ce->parent : NULL;
  while (cursor != NULL) {
    if (cursor->create_object != NULL &&
        cursor->create_object != self_create_object) {
      return cursor->create_object(ce);
    }
    cursor = cursor->parent;
  }
  return NULL;
}

void vphp_free_object_handler(zend_object *obj) {
  vphp_object_wrapper *wrapper = vphp_obj_from_obj(obj);
  const zend_object_handlers *original_handlers = vphp_original_handlers_for(obj);
  void *owned_v_ptr = NULL;
  void (*cleanup_raw)(void *) = NULL;
  void (*free_raw)(void *) = NULL;
  int owns_v_ptr = 0;
  int uses_inline_wrapper = vphp_object_uses_inline_wrapper(obj);
  int has_sidecar_wrapper =
      !uses_inline_wrapper && wrapper != NULL && wrapper != &vphp_null_wrapper;
  if (wrapper) {
    owned_v_ptr = wrapper->v_ptr;
    cleanup_raw = wrapper->cleanup_raw;
    free_raw = wrapper->free_raw;
    owns_v_ptr = wrapper->owns_v_ptr;
  }
  if (vphp_registry_initialized && obj) {
    void *mapped_v_ptr =
        zend_hash_index_find_ptr(&vphp_reverse_registry, (zend_ulong)obj);
    if (mapped_v_ptr) {
      zend_object *mapped = zend_hash_index_find_ptr(&vphp_object_registry,
                                                     (zend_ulong)mapped_v_ptr);
      if (mapped == obj) {
        zend_hash_index_del(&vphp_object_registry, (zend_ulong)mapped_v_ptr);
      }
      zend_hash_index_del(&vphp_reverse_registry, (zend_ulong)obj);
    }
  }
  if (vphp_registry_initialized && wrapper && wrapper->v_ptr) {
    zend_object *mapped = zend_hash_index_find_ptr(&vphp_object_registry,
                                                   (zend_ulong)wrapper->v_ptr);
    if (mapped == obj) {
      zend_hash_index_del(&vphp_object_registry, (zend_ulong)wrapper->v_ptr);
    }
  }
  if (owns_v_ptr && owned_v_ptr) {
    if (cleanup_raw) {
      cleanup_raw(owned_v_ptr);
    }
    if (free_raw) {
      free_raw(owned_v_ptr);
    }
  }
  if (uses_inline_wrapper && wrapper) {
    wrapper->v_ptr = NULL;
    wrapper->owns_v_ptr = 0;
    wrapper->cleanup_raw = NULL;
    wrapper->free_raw = NULL;
    wrapper->prop_handler = NULL;
    wrapper->write_handler = NULL;
    wrapper->sync_handler = NULL;
    wrapper->original_handlers = NULL;
  }
  if (original_handlers != NULL && original_handlers->free_obj != NULL &&
      original_handlers->free_obj != vphp_free_object_handler) {
    original_handlers->free_obj(obj);
  } else {
    zend_object_std_dtor(obj);
  }
  if (has_sidecar_wrapper && vphp_sidecar_registry_initialized && obj != NULL) {
    zend_hash_index_del(&vphp_sidecar_registry, (zend_ulong)obj);
    wrapper->v_ptr = NULL;
    wrapper->owns_v_ptr = 0;
    wrapper->cleanup_raw = NULL;
    wrapper->free_raw = NULL;
    wrapper->prop_handler = NULL;
    wrapper->write_handler = NULL;
    wrapper->sync_handler = NULL;
    wrapper->original_handlers = NULL;
    efree(wrapper);
  }
}

zval *vphp_read_property(zend_object *object, zend_string *member, int type,
                         void **cache_slot, zval *rv) {
  vphp_object_wrapper *wrapper = vphp_obj_from_obj(object);
  if (wrapper->v_ptr && wrapper->prop_handler) {
    ZVAL_UNDEF(rv);
    wrapper->prop_handler(wrapper->v_ptr, ZSTR_VAL(member),
                          (int)ZSTR_LEN(member), rv);
    if (Z_TYPE_P(rv) != IS_UNDEF) {
      return rv;
    }
  }
  const zend_object_handlers *handlers =
      vphp_fallback_handlers(vphp_original_handlers_for(object));
  if (handlers->read_property != NULL) {
    return handlers->read_property(object, member, type, cache_slot, rv);
  }
  return zend_get_std_object_handlers()->read_property(object, member, type,
                                                       cache_slot, rv);
}

zval *vphp_read_property_compat(zend_object *obj, const char *name, int name_len,
                                zval *rv) {
  zend_string *member = zend_string_init(name, name_len, 0);
  const zend_object_handlers *handlers =
      vphp_fallback_handlers(vphp_original_handlers_for(obj));
  zval *out = handlers->read_property != NULL
                  ? handlers->read_property(obj, member, BP_VAR_R, NULL, rv)
                  : zend_get_std_object_handlers()->read_property(
                        obj, member, BP_VAR_R, NULL, rv);
  zend_string_release(member);
  return out;
}

void vphp_write_property_compat(zend_object *obj, const char *name, int name_len,
                                zval *value) {
  zend_string *member = zend_string_init(name, name_len, 0);
  const zend_object_handlers *handlers =
      vphp_fallback_handlers(vphp_original_handlers_for(obj));
  if (handlers->write_property != NULL) {
    handlers->write_property(obj, member, value, NULL);
  } else {
    zend_get_std_object_handlers()->write_property(obj, member, value, NULL);
  }
  zend_string_release(member);
}

int vphp_has_property_compat(zend_object *obj, const char *name, int name_len) {
  zend_string *member = zend_string_init(name, name_len, 0);
  const zend_object_handlers *handlers =
      vphp_fallback_handlers(vphp_original_handlers_for(obj));
  int out = handlers->has_property != NULL
                ? handlers->has_property(obj, member, ZEND_PROPERTY_EXISTS, NULL)
                : zend_get_std_object_handlers()->has_property(
                      obj, member, ZEND_PROPERTY_EXISTS, NULL);
  zend_string_release(member);
  return out;
}

int vphp_isset_property_compat(zend_object *obj, const char *name, int name_len) {
  zend_string *member = zend_string_init(name, name_len, 0);
  const zend_object_handlers *handlers =
      vphp_fallback_handlers(vphp_original_handlers_for(obj));
  int out = handlers->has_property != NULL
                ? handlers->has_property(obj, member, ZEND_PROPERTY_ISSET, NULL)
                : zend_get_std_object_handlers()->has_property(
                      obj, member, ZEND_PROPERTY_ISSET, NULL);
  zend_string_release(member);
  return out;
}

void vphp_unset_property_compat(zend_object *obj, const char *name, int name_len) {
  zend_string *member = zend_string_init(name, name_len, 0);
  const zend_object_handlers *handlers =
      vphp_fallback_handlers(vphp_original_handlers_for(obj));
  if (handlers->unset_property != NULL) {
    handlers->unset_property(obj, member, NULL);
  } else {
    zend_get_std_object_handlers()->unset_property(obj, member, NULL);
  }
  zend_string_release(member);
}

zval *vphp_write_property(zend_object *object, zend_string *member, zval *value,
                          void **cache_slot) {
  vphp_object_wrapper *wrapper = vphp_obj_from_obj(object);
  zend_property_info *prop_info =
      zend_get_property_info(object->ce, member, /* silent */ true);
  if (prop_info && prop_info != ZEND_WRONG_PROPERTY_INFO &&
      (prop_info->flags & ZEND_ACC_READONLY)) {
    vphp_zend_readonly_property_modification_error(object, member);
    return &EG(error_zval);
  }
  if (wrapper->v_ptr && wrapper->write_handler) {
    wrapper->write_handler(wrapper->v_ptr, ZSTR_VAL(member),
                           (int)ZSTR_LEN(member), value);
  }
  const zend_object_handlers *handlers =
      vphp_fallback_handlers(vphp_original_handlers_for(object));
  if (handlers->write_property != NULL) {
    return handlers->write_property(object, member, value, cache_slot);
  }
  return zend_get_std_object_handlers()->write_property(object, member, value,
                                                        cache_slot);
}

HashTable *vphp_get_properties(zend_object *object) {
  const zend_object_handlers *handlers =
      vphp_fallback_handlers(vphp_original_handlers_for(object));
  HashTable *props = handlers->get_properties != NULL
                         ? handlers->get_properties(object)
                         : zend_std_get_properties(object);
  vphp_object_wrapper *wrapper = vphp_obj_from_obj(object);
  if (wrapper->v_ptr && wrapper->sync_handler) {
    zval obj_zv;
    ZVAL_OBJ(&obj_zv, object);
    wrapper->sync_handler(wrapper->v_ptr, &obj_zv);
  }
  return props;
}

void vphp_init_handlers() {
  memcpy(&vphp_obj_handlers, zend_get_std_object_handlers(),
         sizeof(zend_object_handlers));
  vphp_obj_handlers.offset = offsetof(vphp_object_wrapper, std);
  vphp_obj_handlers.free_obj = vphp_free_object_handler;
  vphp_obj_handlers.read_property = vphp_read_property;
  vphp_obj_handlers.get_properties = vphp_get_properties;
  vphp_obj_handlers.write_property = vphp_write_property;
}

zend_object *vphp_create_object_handler(zend_class_entry *ce) {
  if (vphp_obj_handlers.read_property == NULL) {
    vphp_init_handlers();
  }
  vphp_preload_auto_interfaces_for_class(ce);
  vphp_apply_auto_interface_bindings_for_class(ce);
  vphp_object_wrapper *obj = zend_object_alloc(sizeof(vphp_object_wrapper), ce);
  obj->magic = VPHP_MAGIC;
  obj->v_ptr = NULL;
  obj->owns_v_ptr = 0;
  obj->cleanup_raw = NULL;
  obj->free_raw = NULL;
  obj->original_handlers = NULL;
  zend_object_std_init(&obj->std, ce);
  object_properties_init(&obj->std, ce);
  obj->std.handlers = &vphp_obj_handlers;
  return &obj->std;
}

zend_object *vphp_create_inherited_object_handler(zend_class_entry *ce) {
  zend_object *obj = NULL;
  const zend_object_handlers *original_handlers = NULL;
  zend_object_handlers *cloned_handlers = NULL;
  vphp_object_wrapper *wrapper = NULL;
  if (vphp_obj_handlers.read_property == NULL) {
    vphp_init_handlers();
  }
  vphp_preload_auto_interfaces_for_class(ce);
  obj = vphp_resolve_inherited_parent_object(ce,
                                             vphp_create_inherited_object_handler);
  if (obj == NULL) {
    return vphp_create_object_handler(ce);
  }
  vphp_apply_auto_interface_bindings_for_class(ce);
  original_handlers = obj->handlers;
  original_handlers = vphp_unwrap_inherited_handlers(original_handlers);
  cloned_handlers = vphp_clone_inherited_handlers(original_handlers);
  if (cloned_handlers != NULL) {
    wrapper = vphp_binding_for_obj(obj, 1);
    if (wrapper != NULL && wrapper != &vphp_null_wrapper) {
      wrapper->magic = VPHP_MAGIC;
      wrapper->original_handlers = original_handlers;
    }
    obj->handlers = cloned_handlers;
  }
  return obj;
}

void vphp_bind_handlers_with_ownership(zend_object *obj, vphp_class_handlers *h,
                                       int owns_v_ptr) {
  vphp_object_wrapper *wrapper = vphp_binding_for_obj(obj, 1);
  if (wrapper == &vphp_null_wrapper) {
    return;
  }
  wrapper->owns_v_ptr = owns_v_ptr ? 1 : 0;
  wrapper->cleanup_raw = h->cleanup_raw;
  wrapper->free_raw = h->free_raw;
  if (h->v_ptr) {
    wrapper->v_ptr = h->v_ptr;
    if (vphp_binding_uses_registry(obj)) {
      vphp_register_object(h->v_ptr, obj);
    }
  }
  wrapper->prop_handler = h->prop_handler;
  wrapper->write_handler = h->write_handler;
  wrapper->sync_handler = h->sync_handler;
}

vphp_object_wrapper *vphp_ensure_instance_binding(zend_object *obj,
                                                  vphp_class_handlers *h,
                                                  int owns_v_ptr) {
  vphp_object_wrapper *wrapper = vphp_binding_for_obj(obj, 1);
  if (wrapper == &vphp_null_wrapper) {
    return wrapper;
  }
  wrapper->cleanup_raw = h->cleanup_raw;
  wrapper->free_raw = h->free_raw;
  wrapper->prop_handler = h->prop_handler;
  wrapper->write_handler = h->write_handler;
  wrapper->sync_handler = h->sync_handler;
  if (wrapper->v_ptr == NULL && h->new_raw != NULL) {
    wrapper->owns_v_ptr = owns_v_ptr ? 1 : wrapper->owns_v_ptr;
    wrapper->v_ptr = h->new_raw();
    if (wrapper->v_ptr != NULL && vphp_binding_uses_registry(obj)) {
      vphp_register_object(wrapper->v_ptr, obj);
    }
  }
  return wrapper;
}

void vphp_bind_handlers(zend_object *obj, vphp_class_handlers *h) {
  vphp_bind_handlers_with_ownership(obj, h, 1);
}

void vphp_bind_owned_handlers(zend_object *obj, vphp_class_handlers *h) {
  vphp_bind_handlers_with_ownership(obj, h, VPHP_OWNS_VPTR);
}

void vphp_bind_borrowed_handlers(zend_object *obj, vphp_class_handlers *h) {
  vphp_bind_handlers_with_ownership(obj, h, VPHP_BORROWS_VPTR);
}

vphp_object_wrapper *vphp_ensure_owned_instance_binding(zend_object *obj,
                                                        vphp_class_handlers *h) {
  return vphp_ensure_instance_binding(obj, h, VPHP_OWNS_VPTR);
}

vphp_object_wrapper *vphp_ensure_borrowed_instance_binding(
    zend_object *obj, vphp_class_handlers *h) {
  return vphp_ensure_instance_binding(obj, h, VPHP_BORROWS_VPTR);
}

void vphp_init_owned_instance(zend_object *obj, vphp_class_handlers *h) {
  vphp_object_wrapper *wrapper = vphp_binding_for_obj(obj, 1);
  if (wrapper == &vphp_null_wrapper || h == NULL) {
    return;
  }
  if (wrapper->v_ptr == NULL && h->new_raw != NULL) {
    wrapper->v_ptr = h->new_raw();
    if (wrapper->v_ptr != NULL && vphp_binding_uses_registry(obj)) {
      vphp_register_object(wrapper->v_ptr, obj);
    }
  }
  vphp_bind_owned_handlers(obj, h);
}
