module vphp

import vphp.zval

pub struct PhpIncludeFile {
	path string
}

pub fn PhpIncludeFile.at(path string) PhpIncludeFile {
	return PhpIncludeFile{
		path: path
	}
}

pub fn (file PhpIncludeFile) path() string {
	return file.path
}

fn (file PhpIncludeFile) load_with_once_flag(once bool) ZVal {
	retval := zval.include_file(file.path, once)
	if !retval.is_valid() {
		return invalid_zval()
	}
	return adopt_handle_with_ownership(retval, .owned_request)
}

pub fn (file PhpIncludeFile) load_zval() ZVal {
	return file.load_with_once_flag(false)
}

pub fn (file PhpIncludeFile) load_once_zval() ZVal {
	return file.load_with_once_flag(true)
}

pub fn (file PhpIncludeFile) load() PhpValue {
	return PhpValue.adopt_zval(file.load_zval())
}

pub fn (file PhpIncludeFile) load_once() PhpValue {
	return PhpValue.adopt_zval(file.load_once_zval())
}

pub fn include_zval(path string) ZVal {
	return PhpIncludeFile.at(path).load_zval()
}

pub fn include_once_zval(path string) ZVal {
	return PhpIncludeFile.at(path).load_once_zval()
}

pub fn include(path string) PhpValue {
	return PhpIncludeFile.at(path).load()
}

pub fn include_once(path string) PhpValue {
	return PhpIncludeFile.at(path).load_once()
}
