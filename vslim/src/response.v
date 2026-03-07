module main

@[php_method]
pub fn (mut r VSlimResponse) construct(status int, body string, content_type string) &VSlimResponse {
	r.status = status
	r.body = body
	r.content_type = content_type
	r.headers = {
		'content-type': content_type
	}
	return r
}

@[php_method]
pub fn (r &VSlimResponse) header(name string) string {
	headers := r.header_values()
	return headers[VSlimRequest.normalize_header_name(name)] or { '' }
}

@[php_method]
pub fn (r &VSlimResponse) headers() map[string]string {
	return r.header_values()
}

@[php_method]
pub fn (r &VSlimResponse) has_header(name string) bool {
	headers := r.header_values()
	return VSlimRequest.normalize_header_name(name) in headers
}

@[php_method]
pub fn (mut r VSlimResponse) set_header(name string, value string) &VSlimResponse {
	mut headers := r.header_values()
	headers[VSlimRequest.normalize_header_name(name)] = value
	apply_response_headers(mut r, headers)
	return r
}

@[php_method]
pub fn (mut r VSlimResponse) with_request_id(request_id string) &VSlimResponse {
	if request_id == '' {
		return r
	}
	return r.set_header('x-request-id', request_id)
}

@[php_method]
pub fn (mut r VSlimResponse) with_trace_id(trace_id string) &VSlimResponse {
	if trace_id == '' {
		return r
	}
	r.set_header('x-trace-id', trace_id)
	if !r.has_header('x-vhttpd-trace-id') {
		r.set_header('x-vhttpd-trace-id', trace_id)
	}
	return r
}

@[php_method]
pub fn (mut r VSlimResponse) set_content_type(content_type string) &VSlimResponse {
	r.content_type = content_type
	mut headers := r.header_values()
	headers['content-type'] = content_type
	apply_response_headers(mut r, headers)
	return r
}

@[php_method]
pub fn (r &VSlimResponse) cookie_header() string {
	return r.header('set-cookie')
}

@[php_method]
pub fn (mut r VSlimResponse) set_cookie(name string, value string) &VSlimResponse {
	return r.set_cookie_opts(name, value, '/')
}

@[php_method]
pub fn (mut r VSlimResponse) set_cookie_opts(name string, value string, path string) &VSlimResponse {
	return r.set_cookie_full(name, value, path, '', 0, false, false, '')
}

@[php_method]
pub fn (mut r VSlimResponse) set_cookie_full(name string, value string, path string, domain string, max_age int, secure bool, http_only bool, same_site string) &VSlimResponse {
	header_value := build_set_cookie_header(name, value, path, domain, max_age, secure, http_only, same_site)
	mut headers := r.header_values()
	headers['set-cookie'] = header_value
	apply_response_headers(mut r, headers)
	return r
}

@[php_method]
pub fn (mut r VSlimResponse) delete_cookie(name string) &VSlimResponse {
	header_value := '${name}=; Path=/; Max-Age=0'
	mut headers := r.header_values()
	headers['set-cookie'] = header_value
	apply_response_headers(mut r, headers)
	return r
}

@[php_method]
pub fn (mut r VSlimResponse) set_status(status int) &VSlimResponse {
	r.status = status
	return r
}

@[php_method]
pub fn (mut r VSlimResponse) with_status(status int) &VSlimResponse {
	return r.set_status(status)
}

@[php_method]
pub fn (mut r VSlimResponse) text(body string) &VSlimResponse {
	r.body = body
	r.content_type = 'text/plain; charset=utf-8'
	mut headers := r.header_values()
	headers['content-type'] = r.content_type
	apply_response_headers(mut r, headers)
	return r
}

@[php_method]
pub fn (mut r VSlimResponse) json(body string) &VSlimResponse {
	r.body = body
	r.content_type = 'application/json; charset=utf-8'
	mut headers := r.header_values()
	headers['content-type'] = r.content_type
	apply_response_headers(mut r, headers)
	return r
}

@[php_method]
pub fn (mut r VSlimResponse) html(body string) &VSlimResponse {
	r.body = body
	r.content_type = 'text/html'
	mut headers := r.header_values()
	headers['content-type'] = r.content_type
	apply_response_headers(mut r, headers)
	return r
}

@[php_method]
pub fn (mut r VSlimResponse) redirect(location string) &VSlimResponse {
	return r.redirect_with_status(location, 302)
}

@[php_method]
pub fn (mut r VSlimResponse) redirect_with_status(location string, status int) &VSlimResponse {
	r.status = status
	r.body = ''
	mut headers := r.header_values()
	headers['location'] = location
	if 'content-type' !in headers {
		headers['content-type'] = r.content_type
	}
	apply_response_headers(mut r, headers)
	return r
}

@[php_method]
pub fn (r &VSlimResponse) headers_all() map[string]string {
	return r.headers()
}

fn (r &VSlimResponse) header_values() map[string]string {
	return r.headers.clone()
}

pub fn (r &VSlimResponse) as_array() map[string]string {
	return {
		'status': '${r.status}'
		'body': r.body
		'content_type': r.content_type
	}
}

@[php_method]
pub fn (r &VSlimResponse) str() string {
	return '${r.status} ${r.content_type} ${r.body}'
}

@[php_method]
pub fn (r &VSlimResponse) content_length() int {
	return r.body.len
}

fn to_vslim_response(res VSlimResponse) &VSlimResponse {
	return &VSlimResponse{
		status: res.status
		body: res.body
		content_type: res.content_type
		headers: res.headers.clone()
	}
}

fn apply_response_headers(mut r VSlimResponse, headers map[string]string) {
	r.headers = normalize_header_map(headers)
	r.content_type = r.headers['content-type'] or { r.content_type }
}

fn build_set_cookie_header(name string, value string, path string, domain string, max_age int, secure bool, http_only bool, same_site string) string {
	mut parts := ['${name}=${value}']
	cookie_path := if path == '' { '/' } else { path }
	parts << 'Path=${cookie_path}'
	if domain != '' {
		parts << 'Domain=${domain}'
	}
	if max_age != 0 {
		if max_age > 0 {
			parts << 'Max-Age=${max_age}'
		} else {
			parts << 'Max-Age=0'
		}
	}
	if http_only {
		parts << 'HttpOnly'
	}
	if secure {
		parts << 'Secure'
	}
	match same_site.to_lower() {
		'lax' {
			parts << 'SameSite=Lax'
		}
		'strict' {
			parts << 'SameSite=Strict'
		}
		'none' {
			parts << 'SameSite=None'
		}
		'default' {
			parts << 'SameSite'
		}
		else {}
	}
	return parts.join('; ')
}

fn text_response(status int, body string) VSlimResponse {
	return VSlimResponse{
		status: status
		body: body
		content_type: 'text/plain; charset=utf-8'
		headers: {
			'content-type': 'text/plain; charset=utf-8'
		}
	}
}

fn json_response(status int, json_body string) VSlimResponse {
	return VSlimResponse{
		status: status
		body: json_body
		content_type: 'application/json; charset=utf-8'
		headers: {
			'content-type': 'application/json; charset=utf-8'
		}
	}
}

fn not_found_response() VSlimResponse {
	return text_response(404, 'Not Found')
}

fn method_not_allowed_response() VSlimResponse {
	return text_response(405, 'Method Not Allowed')
}

fn internal_error_response() VSlimResponse {
	return text_response(500, 'Internal Server Error')
}
