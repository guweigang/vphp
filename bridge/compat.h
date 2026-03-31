#ifndef VPHP_BRIDGE_COMPAT_H
#define VPHP_BRIDGE_COMPAT_H

#include <php.h>

/*
 * Keep direct Zend API touch-points centralized here so future PHP version
 * compatibility work stays in one place instead of leaking across the whole
 * bridge implementation.
 */
static inline zend_class_entry *
vphp_zend_get_called_scope(zend_execute_data *execute_data) {
  return zend_get_called_scope(execute_data);
}

static inline zend_class_entry *vphp_zend_lookup_class(zend_string *name) {
  return zend_lookup_class(name);
}

static inline zend_class_entry *vphp_zend_lookup_class_ex(zend_string *name) {
  return zend_lookup_class_ex(name, NULL, 0);
}

static inline bool vphp_zend_verify_scalar_type_hint(uint32_t mask, zval *value,
                                                     bool strict) {
  return zend_verify_scalar_type_hint(mask, value, strict, 1);
}

static inline void vphp_zend_wrong_parameters_count_error(uint32_t min_args,
                                                          uint32_t max_args) {
  zend_wrong_parameters_count_error(min_args, max_args);
}

static inline void vphp_zend_verify_arg_error(const zend_function *func,
                                              const zend_arg_info *arg_info,
                                              uint32_t arg_num, zval *value) {
  zend_verify_arg_error(func, arg_info, arg_num, value);
}

static inline void
vphp_zend_verify_return_error(const zend_function *func, zval *value) {
  zend_verify_return_error(func, value);
}

static inline void
vphp_zend_verify_never_error(const zend_function *func) {
  zend_verify_never_error(func);
}

static inline bool vphp_zend_check_user_type_slow(zend_type *type, zval *value,
                                                  bool is_return_type) {
  return zend_check_user_type_slow(type, value, NULL, is_return_type) != 0;
}

static inline bool vphp_zend_is_callable(zval *value) {
  return zend_is_callable(value, 0, NULL) != 0;
}

static inline bool vphp_zend_is_iterable(zval *value) {
  return zend_is_iterable(value) != 0;
}

static inline int
vphp_zend_class_implements_interface(zend_class_entry *class_ce,
                                     zend_class_entry *iface_ce) {
  return zend_class_implements_interface(class_ce, iface_ce);
}

static inline zval *vphp_zend_read_static_property(zend_class_entry *ce,
                                                   const char *name,
                                                   size_t name_len) {
  return zend_read_static_property(ce, name, name_len, 1);
}

static inline void vphp_zend_update_static_property(zend_class_entry *ce,
                                                    const char *name,
                                                    size_t name_len,
                                                    zval *value) {
  zend_update_static_property(ce, name, name_len, value);
}

static inline void
vphp_zend_update_static_property_long(zend_class_entry *ce, const char *name,
                                      size_t name_len, zend_long value) {
  zend_update_static_property_long(ce, name, name_len, value);
}

static inline void
vphp_zend_update_static_property_string(zend_class_entry *ce, const char *name,
                                        size_t name_len, const char *value,
                                        size_t value_len) {
  zend_update_static_property_stringl(ce, name, name_len, value, value_len);
}

static inline void
vphp_zend_update_static_property_bool(zend_class_entry *ce, const char *name,
                                      size_t name_len, bool value) {
  zend_update_static_property_bool(ce, name, name_len, value ? 1 : 0);
}

static inline zval *vphp_zend_get_class_constant(zend_string *class_name,
                                                 zend_string *const_name) {
  return zend_get_class_constant_ex(class_name, const_name, NULL, 0);
}

static inline void
vphp_zend_readonly_property_modification_error(zend_object *object,
                                               zend_string *member) {
  zend_readonly_property_modification_error_ex(ZSTR_VAL(object->ce->name),
                                               ZSTR_VAL(member));
}

#endif
