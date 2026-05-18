module vphp

import vphp.object

// Preserve V default field initialization for generated PHP classes.
pub fn generic_new_raw[T]() voidptr {
	unsafe {
		ptr := &T{}
		object.register_root(ptr)
		return ptr
	}
}

// Free generated PHP class payloads through V runtime semantics.
pub fn generic_free_raw[T](ptr voidptr) {
	if ptr == 0 {
		return
	}
	object.unregister_root(ptr)
	unsafe {
		mut obj := &T(ptr)
		$for field in T.fields {
			$if field.typ is PersistentOwnedZBox {
				obj.$(field.name).release()
			} $else $if field.typ is PhpValue {
				obj.$(field.name).release()
			} $else $if field.typ is PhpArray {
				obj.$(field.name).release()
			} $else $if field.typ is PhpObject {
				obj.$(field.name).release()
			} $else $if field.typ is PhpCallable {
				obj.$(field.name).release()
			} $else $if field.typ is PhpClosure {
				obj.$(field.name).release()
			} $else $if field.typ is PhpIterable {
				obj.$(field.name).release()
			} $else $if field.typ is PhpIterator {
				obj.$(field.name).release()
			} $else $if field.typ is PhpResource {
				obj.$(field.name).release()
			} $else $if field.typ is PhpReference {
				obj.$(field.name).release()
			} $else $if field.typ is PhpNull {
				obj.$(field.name).release()
			} $else $if field.typ is PhpBool {
				obj.$(field.name).release()
			} $else $if field.typ is PhpInt {
				obj.$(field.name).release()
			} $else $if field.typ is PhpDouble {
				obj.$(field.name).release()
			} $else $if field.typ is PhpString {
				obj.$(field.name).release()
			} $else $if field.typ is PhpScalar {
				obj.$(field.name).release()
			} $else $if field.typ is PhpThrowable {
				obj.$(field.name).release()
			} $else $if field.typ is PhpEnumCase {
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
			} $else $if field.typ is []PhpValue {
				for mut box in obj.$(field.name) {
					box.release()
				}
				$if nongc ? {
					obj.$(field.name).free()
				}
			} $else $if field.typ is []PhpObject {
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
			} $else $if field.typ is map[string]PhpValue {
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
			} $else $if field.typ is map[string]PhpObject {
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
			} $else $if field.typ is map[string]PhpCallable {
				for _, mut box in obj.$(field.name) {
					box.release()
				}
				$if nongc ? {
					obj.$(field.name).free()
				}
			}
		}
		$if nongc ? {
			object.runtime_free(ptr)
		}
	}
}
