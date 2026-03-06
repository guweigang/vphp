module main

import vphp

@[php_method]
pub fn (mut r VSlimRequest) construct(method string, raw_path string, body string) &VSlimRequest {
	r.set_method(method)
	r.set_target(raw_path)
	r.set_body(body)
	apply_request_defaults(mut r)
	return r
}

@[php_method]
pub fn (r &VSlimRequest) str() string {
	return '${r.method} ${r.raw_path}'
}

@[php_method]
pub fn (mut r VSlimRequest) set_query(query vphp.ZVal) &VSlimRequest {
	r.query = query.to_string_map()
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_method(method string) &VSlimRequest {
	r.method = method
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_target(raw_path string) &VSlimRequest {
	r.raw_path = raw_path
	r.path, r.query_string = VSlimRequest.normalize_target(raw_path)
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_body(body string) &VSlimRequest {
	r.body = body
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_scheme(scheme string) &VSlimRequest {
	r.scheme = scheme
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_host(host string) &VSlimRequest {
	r.host = host
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_port(port string) &VSlimRequest {
	r.port = port
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_protocol_version(protocol_version string) &VSlimRequest {
	r.protocol_version = protocol_version
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_remote_addr(remote_addr string) &VSlimRequest {
	r.remote_addr = remote_addr
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_headers(headers vphp.ZVal) &VSlimRequest {
	r.headers = normalize_header_map(headers.to_string_map())
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_cookies(cookies vphp.ZVal) &VSlimRequest {
	r.cookies = cookies.to_string_map()
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_attributes(attributes vphp.ZVal) &VSlimRequest {
	r.attributes = attributes.to_string_map()
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_server(server vphp.ZVal) &VSlimRequest {
	r.server = server.to_string_map()
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_uploaded_files(uploaded_files vphp.ZVal) &VSlimRequest {
	r.uploaded_files = uploaded_files.to_string_list()
	return r
}

@[php_method]
pub fn (mut r VSlimRequest) set_params(params vphp.ZVal) &VSlimRequest {
	r.params = params.to_string_map()
	return r
}

@[php_method]
pub fn (r &VSlimRequest) query(key string) string {
	return r.query_values()[key] or { '' }
}

@[php_method]
pub fn (r &VSlimRequest) query_params() map[string]string {
	return r.query_values()
}

@[php_method]
pub fn (r &VSlimRequest) has_query(key string) bool {
	return key in r.query_values()
}

@[php_method]
pub fn (r &VSlimRequest) input(key string) string {
	inputs := r.input_values()
	return inputs[key] or { '' }
}

@[php_method]
pub fn (r &VSlimRequest) input_or(key string, default_value string) string {
	inputs := r.input_values()
	return inputs[key] or { default_value }
}

@[php_method]
pub fn (r &VSlimRequest) has_input(key string) bool {
	inputs := r.input_values()
	return key in inputs
}

@[php_method]
pub fn (r &VSlimRequest) all_inputs() map[string]string {
	return r.input_values()
}

@[php_method]
pub fn (r &VSlimRequest) parsed_body() map[string]string {
	return r.parsed_body_values()
}

@[php_method]
pub fn (r &VSlimRequest) query_all() map[string]string {
	return r.query_params()
}

@[php_method]
pub fn (r &VSlimRequest) header(name string) string {
	headers := r.header_values()
	return headers[VSlimRequest.normalize_header_name(name)] or { '' }
}

@[php_method]
pub fn (r &VSlimRequest) headers() map[string]string {
	return r.header_values()
}

@[php_method]
pub fn (r &VSlimRequest) has_header(name string) bool {
	headers := r.header_values()
	return VSlimRequest.normalize_header_name(name) in headers
}

@[php_method]
pub fn (r &VSlimRequest) content_type() string {
	return r.header('content-type')
}

@[php_method]
pub fn (r &VSlimRequest) cookie(name string) string {
	cookies := r.cookie_values()
	return cookies[name] or { '' }
}

@[php_method]
pub fn (r &VSlimRequest) cookies() map[string]string {
	return r.cookie_values()
}

@[php_method]
pub fn (r &VSlimRequest) has_cookie(name string) bool {
	cookies := r.cookie_values()
	return name in cookies
}

@[php_method]
pub fn (r &VSlimRequest) param(name string) string {
	params := r.route_param_values()
	return params[name] or { '' }
}

@[php_method]
pub fn (r &VSlimRequest) route_params() map[string]string {
	return r.route_param_values()
}

@[php_method]
pub fn (r &VSlimRequest) has_param(name string) bool {
	params := r.route_param_values()
	return name in params
}

@[php_method]
pub fn (r &VSlimRequest) attribute(name string) string {
	attrs := r.attribute_values()
	return attrs[name] or { '' }
}

@[php_method]
pub fn (r &VSlimRequest) attributes() map[string]string {
	return r.attribute_values()
}

@[php_method]
pub fn (r &VSlimRequest) has_attribute(name string) bool {
	attrs := r.attribute_values()
	return name in attrs
}

@[php_method]
pub fn (r &VSlimRequest) server_value(name string) string {
	values := r.server_param_values()
	return values[name] or { '' }
}

@[php_method]
pub fn (r &VSlimRequest) server_params() map[string]string {
	return r.server_param_values()
}

@[php_method]
pub fn (r &VSlimRequest) has_server(name string) bool {
	values := r.server_param_values()
	return name in values
}

@[php_method]
pub fn (r &VSlimRequest) uploaded_file_count() int {
	return r.uploaded_file_values().len
}

@[php_method]
pub fn (r &VSlimRequest) uploaded_files() []string {
	return r.uploaded_file_values()
}

@[php_method]
pub fn (r &VSlimRequest) has_uploaded_files() bool {
	return r.uploaded_file_values().len > 0
}

@[php_method]
pub fn (r &VSlimRequest) is_secure() bool {
	return r.scheme.to_lower() == 'https'
}

@[php_method]
pub fn (r &VSlimRequest) headers_all() map[string]string {
	return r.headers()
}

@[php_method]
pub fn (r &VSlimRequest) cookies_all() map[string]string {
	return r.cookies()
}

@[php_method]
pub fn (r &VSlimRequest) params_all() map[string]string {
	return r.route_params()
}

@[php_method]
pub fn (r &VSlimRequest) attributes_all() map[string]string {
	return r.attributes()
}

@[php_method]
pub fn (r &VSlimRequest) server_all() map[string]string {
	return r.server_params()
}

@[php_method]
pub fn (r &VSlimRequest) uploaded_files_all() []string {
	return r.uploaded_files()
}

fn (r &VSlimRequest) header_values() map[string]string {
	return r.headers.clone()
}

fn (r &VSlimRequest) query_values() map[string]string {
	if r.query.len > 0 {
		return r.query.clone()
	}
	return VSlimRequest.parse_query(r.query_string)
}

fn (r &VSlimRequest) input_values() map[string]string {
	mut out := r.query_values()
	body := r.parsed_body_values()
	for key, value in body {
		out[key] = value
	}
	return out
}

fn (r &VSlimRequest) parsed_body_values() map[string]string {
	mut out := map[string]string{}
	body := r.body.trim_space()
	if body == '' {
		return out
	}
	content_type := r.content_type().to_lower()
	is_json := content_type.contains('application/json') || body.starts_with('{') || body.starts_with('[')
	if is_json {
		decoded := vphp.php_fn('json_decode').call([
			vphp.ZVal.new_string(body),
			vphp.ZVal.new_bool(true),
		])
		if decoded.is_array() {
			return decoded.to_string_map()
		}
		return out
	}
	is_form := content_type.contains('application/x-www-form-urlencoded') || body.contains('=')
	if is_form {
		return VSlimRequest.parse_query(body)
	}
	return out
}

fn (r &VSlimRequest) cookie_values() map[string]string {
	return r.cookies.clone()
}

fn (r &VSlimRequest) attribute_values() map[string]string {
	return r.attributes.clone()
}

fn (r &VSlimRequest) route_param_values() map[string]string {
	return r.params.clone()
}

fn (r &VSlimRequest) server_param_values() map[string]string {
	return r.server.clone()
}

fn (r &VSlimRequest) uploaded_file_values() []string {
	return r.uploaded_files.clone()
}

pub fn (r &VSlimRequest) to_vslim_request() VSlimRequest {
	return VSlimRequest{
		method: r.method
		raw_path: r.raw_path
		path: r.path
		query_string: r.query_string
		scheme: r.scheme
		host: r.host
		port: r.port
		protocol_version: r.protocol_version
		remote_addr: r.remote_addr
		params: r.route_params()
		query: r.query_params()
		body: r.body
		headers: r.headers()
		cookies: r.cookies()
		attributes: r.attributes()
		server: r.server_params()
		uploaded_files: r.uploaded_files()
	}
}

pub fn new_vslim_request(method string, raw_path string, body string) &VSlimRequest {
	path, query_string := VSlimRequest.normalize_target(raw_path)
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
	path, query_string := VSlimRequest.normalize_target(raw_path)
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
	req.query = if part := envelope.get('query') { part.to_string_map() } else { map[string]string{} }
	req.headers = if part := envelope.get('headers') { normalize_header_map(part.to_string_map()) } else { map[string]string{} }
	req.cookies = if part := envelope.get('cookies') { part.to_string_map() } else { map[string]string{} }
	req.attributes = if part := envelope.get('attributes') { part.to_string_map() } else { map[string]string{} }
	req.server = if part := envelope.get('server') { part.to_string_map() } else { map[string]string{} }
	req.uploaded_files = if part := envelope.get('uploaded_files') { part.to_string_list() } else { []string{} }
	req.params = if part := envelope.get('params') { part.to_string_map() } else { map[string]string{} }
	return req
}

fn request_from_envelope(envelope vphp.ZVal) VSlimRequest {
	return new_vslim_request_from_zval(envelope).to_vslim_request()
}

fn split_path_and_query(raw_path string) (string, map[string]string) {
	path, query_str := VSlimRequest.normalize_target(raw_path)
	return path, VSlimRequest.parse_query(query_str)
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
		out[VSlimRequest.normalize_header_name(key)] = value
	}
	return out
}
