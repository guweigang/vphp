module vphp

pub struct StreamMetadata {
pub:
	mode      string
	uri       string
	seekable  bool
	timed_out bool
	blocked   bool
	eof       bool
}

pub fn (v ZVal) resource_type() ?string {
	if !v.is_valid() || !v.is_resource() {
		return none
	}
	res := php_fn('get_resource_type').call([v])
	if !res.is_valid() || res.is_null() || res.is_undef() {
		return none
	}
	type_name := res.to_string().trim_space()
	if type_name == '' {
		return none
	}
	return type_name
}

pub fn (v ZVal) stream_metadata() ?StreamMetadata {
	if !v.is_valid() || !v.is_resource() {
		return none
	}
	resource_type := v.resource_type() or { return none }
	if resource_type != 'stream' {
		return none
	}
	meta := php_fn('stream_get_meta_data').call([v])
	if !meta.is_valid() || !meta.is_array() {
		return none
	}
	return StreamMetadata{
		mode:      zval_string_key_or(meta, 'mode', '')
		uri:       zval_string_key_or(meta, 'uri', '')
		seekable:  zval_bool_key_or(meta, 'seekable', false)
		timed_out: zval_bool_key_or(meta, 'timed_out', false)
		blocked:   zval_bool_key_or(meta, 'blocked', false)
		eof:       zval_bool_key_or(meta, 'eof', false)
	}
}

pub fn (v ZVal) is_stream_resource() bool {
	return v.stream_metadata() != none
}

pub fn (v ZVal) stream_rewind() bool {
	if !v.is_stream_resource() {
		return false
	}
	res := php_fn('rewind').call([v])
	return res.is_valid() && (!res.is_bool() || res.to_bool())
}

pub fn (v ZVal) stream_get_contents() ?string {
	if !v.is_stream_resource() {
		return none
	}
	content := php_fn('stream_get_contents').call([v])
	if !content.is_valid() || content.is_null() || content.is_undef()
		|| (content.is_bool() && !content.to_bool()) {
		return none
	}
	return content.to_string()
}

pub fn (v ZVal) stream_eof() bool {
	if !v.is_stream_resource() {
		return true
	}
	res := php_fn('feof').call([v])
	return res.is_valid() && res.to_bool()
}

pub fn (v ZVal) stream_read_line() ?string {
	if !v.is_stream_resource() {
		return none
	}
	line := php_fn('fgets').call([v])
	if !line.is_valid() || line.is_null() || line.is_undef() || (line.is_bool() && !line.to_bool()) {
		return none
	}
	return line.to_string()
}

pub fn (v ZVal) stream_close() bool {
	if !v.is_stream_resource() {
		return false
	}
	res := php_fn('fclose').call([v])
	return res.is_valid() && (!res.is_bool() || res.to_bool())
}

// resource
pub fn (v ZVal) to_res() voidptr {
	return C.vphp_fetch_res(v.raw)
}
