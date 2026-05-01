module vphp

// PhpZValWrapper is the minimal semantic wrapper contract.
pub interface PhpZValWrapper {
	to_zval() ZVal
}

// PhpZBoxWrapper is the lifecycle-aware semantic wrapper contract.
// Static constructors like `PhpString.from_zval(...)` cannot be expressed by
// V interfaces, so those stay as naming conventions plus tests.
pub interface PhpZBoxWrapper {
	to_zval() ZVal
	to_borrowed_zbox() RequestBorrowedZBox
	to_request_owned_zbox() RequestOwnedZBox
	to_persistent_owned_zbox() PersistentOwnedZBox
mut:
	release()
}
