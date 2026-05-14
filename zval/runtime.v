module zval

import vphp.zend

pub struct RuntimeState {
pub:
	autorelease_len  int
	owned_len        int
	obj_registry_len u32
	rev_registry_len u32
}

pub fn runtime_state() RuntimeState {
	mut ar := 0
	mut owned := 0
	mut obj_reg := u32(0)
	mut rev_reg := u32(0)
	zend.runtime_counters(&ar, &owned, &obj_reg, &rev_reg)
	return RuntimeState{
		autorelease_len:  ar
		owned_len:        owned
		obj_registry_len: obj_reg
		rev_registry_len: rev_reg
	}
}
