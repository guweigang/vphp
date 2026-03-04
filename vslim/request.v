module main

import json

@[php_method]
pub fn (mut r VSlimRequest) construct(method string, raw_path string, body string) &VSlimRequest {
	r.method = method
	r.raw_path = raw_path
	r.path, r.query_string = normalize_request_target(raw_path)
	r.body = body
	apply_request_defaults(mut r)
	return r
}

@[php_method]
pub fn (r &VSlimRequest) str() string {
	return '${r.method} ${r.raw_path}'
}

@[php_method]
pub fn (r &VSlimRequest) query(key string) string {
	return r.query_params()[key] or { '' }
}

@[php_method]
pub fn (r &VSlimRequest) has_query(key string) bool {
	return key in r.query_params()
}

@[php_method]
pub fn (r &VSlimRequest) header(name string) string {
	headers := r.headers()
	return headers[normalize_header_name(name)] or { '' }
}

@[php_method]
pub fn (r &VSlimRequest) has_header(name string) bool {
	headers := r.headers()
	return normalize_header_name(name) in headers
}

@[php_method]
pub fn (r &VSlimRequest) cookie(name string) string {
	cookies := r.cookies()
	return cookies[name] or { '' }
}

@[php_method]
pub fn (r &VSlimRequest) has_cookie(name string) bool {
	cookies := r.cookies()
	return name in cookies
}

@[php_method]
pub fn (r &VSlimRequest) param(name string) string {
	params := r.params()
	return params[name] or { '' }
}

@[php_method]
pub fn (r &VSlimRequest) has_param(name string) bool {
	params := r.params()
	return name in params
}

@[php_method]
pub fn (r &VSlimRequest) attribute(name string) string {
	attrs := r.attributes()
	return attrs[name] or { '' }
}

@[php_method]
pub fn (r &VSlimRequest) has_attribute(name string) bool {
	attrs := r.attributes()
	return name in attrs
}

@[php_method]
pub fn (r &VSlimRequest) query_json_value() string {
	return r.query_json
}

pub fn (r &VSlimRequest) headers() map[string]string {
	return parse_headers_json(r.headers_json)
}

pub fn (r &VSlimRequest) query_params() map[string]string {
	if r.query_json != '' && r.query_json != '{}' {
		return parse_name_map_json(r.query_json)
	}
	return parse_query_string(r.query_string)
}

pub fn (r &VSlimRequest) cookies() map[string]string {
	return parse_name_map_json(r.cookies_json)
}

pub fn (r &VSlimRequest) attributes() map[string]string {
	return parse_name_map_json(r.attributes_json)
}

pub fn (r &VSlimRequest) params() map[string]string {
	return parse_name_map_json(r.params_json)
}

pub fn (r &VSlimRequest) to_slim_request() SlimRequest {
	return SlimRequest{
		method: r.method
		path: r.path
		params: r.params()
		query: r.query_params()
		body: r.body
	}
}

pub fn new_vslim_request(method string, raw_path string, body string) &VSlimRequest {
	path, query_string := normalize_request_target(raw_path)
	mut req := &VSlimRequest{
		method: method
		raw_path: raw_path
		path: path
		query_string: query_string
		body: body
	}
	apply_request_defaults(mut req)
	return req
}

pub fn new_vslim_request_from_envelope(envelope map[string]string) &VSlimRequest {
	method := envelope['method'] or { 'GET' }
	raw_path := envelope['path'] or { '/' }
	body := envelope['body'] or { '' }
	path, query_string := normalize_request_target(raw_path)
	mut req := &VSlimRequest{
		method: method
		raw_path: raw_path
		path: path
		query_string: query_string
		body: body
	}
	apply_request_defaults(mut req)
	req.scheme = envelope['scheme'] or { req.scheme }
	req.host = envelope['host'] or { req.host }
	req.port = envelope['port'] or { req.port }
	req.protocol_version = envelope['protocol_version'] or { req.protocol_version }
	req.remote_addr = envelope['remote_addr'] or { req.remote_addr }
	req.query_json = envelope['query_json'] or { req.query_json }
	req.headers_json = envelope['headers_json'] or { req.headers_json }
	req.cookies_json = envelope['cookies_json'] or { req.cookies_json }
	req.attributes_json = envelope['attributes_json'] or { req.attributes_json }
	req.server_json = envelope['server_json'] or { req.server_json }
	req.uploaded_files_json = envelope['uploaded_files_json'] or { req.uploaded_files_json }
	req.params_json = envelope['params_json'] or { req.params_json }
	return req
}

fn request_from_envelope(envelope map[string]string) SlimRequest {
	return new_vslim_request_from_envelope(envelope).to_slim_request()
}

fn split_path_and_query(raw_path string) (string, map[string]string) {
	path, query_str := normalize_request_target(raw_path)
	return path, parse_query_string(query_str)
}

fn apply_request_defaults(mut r VSlimRequest) {
	r.scheme = 'http'
	r.host = ''
	r.port = ''
	r.protocol_version = '1.1'
	r.remote_addr = ''
	r.query_json = '{}'
	r.headers_json = '{}'
	r.cookies_json = '{}'
	r.attributes_json = '{}'
	r.server_json = '{}'
	r.uploaded_files_json = '[]'
	r.params_json = '{}'
}

fn parse_name_map_json(raw string) map[string]string {
	if raw == '' {
		return map[string]string{}
	}
	decoded := json.decode(map[string]string, raw) or {
		return map[string]string{}
	}
	return decoded
}

fn parse_headers_json(headers_json string) map[string]string {
	decoded := parse_name_map_json(headers_json)
	mut out := map[string]string{}
	for key, value in decoded {
		out[normalize_header_name(key)] = value
	}
	return out
}
