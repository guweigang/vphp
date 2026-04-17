module vphp

import vphp.zend as _

pub fn write_output(msg string) {
	if msg.len == 0 {
		return
	}
	unsafe {
		C.vphp_output_write(&char(msg.str), msg.len)
	}
}

pub fn write_output_line(msg string) {
	write_output(msg + '\n')
}
