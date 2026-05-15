module vphp

import vphp.zend

pub struct PhpOutput {}

pub fn PhpOutput.write(msg string) {
	if msg.len == 0 {
		return
	}
	zend.output_write(msg)
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
