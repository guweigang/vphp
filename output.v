module vphp

import vphp.zend as _

pub struct PhpOutput {}

pub fn PhpOutput.write(msg string) {
	if msg.len == 0 {
		return
	}
	unsafe {
		C.vphp_output_write(&char(msg.str), msg.len)
	}
}

pub fn PhpOutput.line(msg string) {
	PhpOutput.write(msg + '\n')
}

pub fn write_output(msg string) {
	PhpOutput.write(msg)
}

pub fn write_output_line(msg string) {
	PhpOutput.line(msg)
}
