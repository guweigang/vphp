module main

import vphp

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
pub fn (mut r VSlimRequest) set_query(query vphp.ZVal) &VSlimRequest {
	r.query = zval_to_name_map(query)
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_headers(headers vphp.ZVal) &VSlimRequest {
	r.headers = normalize_header_map(zval_to_name_map(headers))
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_cookies(cookies vphp.ZVal) &VSlimRequest {
	r.cookies = zval_to_name_map(cookies)
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_attributes(attributes vphp.ZVal) &VSlimRequest {
	r.attributes = zval_to_name_map(attributes)
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_server(server vphp.ZVal) &VSlimRequest {
	r.server = zval_to_name_map(server)
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_uploaded_files(uploaded_files vphp.ZVal) &VSlimRequest {
	r.uploaded_files = zval_to_string_list(uploaded_files)
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_params(params vphp.ZVal) &VSlimRequest {
	r.params = zval_to_name_map(params)
	return r
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

fn (r &VSlimRequest) headers() map[string]string {
	return r.headers.clone()
}

fn (r &VSlimRequest) query_params() map[string]string {
	if r.query.len > 0 {
		return r.query.clone()
	}
	return parse_query_string(r.query_string)
}

fn (r &VSlimRequest) cookies() map[string]string {
	return r.cookies.clone()
}

fn (r &VSlimRequest) attributes() map[string]string {
	return r.attributes.clone()
}

fn (r &VSlimRequest) params() map[string]string {
	return r.params.clone()
}

fn (r &VSlimRequest) server_values() map[string]string {
	return r.server.clone()
}

fn (r &VSlimRequest) uploaded_files_list() []string {
	return r.uploaded_files.clone()
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

pub fn new_vslim_request_from_zval(envelope vphp.ZVal) &VSlimRequest {
	method := if part := envelope.get('method') { part.to_string() } else { 'GET' }
	raw_path := if part := envelope.get('path') { part.to_string() } else { '/' }
	body := if part := envelope.get('body') { part.to_string() } else { '' }
	path, query_string := normalize_request_target(raw_path)
	mut req := &VSlimRequest{
		method: method
		raw_path: raw_path
		path: path
		query_string: query_string
		body: body
	}
	apply_request_defaults(mut req)
	req.scheme = if part := envelope.get('scheme') { part.to_string() } else { req.scheme }
	req.host = if part := envelope.get('host') { part.to_string() } else { req.host }
	req.port = if part := envelope.get('port') { part.to_string() } else { req.port }
	req.protocol_version = if part := envelope.get('protocol_version') { part.to_string() } else { req.protocol_version }
	req.remote_addr = if part := envelope.get('remote_addr') { part.to_string() } else { req.remote_addr }
	req.query = if part := envelope.get('query') { zval_to_name_map(part) } else { map[string]string{} }
	req.headers = if part := envelope.get('headers') { normalize_header_map(zval_to_name_map(part)) } else { map[string]string{} }
	req.cookies = if part := envelope.get('cookies') { zval_to_name_map(part) } else { map[string]string{} }
	req.attributes = if part := envelope.get('attributes') { zval_to_name_map(part) } else { map[string]string{} }
	req.server = if part := envelope.get('server') { zval_to_name_map(part) } else { map[string]string{} }
	req.uploaded_files = if part := envelope.get('uploaded_files') { zval_to_string_list(part) } else { []string{} }
	req.params = if part := envelope.get('params') { zval_to_name_map(part) } else { map[string]string{} }
	return req
}

fn request_from_envelope(envelope vphp.ZVal) SlimRequest {
	return new_vslim_request_from_zval(envelope).to_slim_request()
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
	r.query = map[string]string{}
	r.headers = map[string]string{}
	r.cookies = map[string]string{}
	r.attributes = map[string]string{}
	r.server = map[string]string{}
	r.uploaded_files = []string{}
	r.params = map[string]string{}
}

fn normalize_header_map(headers map[string]string) map[string]string {
	mut out := map[string]string{}
	for key, value in headers {
		out[normalize_header_name(key)] = value
	}
	return out
}
