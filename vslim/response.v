module main

import json

@[php_method]
pub fn (mut r VSlimResponse) construct(status int, body string, content_type string) &VSlimResponse {
	r.status = status
	r.body = body
	r.content_type = content_type
	r.headers_json = json.encode({
		'content-type': content_type
	})
	return r
}

@[php_method]
pub fn (r &VSlimResponse) header(name string) string {
	headers := r.headers()
	return headers[normalize_header_name(name)] or { '' }
}

@[php_method]
pub fn (r &VSlimResponse) has_header(name string) bool {
	headers := r.headers()
	return normalize_header_name(name) in headers
}

@[php_method]
pub fn (mut r VSlimResponse) set_header(name string, value string) &VSlimResponse {
	mut headers := r.headers()
	headers[normalize_header_name(name)] = value
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
	cookie_path := if path == '' { '/' } else { path }
	header_value := '${name}=${value}; Path=${cookie_path}'
	mut headers := r.headers()
	headers['set-cookie'] = header_value
	apply_response_headers(mut r, headers)
	return r
}

@[php_method]
pub fn (mut r VSlimResponse) delete_cookie(name string) &VSlimResponse {
	header_value := '${name}=; Path=/; Max-Age=0'
	mut headers := r.headers()
	headers['set-cookie'] = header_value
	apply_response_headers(mut r, headers)
	return r
}

@[php_method]
pub fn (mut r VSlimResponse) with_status(status int) &VSlimResponse {
	r.status = status
	return r
}

@[php_method]
pub fn (mut r VSlimResponse) text(body string) &VSlimResponse {
	r.body = body
	r.content_type = 'text/plain; charset=utf-8'
	mut headers := r.headers()
	headers['content-type'] = r.content_type
	apply_response_headers(mut r, headers)
	return r
}

@[php_method]
pub fn (mut r VSlimResponse) json(body string) &VSlimResponse {
	r.body = body
	r.content_type = 'application/json; charset=utf-8'
	mut headers := r.headers()
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
	mut headers := r.headers()
	headers['location'] = location
	if 'content-type' !in headers {
		headers['content-type'] = r.content_type
	}
	apply_response_headers(mut r, headers)
	return r
}

pub fn (r &VSlimResponse) headers() map[string]string {
	return parse_headers_json(r.headers_json)
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

fn to_vslim_response(res SlimResponse) &VSlimResponse {
	headers_json := json.encode(res.headers)
	return &VSlimResponse{
		status: res.status
		body: res.body
		content_type: res.headers['content-type'] or { '' }
		headers_json: headers_json
	}
}

fn apply_response_headers(mut r VSlimResponse, headers map[string]string) {
	r.headers_json = json.encode(headers)
	r.content_type = headers['content-type'] or { r.content_type }
}

fn text_response(status int, body string) SlimResponse {
	return SlimResponse{
		status: status
		body: body
		headers: {
			'content-type': 'text/plain; charset=utf-8'
		}
	}
}

fn json_response(status int, json_body string) SlimResponse {
	return SlimResponse{
		status: status
		body: json_body
		headers: {
			'content-type': 'application/json; charset=utf-8'
		}
	}
}

fn not_found_response() SlimResponse {
	return text_response(404, 'Not Found')
}

fn method_not_allowed_response() SlimResponse {
	return text_response(405, 'Method Not Allowed')
}

fn internal_error_response() SlimResponse {
	return text_response(500, 'Internal Server Error')
}
