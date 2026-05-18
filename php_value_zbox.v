module vphp

pub enum PhpValueZBoxKind {
	borrowed
	request_owned
	persistent_owned
}

pub struct PhpValueZBox {
	kind PhpValueZBoxKind
mut:
	request_borrowed ?RequestBorrowedZBox
	request_owned    ?RequestOwnedZBox
	persistent_owned ?PersistentOwnedZBox
}

pub fn PhpValueZBox.borrowed(value RequestBorrowedZBox) PhpValueZBox {
	return PhpValueZBox{
		kind:             .borrowed
		request_borrowed: value
	}
}

pub fn PhpValueZBox.from_zval(z ZVal) PhpValueZBox {
	return PhpValueZBox.borrowed(RequestBorrowedZBox.from_zval(z))
}

pub fn PhpValueZBox.request_owned(value RequestOwnedZBox) PhpValueZBox {
	return PhpValueZBox{
		kind:          .request_owned
		request_owned: value
	}
}

pub fn PhpValueZBox.adopt_zval(z ZVal) PhpValueZBox {
	return PhpValueZBox.request_owned(RequestOwnedZBox.adopt_zval(z))
}

pub fn PhpValueZBox.persistent_owned(value PersistentOwnedZBox) PhpValueZBox {
	return PhpValueZBox{
		kind:             .persistent_owned
		persistent_owned: value
	}
}

pub fn (v PhpValueZBox) kind_name() string {
	return match v.kind {
		.borrowed { 'borrowed' }
		.request_owned { 'request_owned' }
		.persistent_owned { 'persistent_owned' }
	}
}

pub fn (v PhpValueZBox) is_borrowed() bool {
	return v.kind == .borrowed
}

pub fn (v PhpValueZBox) is_request_owned() bool {
	return v.kind == .request_owned
}

pub fn (v PhpValueZBox) is_retained() bool {
	return v.kind == .persistent_owned
}

pub fn (v PhpValueZBox) is_persistent_owned() bool {
	return v.kind == .persistent_owned
}

pub fn (v PhpValueZBox) is_owned() bool {
	return v.kind == .request_owned || v.kind == .persistent_owned
}

pub fn (v PhpValueZBox) is_valid() bool {
	return match v.kind {
		.borrowed { (v.request_borrowed or { return false }).to_zval().is_valid() }
		.request_owned { (v.request_owned or { return false }).to_zval().is_valid() }
		.persistent_owned { (v.persistent_owned or { return false }).is_valid() }
	}
}

pub fn (v PhpValueZBox) to_zval() ZVal {
	return match v.kind {
		.borrowed { (v.request_borrowed or { RequestBorrowedZBox.from_zval(invalid_zval()) }).to_zval() }
		.request_owned { (v.request_owned or { RequestOwnedZBox.adopt_zval(invalid_zval()) }).to_zval() }
		.persistent_owned { (v.persistent_owned or { PersistentOwnedZBox.new_null() }).to_zval() }
	}
}

pub fn (v PhpValueZBox) borrowed() PhpValueZBox {
	return PhpValueZBox.borrowed(match v.kind {
		.borrowed { v.request_borrowed or { RequestBorrowedZBox.from_zval(invalid_zval()) } }
		.request_owned { (v.request_owned or { RequestOwnedZBox.adopt_zval(invalid_zval()) }).borrowed() }
		.persistent_owned { (v.persistent_owned or { PersistentOwnedZBox.new_null() }).borrowed() }
	})
}

pub fn (v PhpValueZBox) to_borrowed_zbox() RequestBorrowedZBox {
	return match v.kind {
		.borrowed { v.request_borrowed or { RequestBorrowedZBox.from_zval(invalid_zval()) } }
		.request_owned { (v.request_owned or { RequestOwnedZBox.adopt_zval(invalid_zval()) }).borrowed() }
		.persistent_owned { (v.persistent_owned or { PersistentOwnedZBox.new_null() }).borrowed() }
	}
}

pub fn (v PhpValueZBox) to_request_owned() RequestOwnedZBox {
	return match v.kind {
		.borrowed { (v.request_borrowed or { RequestBorrowedZBox.from_zval(invalid_zval()) }).clone_request_owned() }
		.request_owned { (v.request_owned or { RequestOwnedZBox.adopt_zval(invalid_zval()) }).clone_request_owned() }
		.persistent_owned { (v.persistent_owned or { PersistentOwnedZBox.new_null() }).clone_request_owned() }
	}
}

pub fn (v PhpValueZBox) to_request_owned_zbox() RequestOwnedZBox {
	return v.to_request_owned()
}

pub fn (mut v PhpValueZBox) take_zval() ZVal {
	match v.kind {
		.borrowed {
			mut out :=
				(v.request_borrowed or { RequestBorrowedZBox.from_zval(invalid_zval()) }).clone_request_owned()
			return out.take_zval()
		}
		.request_owned {
			if mut out := v.request_owned {
				v.request_owned = none
				return out.take_zval()
			}
			return invalid_zval()
		}
		.persistent_owned {
			mut out :=
				(v.persistent_owned or { PersistentOwnedZBox.new_null() }).clone_request_owned()
			return out.take_zval()
		}
	}
}

pub fn (v PhpValueZBox) to_persistent_owned_zbox() PersistentOwnedZBox {
	return match v.kind {
		.borrowed { (v.request_borrowed or { RequestBorrowedZBox.from_zval(invalid_zval()) }).clone() }
		.request_owned { (v.request_owned or { RequestOwnedZBox.adopt_zval(invalid_zval()) }).to_persistent_owned_zbox() }
		.persistent_owned { (v.persistent_owned or { PersistentOwnedZBox.new_null() }).clone() }
	}
}

pub fn (v PhpValueZBox) clone() PhpValueZBox {
	return match v.kind {
		.borrowed {
			PhpValueZBox.borrowed(v.request_borrowed or {
				RequestBorrowedZBox.from_zval(invalid_zval())
			})
		}
		.request_owned {
			PhpValueZBox.request_owned((v.request_owned or {
				RequestOwnedZBox.adopt_zval(invalid_zval())
			}).clone_request_owned())
		}
		.persistent_owned {
			PhpValueZBox.persistent_owned((v.persistent_owned or { PersistentOwnedZBox.new_null() }).clone())
		}
	}
}

pub fn (mut v PhpValueZBox) release() {
	match v.kind {
		.borrowed {}
		.request_owned {
			if mut box := v.request_owned {
				box.release()
			}
		}
		.persistent_owned {
			if mut box := v.persistent_owned {
				box.release()
			}
		}
	}

	v.request_borrowed = none
	v.request_owned = none
	v.persistent_owned = none
}
