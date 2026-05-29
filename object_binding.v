module vphp

import vphp.object

pub fn (z ZVal) bind_object(handlers object.ObjectHandlers, ownership OwnershipKind) {
	ZendObject.from_zval(z).bind_handlers(handlers, ownership)
}

pub fn (z ZVal) bind_owned_object(handlers object.ObjectHandlers) {
	z.bind_object(handlers, .owned_request)
}

pub fn (z ZVal) bind_borrowed_object(handlers object.ObjectHandlers) {
	z.bind_object(handlers, .borrowed)
}
