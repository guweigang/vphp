module vphp

fn C.vphp_allocate_contiguous_object(ce voidptr, v_size usize) voidptr
fn C.vphp_get_wrapper_from_vptr(v_ptr voidptr) voidptr
fn C.builtin___v_free(ptr voidptr)

// Preserve V default field initialization for generated PHP classes.
pub fn generic_new_raw[T]() voidptr {
	unsafe {
		ptr := &T{}
		register_vptr_root(ptr)
		return ptr
	}
}

// Free generated PHP class payloads through V runtime semantics.
pub fn generic_free_raw[T](ptr voidptr) {
	if ptr == 0 {
		return
	}
	unregister_vptr_root(ptr)
	unsafe {
		mut obj := &T(ptr)
		$for field in T.fields {
			$if field.typ is PersistentOwnedZBox {
				obj.$(field.name).release()
			} $else $if field.typ is RetainedObject {
				obj.$(field.name).release()
			} $else $if field.typ is RetainedCallable {
				obj.$(field.name).release()
			} $else $if field.typ is []PersistentOwnedZBox {
				for mut box in obj.$(field.name) {
					box.release()
				}
				$if nongc ? {
					obj.$(field.name).free()
				}
			} $else $if field.typ is map[string]PersistentOwnedZBox {
				for _, mut box in obj.$(field.name) {
					box.release()
				}
				$if nongc ? {
					obj.$(field.name).free()
				}
			} $else $if field.typ is []RetainedObject {
				for mut box in obj.$(field.name) {
					box.release()
				}
				$if nongc ? {
					obj.$(field.name).free()
				}
			} $else $if field.typ is map[string]RetainedObject {
				for _, mut box in obj.$(field.name) {
					box.release()
				}
				$if nongc ? {
					obj.$(field.name).free()
				}
			} $else $if field.typ is []RetainedCallable {
				for mut box in obj.$(field.name) {
					box.release()
				}
				$if nongc ? {
					obj.$(field.name).free()
				}
			} $else $if field.typ is map[string]RetainedCallable {
				for _, mut box in obj.$(field.name) {
					box.release()
				}
				$if nongc ? {
					obj.$(field.name).free()
				}
			}
		}
		$if nongc ? {
			C.builtin___v_free(ptr)
		}
	}
}

pub fn allocate_contiguous_object[T](ce voidptr) voidptr {
	return unsafe { C.vphp_allocate_contiguous_object(ce, sizeof(T)) }
}
