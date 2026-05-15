#ifndef VPHP_BRIDGE_COMPAT_H
#define VPHP_BRIDGE_COMPAT_H

#include <php.h>
#include <Zend/zend_attributes.h>
#include <Zend/zend_closures.h>
#include <Zend/zend_exceptions.h>
#include <Zend/zend_inheritance.h>
#include <Zend/zend_list.h>

#if PHP_VERSION_ID < 80200
# error "vphp requires PHP 8.2 or newer"
#endif

#if PHP_VERSION_ID >= 80400
# define VPHP_ZEND_RAW_FENTRY(name, handler, arg_info, flags) \
  ZEND_RAW_FENTRY(name, handler, arg_info, flags, NULL, NULL)
#else
# define VPHP_ZEND_RAW_FENTRY(name, handler, arg_info, flags) \
  ZEND_RAW_FENTRY(name, handler, arg_info, flags)
#endif

#ifndef ZEND_TYPE_HAS_LITERAL_NAME
# define ZEND_TYPE_HAS_LITERAL_NAME(type) (0)
#endif

#ifndef ZEND_TYPE_LITERAL_NAME
# define ZEND_TYPE_LITERAL_NAME(type) NULL
#endif

/*
 * Keep direct Zend API touch-points centralized here so future PHP version
 * compatibility work stays in one place instead of leaking across the whole
 * bridge implementation.
 *
 * Prefer PHP/Zend's public extension macros where they already provide a
 * stable extension-facing API, for example REGISTER_*_CONSTANT and
 * ZEND_BEGIN_ARG_* macros. Add compat helpers here when vphp calls lower-level
 * Zend C functions directly and their signatures or return values differ
 * across supported PHP 8 minors.
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
#if PHP_VERSION_ID >= 80500
  return zend_check_user_type_slow(type, value, NULL, is_return_type) != 0;
#else
  return zend_check_user_type_slow(type, value, NULL, NULL, is_return_type) != 0;
#endif
}

static inline bool vphp_zend_is_true(zval *value) {
  return zend_is_true(value) != 0;
}

static inline zend_result vphp_zend_execute_scripts(int type, zval *retval,
                                                    int file_count,
                                                    zend_file_handle *file) {
  return zend_execute_scripts(type, retval, file_count, file);
}

static inline zend_result
vphp_zend_fcall_info_init(zval *callable, zend_fcall_info *fci,
                          zend_fcall_info_cache *fcc, char **error) {
  return zend_fcall_info_init(callable, 0, fci, fcc, NULL, error);
}

static inline zend_result vphp_zend_call_function(zend_fcall_info *fci,
                                                  zend_fcall_info_cache *fcc) {
  return zend_call_function(fci, fcc);
}

static inline void vphp_zend_create_closure(zval *zv, zend_function *func) {
  zend_create_closure(zv, func, NULL, NULL, NULL);
}

static inline zend_attribute *
vphp_zend_add_class_attribute(zend_class_entry *ce, zend_string *name,
                              uint32_t argc) {
  return zend_add_class_attribute(ce, name, argc);
}

static inline zend_attribute *
vphp_zend_add_parameter_attribute(zend_function *func, uint32_t offset,
                                  zend_string *name, uint32_t argc) {
  return zend_add_parameter_attribute(func, offset, name, argc);
}

static inline zend_object *
vphp_zend_throw_exception(zend_class_entry *exception_ce, const char *message,
                          zend_long code) {
  return zend_throw_exception(exception_ce, message, code);
}

static inline void vphp_zend_throw_exception_object(zval *exception) {
  zend_throw_exception_object(exception);
}

static inline void vphp_zend_clear_exception(void) {
  zend_clear_exception();
}

static inline int
vphp_zend_register_list_destructors_ex(rsrc_dtor_func_t ld,
                                       rsrc_dtor_func_t pld,
                                       const char *type_name,
                                       int module_number) {
  return zend_register_list_destructors_ex(ld, pld, type_name, module_number);
}

static inline zend_resource *vphp_zend_register_resource(void *rsrc_pointer,
                                                         int rsrc_type) {
  return zend_register_resource(rsrc_pointer, rsrc_type);
}

static inline void *vphp_zend_fetch_resource(zend_resource *res,
                                             const char *resource_type_name,
                                             int resource_type) {
  return zend_fetch_resource(res, resource_type_name, resource_type);
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

static inline void vphp_zend_do_implement_interface(zend_class_entry *class_ce,
                                                    zend_class_entry *iface_ce) {
  zend_do_implement_interface(class_ce, iface_ce);
}

static inline zval *vphp_zend_read_static_property(zend_class_entry *ce,
                                                   const char *name,
                                                   size_t name_len) {
  return zend_read_static_property(ce, name, name_len, 1);
}

static inline zval *vphp_zend_read_property(zend_class_entry *scope,
                                            zend_object *object,
                                            const char *name,
                                            size_t name_len, bool silent,
                                            zval *rv) {
  return zend_read_property(scope, object, name, name_len, silent, rv);
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
                                               zend_string *member,
                                               zend_property_info *prop_info) {
#if PHP_VERSION_ID >= 80400
  zend_readonly_property_modification_error_ex(ZSTR_VAL(object->ce->name),
                                               ZSTR_VAL(member));
#else
  if (prop_info != NULL && prop_info != ZEND_WRONG_PROPERTY_INFO) {
    zend_readonly_property_modification_error(prop_info);
    return;
  }
  zend_throw_error(NULL, "Cannot modify readonly property %s::$%s",
                   ZSTR_VAL(object->ce->name), ZSTR_VAL(member));
#endif
}

#endif
