module main

import json
import vphp

#include "php_bridge.h"

pub struct SlimRequest {
pub mut:
	method string
	path   string
	params map[string]string
	query  map[string]string
	body   string
}

pub struct SlimResponse {
pub mut:
	status  int
	body    string
	headers map[string]string
}

pub type SlimHandler = fn (SlimRequest) SlimResponse
pub type SlimNext = fn (SlimRequest) SlimResponse
pub type SlimMiddleware = fn (SlimRequest, SlimNext) SlimResponse

pub struct SlimRoute {
pub:
	method  string
	pattern string
	handler SlimHandler = unsafe { nil }
}

pub struct SlimApp {
mut:
	routes      []SlimRoute
	middlewares []SlimMiddleware
}

struct PhpRoute {
	method  string
	name    string
	pattern string
	handler vphp.ZVal
}

struct PhpGroupMiddleware {
	prefix  string
	handler vphp.ZVal
}

@[heap]
@[php_class]
struct VSlimRouteGroup {
mut:
	app    &VSlimApp = unsafe { nil }
	prefix string
}

@[heap]
@[php_class]
struct VSlimRequest {
pub mut:
	method string
	raw_path string
	path string
	body string
	query_string string
	query_json string
	scheme string
	host string
	port string
	protocol_version string
	remote_addr string
	headers_json string
	cookies_json string
	attributes_json string
	server_json string
	uploaded_files_json string
	params_json string
}

@[php_method]
pub fn (mut r VSlimRequest) construct(method string, raw_path string, body string) &VSlimRequest {
	r.method = method
	r.raw_path = raw_path
	r.path, r.query_string = normalize_request_target(raw_path)
	r.body = body
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

pub fn new_slim_app() SlimApp {
	return SlimApp{}
}

pub fn (mut app SlimApp) use(mw SlimMiddleware) {
	app.middlewares << mw
}

pub fn (mut app SlimApp) get(pattern string, handler SlimHandler) {
	app.routes << SlimRoute{
		method: 'GET'
		pattern: pattern
		handler: handler
	}
}

pub fn (mut app SlimApp) post(pattern string, handler SlimHandler) {
	app.routes << SlimRoute{
		method: 'POST'
		pattern: pattern
		handler: handler
	}
}

pub fn (app SlimApp) dispatch(req SlimRequest) SlimResponse {
	return app.run_middleware(0, req)
}

fn (app SlimApp) run_middleware(index int, req SlimRequest) SlimResponse {
	if index >= app.middlewares.len {
		return app.dispatch_route(req)
	}
	mw := app.middlewares[index]
	next := fn [app, index] (r SlimRequest) SlimResponse {
		return app.run_middleware(index + 1, r)
	}
	return mw(req, next)
}

fn (app SlimApp) dispatch_route(req SlimRequest) SlimResponse {
	method := req.method.to_upper()
	path := normalize_path(req.path)
	mut method_not_allowed := false

	for route in app.routes {
		ok, params := match_route(route.pattern, path)
		if !ok {
			continue
		}
		if route.method != method {
			method_not_allowed = true
			continue
		}
		mut bound := req
		bound.params = params.clone()
		return route.handler(bound)
	}

	if method_not_allowed {
		return method_not_allowed_response()
	}
	return not_found_response()
}

@[heap]
@[php_class]
struct VSlimResponse {
pub mut:
	status       int
	body         string
	content_type string
	headers_json  string
}

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

@[heap]
@[php_class]
struct VSlimApp {
mut:
	routes               []PhpRoute
	php_middlewares      []vphp.ZVal
	php_group_middlewares []PhpGroupMiddleware
	base_path            string
	use_demo             bool
}

pub fn new_vslim_request(method string, raw_path string, body string) &VSlimRequest {
	path, query_string := normalize_request_target(raw_path)
	return &VSlimRequest{
		method: method
		raw_path: raw_path
		path: path
		query_string: query_string
		body: body
		scheme: 'http'
		host: ''
		port: ''
		protocol_version: '1.1'
		remote_addr: ''
		query_json: '{}'
		headers_json: '{}'
		cookies_json: '{}'
		attributes_json: '{}'
		server_json: '{}'
		uploaded_files_json: '[]'
		params_json: '{}'
	}
}

pub fn new_vslim_request_from_envelope(envelope map[string]string) &VSlimRequest {
	method := envelope['method'] or { 'GET' }
	raw_path := envelope['path'] or { '/' }
	body := envelope['body'] or { '' }
	path, query_string := normalize_request_target(raw_path)
	return &VSlimRequest{
		method: method
		raw_path: raw_path
		path: path
		query_string: query_string
		body: body
		scheme: envelope['scheme'] or { 'http' }
		host: envelope['host'] or { '' }
		port: envelope['port'] or { '' }
		protocol_version: envelope['protocol_version'] or { '1.1' }
		remote_addr: envelope['remote_addr'] or { '' }
		query_json: envelope['query_json'] or { '{}' }
		headers_json: envelope['headers_json'] or { '{}' }
		cookies_json: envelope['cookies_json'] or { '{}' }
		attributes_json: envelope['attributes_json'] or { '{}' }
		server_json: envelope['server_json'] or { '{}' }
		uploaded_files_json: envelope['uploaded_files_json'] or { '[]' }
		params_json: envelope['params_json'] or { '{}' }
	}
}

@[php_method]
pub fn VSlimApp.demo() &VSlimApp {
	return &VSlimApp{
		use_demo: true
	}
}

@[php_method]
pub fn (mut app VSlimApp) set_base_path(base_path string) &VSlimApp {
	app.base_path = normalize_base_path(base_path)
	return app
}

@[php_method]
pub fn (app &VSlimApp) group(prefix string) &VSlimRouteGroup {
	return &VSlimRouteGroup{
		app: app
		prefix: normalize_group_prefix(prefix)
	}
}

@[php_method]
pub fn (app &VSlimApp) dispatch(method string, raw_path string) &VSlimResponse {
	req := new_vslim_request(method, raw_path, '')
	return app.dispatch_request(req)
}

@[php_method]
pub fn (app &VSlimApp) dispatch_request(req &VSlimRequest) &VSlimResponse {
	res, params := dispatch_app_request_with_params(app, req)
	unsafe {
		mut writable := &VSlimRequest(req)
		writable.params_json = json.encode(params)
		if writable.attributes_json == '{}' || writable.attributes_json == '' {
			writable.attributes_json = json.encode(params)
		}
	}
	return to_vslim_response(res)
}

@[php_method]
pub fn (mut app VSlimApp) get(pattern string, handler vphp.ZVal) &VSlimApp {
	app.add_php_route('GET', '', pattern, handler)
	return app
}

@[php_method]
pub fn (mut app VSlimApp) post(pattern string, handler vphp.ZVal) &VSlimApp {
	app.add_php_route('POST', '', pattern, handler)
	return app
}

@[php_method]
pub fn (mut app VSlimApp) get_named(name string, pattern string, handler vphp.ZVal) &VSlimApp {
	app.add_php_route('GET', name, pattern, handler)
	return app
}

@[php_method]
pub fn (mut app VSlimApp) post_named(name string, pattern string, handler vphp.ZVal) &VSlimApp {
	app.add_php_route('POST', name, pattern, handler)
	return app
}

@[php_method]
pub fn (mut app VSlimApp) middleware(handler vphp.ZVal) &VSlimApp {
	if handler.is_valid() && handler.is_callable() {
		app.php_middlewares << handler.dup()
	}
	return app
}

@[php_method]
pub fn (group &VSlimRouteGroup) group(prefix string) &VSlimRouteGroup {
	return &VSlimRouteGroup{
		app: group.app
		prefix: join_route_prefix(group.prefix, prefix)
	}
}

@[php_method]
pub fn (group &VSlimRouteGroup) middleware(handler vphp.ZVal) &VSlimRouteGroup {
	if !handler.is_valid() || !handler.is_callable() {
		return group
	}
	unsafe {
		mut app := &VSlimApp(group.app)
		app.php_group_middlewares << PhpGroupMiddleware{
			prefix: normalize_group_prefix(group.prefix)
			handler: handler.dup()
		}
	}
	return group
}

@[php_method]
pub fn (group &VSlimRouteGroup) get(pattern string, handler vphp.ZVal) &VSlimRouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('GET', '', join_route_prefix(group.prefix, pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &VSlimRouteGroup) post(pattern string, handler vphp.ZVal) &VSlimRouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('POST', '', join_route_prefix(group.prefix, pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &VSlimRouteGroup) get_named(name string, pattern string, handler vphp.ZVal) &VSlimRouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('GET', name, join_route_prefix(group.prefix, pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &VSlimRouteGroup) post_named(name string, pattern string, handler vphp.ZVal) &VSlimRouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('POST', name, join_route_prefix(group.prefix, pattern), handler)
	}
	return group
}

@[php_method]
pub fn (app &VSlimApp) url_for(name string, params vphp.ZVal) string {
	return app.url_for_query(name, params, vphp.ZVal.new_null())
}

@[php_method]
pub fn (app &VSlimApp) url_for_query(name string, params vphp.ZVal, query vphp.ZVal) string {
	params_map := zval_to_name_map(params)
	query_map := zval_to_name_map(query)
	for route in app.routes {
		if route.name == name {
			raw := render_route_url(route.pattern, &params_map, &query_map) or { '' }
			return app.apply_base_path(raw)
		}
	}
	return ''
}

@[php_method]
pub fn (app &VSlimApp) url_for_abs(name string, params vphp.ZVal, scheme string, host string) string {
	return app.url_for_query_abs(name, params, vphp.ZVal.new_null(), scheme, host)
}

@[php_method]
pub fn (app &VSlimApp) url_for_query_abs(name string, params vphp.ZVal, query vphp.ZVal, scheme string, host string) string {
	path := app.url_for_query(name, params, query)
	if path == '' {
		return ''
	}
	return join_absolute_url(scheme, host, path)
}

@[php_method]
pub fn (app &VSlimApp) redirect_to(name string, params vphp.ZVal) &VSlimResponse {
	return app.redirect_to_query(name, params, vphp.ZVal.new_null())
}

@[php_method]
pub fn (app &VSlimApp) redirect_to_query(name string, params vphp.ZVal, query vphp.ZVal) &VSlimResponse {
	location := app.url_for_query(name, params, query)
	mut res := &VSlimResponse{}
	res.construct(302, '', 'text/plain; charset=utf-8')
	return res.redirect(location)
}

fn (mut app VSlimApp) add_php_route(method string, name string, pattern string, handler vphp.ZVal) {
	if !handler.is_valid() || !handler.is_callable() {
		return
	}
	app.routes << PhpRoute{
		method: method.to_upper()
		name: name
		pattern: pattern
		handler: handler.dup()
	}
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

fn dispatch_app_request_with_params(app &VSlimApp, req &VSlimRequest) (SlimResponse, map[string]string) {
	if app.routes.len > 0 {
		res, params, ok := dispatch_php_routes_with_params(app, req)
		if ok {
			return res, params
		}
	}
	if app.use_demo {
		return dispatch_demo_request_with_params(req.to_slim_request())
	}
	return not_found_response(), map[string]string{}
}

fn dispatch_php_routes_with_params(app &VSlimApp, req &VSlimRequest) (SlimResponse, map[string]string, bool) {
	method := req.method.to_upper()
	path := normalize_path(req.path)
	mut method_not_allowed := false

	for route in app.routes {
		ok, params := match_route(route.pattern, path)
		if !ok {
			continue
		}
		if route.method != method {
			method_not_allowed = true
			continue
		}
		payload := build_php_request_object(req, params)
		route_mws := matching_group_middlewares(app, path)
		res := dispatch_php_handler_with_middlewares(app, route_mws, payload, route.handler, 0)
		return normalize_php_route_response(res), params, true
	}

	if method_not_allowed {
		return method_not_allowed_response(), map[string]string{}, true
	}
	middleware_res := run_php_middlewares_only(app, matching_group_middlewares(app, path), req)
	if middleware_res.is_valid() && !middleware_res.is_null() && !middleware_res.is_undef() {
		return normalize_php_route_response(middleware_res), map[string]string{}, true
	}
	return SlimResponse{}, map[string]string{}, false
}


fn dispatch_php_handler_with_middlewares(app &VSlimApp, route_middlewares []vphp.ZVal, payload vphp.ZVal, handler vphp.ZVal, index int) vphp.ZVal {
	total := app.php_middlewares.len + route_middlewares.len
	if index >= total {
		if !handler.is_valid() {
			return vphp.ZVal{ raw: unsafe { nil } }
		}
		return handler.call([payload])
	}
	mw := if index < app.php_middlewares.len {
		app.php_middlewares[index]
	} else {
		route_middlewares[index - app.php_middlewares.len]
	}
	res := mw.call([payload])
	if !res.is_valid() || res.is_null() || res.is_undef() {
		return dispatch_php_handler_with_middlewares(app, route_middlewares, payload, handler, index + 1)
	}
	return res
}

fn run_php_middlewares_only(app &VSlimApp, route_middlewares []vphp.ZVal, req &VSlimRequest) vphp.ZVal {
	if app.php_middlewares.len == 0 && route_middlewares.len == 0 {
		return vphp.ZVal{ raw: unsafe { nil } }
	}
	payload := build_php_request_object(req, map[string]string{})
	return dispatch_php_handler_with_middlewares(app, route_middlewares, payload, vphp.ZVal{ raw: unsafe { nil } }, 0)
}

fn matching_group_middlewares(app &VSlimApp, path string) []vphp.ZVal {
	mut out := []vphp.ZVal{}
	for item in app.php_group_middlewares {
		if path_has_prefix(path, item.prefix) {
			out << item.handler
		}
	}
	return out
}

fn path_has_prefix(path string, prefix string) bool {
	if prefix == '' {
		return true
	}
	if path == prefix {
		return true
	}
	return path.starts_with(prefix + '/')
}

fn build_php_request_object(req &VSlimRequest, params map[string]string) vphp.ZVal {
	unsafe {
		mut payload := vphp.ZVal.new_null()
		mut bound := &VSlimRequest{
			method: req.method
			raw_path: req.raw_path
			path: req.path
			body: req.body
			query_string: req.query_string
			query_json: req.query_json
			scheme: req.scheme
			host: req.host
			port: req.port
			protocol_version: req.protocol_version
			remote_addr: req.remote_addr
			headers_json: req.headers_json
			cookies_json: req.cookies_json
			attributes_json: req.attributes_json
			server_json: req.server_json
			uploaded_files_json: req.uploaded_files_json
			params_json: json.encode(params)
		}
		C.vphp_return_obj(payload.raw, bound, C.vslimrequest_ce)
		C.vphp_bind_handlers(C.vphp_get_obj_from_zval(payload.raw), &C.vphp_class_handlers(vslimrequest_handlers()))
		return payload
	}
}

fn normalize_php_route_response(result vphp.ZVal) SlimResponse {
	if !result.is_valid() || result.is_null() || result.is_undef() {
		return text_response(200, '')
	}
	if result.is_object() && result.is_instance_of('VSlimResponse') {
		if resp := result.to_object[VSlimResponse]() {
			return SlimResponse{
				status: resp.status
				body: resp.body
				headers: resp.headers()
			}
		}
	}
	if result.is_string() {
		return text_response(200, result.get_string())
	}
	if result.is_array() {
		mut headers := map[string]string{}
		if h := result.get('headers') {
			headers = h.fold[map[string]string](map[string]string{}, fn (key vphp.ZVal, val vphp.ZVal, mut acc map[string]string) {
				acc[key.to_string()] = val.to_string()
			})
		}
		status := if s := result.get('status') { int(s.to_i64()) } else { 200 }
		body := result.get_or('body', '')
		content_type := result.get_or('content_type', headers['content-type'] or { 'text/plain; charset=utf-8' })
		if 'content-type' !in headers {
			headers['content-type'] = content_type
		}
		return SlimResponse{
			status: status
			body: body
			headers: headers
		}
	}
	return text_response(500, 'Invalid route response')
}

fn normalize_path(path string) string {
	if path.len == 0 {
		return '/'
	}
	if path.starts_with('/') {
		return path
	}
	return '/${path}'
}

fn normalize_group_prefix(prefix string) string {
	if prefix == '' || prefix == '/' {
		return ''
	}
	mut out := normalize_path(prefix)
	if out.len > 1 && out.ends_with('/') {
		out = out[..out.len - 1]
	}
	return out
}

fn normalize_base_path(base_path string) string {
	if base_path == '' || base_path == '/' {
		return ''
	}
	mut out := normalize_path(base_path)
	if out.len > 1 && out.ends_with('/') {
		out = out[..out.len - 1]
	}
	return out
}

fn join_route_prefix(prefix string, pattern string) string {
	base := normalize_group_prefix(prefix)
	mut tail := normalize_path(pattern)
	if base == '' {
		return tail
	}
	if tail == '/' {
		return base
	}
	if tail.starts_with('/') {
		tail = tail[1..]
	}
	return '${base}/${tail}'
}

fn (app &VSlimApp) apply_base_path(path string) string {
	base := normalize_base_path(app.base_path)
	if base == '' || path == '' {
		return path
	}
	if path == '/' {
		return base
	}
	if path.starts_with('/') {
		return base + path
	}
	return '${base}/${path}'
}

fn join_absolute_url(scheme string, host string, path string) string {
	clean_scheme := if scheme == '' { 'http' } else { scheme }
	clean_host := host.trim_space()
	if clean_host == '' {
		return path
	}
	return '${clean_scheme}://${clean_host}${path}'
}

fn render_route_url(pattern string, params &map[string]string, query &map[string]string) ?string {
	p := normalize_path(pattern)
	mut parts := []string{}
	for part in p.trim('/').split('/') {
		if part == '' {
			continue
		}
		if part.starts_with(':') {
			key := part.all_after(':')
			if key !in params {
				return none
			}
			unsafe {
				parts << params[key]
			}
			continue
		}
		parts << part
	}
	mut path := if parts.len == 0 { '/' } else { '/' + parts.join('/') }
	if query.len > 0 {
		path += '?' + encode_query_params(query)
	}
	return path
}

fn encode_query_params(query &map[string]string) string {
	mut keys := query.keys()
	keys.sort()
	mut parts := []string{}
	for key in keys {
		unsafe {
			parts << '${key}=${query[key]}'
		}
	}
	return parts.join('&')
}

fn normalize_request_target(raw_path string) (string, string) {
	path := normalize_path(raw_path)
	if !path.contains('?') {
		return path, ''
	}
	base := normalize_path(path.all_before('?'))
	query := path.all_after('?')
	return base, query
}

fn parse_query_string(query_str string) map[string]string {
	mut out := map[string]string{}
	if query_str == '' {
		return out
	}
	for pair in query_str.split('&') {
		if pair == '' {
			continue
		}
		if pair.contains('=') {
			k := pair.all_before('=')
			v := pair.all_after('=')
			out[k] = v
		} else {
			out[pair] = ''
		}
	}
	return out
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

fn zval_to_name_map(z vphp.ZVal) map[string]string {
	if !z.is_valid() || z.is_null() || z.is_undef() {
		return map[string]string{}
	}
	return z.to_v[map[string]string]() or { map[string]string{} }
}

fn parse_headers_json(headers_json string) map[string]string {
	decoded := parse_name_map_json(headers_json)
	mut out := map[string]string{}
	for key, value in decoded {
		out[normalize_header_name(key)] = value
	}
	return out
}

fn normalize_header_name(name string) string {
	return name.trim_space().to_lower()
}

fn match_route(pattern string, path string) (bool, map[string]string) {
	p := normalize_path(pattern)
	u := normalize_path(path)
	if p == u {
		return true, map[string]string{}
	}

	p_parts := p.trim('/').split('/')
	u_parts := u.trim('/').split('/')
	if p_parts.len != u_parts.len {
		return false, map[string]string{}
	}

	mut params := map[string]string{}
	for i in 0 .. p_parts.len {
		pp := p_parts[i]
		up := u_parts[i]
		if pp.starts_with(':') {
			params[pp.all_after(':')] = up
			continue
		}
		if pp != up {
			return false, map[string]string{}
		}
	}
	return true, params
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

fn with_trace_id(req SlimRequest, next SlimNext) SlimResponse {
	mut out := req
	if out.query['trace_id'] == '' {
		out.query['trace_id'] = 'trace-local-mvp'
	}
	return next(out)
}

fn auth_guard(req SlimRequest, next SlimNext) SlimResponse {
	if req.path == '/private' {
		token := req.query['token'] or { '' }
		if token != 'ok' {
			return text_response(401, 'Unauthorized')
		}
	}
	return next(req)
}

fn health_handler(req SlimRequest) SlimResponse {
	_ = req
	return text_response(200, 'OK')
}

fn user_handler(req SlimRequest) SlimResponse {
	user_id := req.params['id'] or { 'unknown' }
	trace_id := req.query['trace_id'] or { '' }
	return json_response(200, '{"user":"${user_id}","trace":"${trace_id}"}')
}

fn private_handler(req SlimRequest) SlimResponse {
	_ = req
	return text_response(200, 'secret')
}

fn panic_handler(req SlimRequest) SlimResponse {
	_ = req
	return internal_error_response()
}

fn meta_handler(req SlimRequest) SlimResponse {
	trace_id := req.query['trace_id'] or { '' }
	return json_response(200, '{"runtime":"vslim","bridge":"vphp","server":"vhttpd","trace":"${trace_id}"}')
}

fn split_path_and_query(raw_path string) (string, map[string]string) {
	path, query_str := normalize_request_target(raw_path)
	return path, parse_query_string(query_str)
}

fn new_slim_demo_app() SlimApp {
	mut app := new_slim_app()
	app.use(with_trace_id)
	app.use(auth_guard)
	app.get('/health', health_handler)
	app.get('/users/:id', user_handler)
	app.get('/private', private_handler)
	app.get('/panic', panic_handler)
	app.get('/meta', meta_handler)
	return app
}

fn request_from_envelope(envelope map[string]string) SlimRequest {
	return new_vslim_request_from_envelope(envelope).to_slim_request()
}

fn dispatch_demo_request(req SlimRequest) SlimResponse {
	mut app := new_slim_demo_app()
	return app.dispatch(req)
}

fn dispatch_demo_request_with_params(req SlimRequest) (SlimResponse, map[string]string) {
	mut app := new_slim_demo_app()
	method := req.method.to_upper()
	path := normalize_path(req.path)
	mut method_not_allowed := false
	for route in app.routes {
		ok, params := match_route(route.pattern, path)
		if !ok {
			continue
		}
		if route.method != method {
			method_not_allowed = true
			continue
		}
		mut bound := req
		bound.params = params.clone()
		return app.run_middleware(0, bound), params
	}
	if method_not_allowed {
		return method_not_allowed_response(), map[string]string{}
	}
	return not_found_response(), map[string]string{}
}

@[php_function]
fn vslim_handle_request(ctx vphp.Context) {
	mut res := SlimResponse{}
	if ctx.num_args() == 1 {
		envelope := ctx.arg[map[string]string](0)
		res = dispatch_demo_request(request_from_envelope(envelope))
	} else {
		method := ctx.arg[string](0)
		raw_path := ctx.arg[string](1)
		body := if ctx.num_args() > 2 { ctx.arg[string](2) } else { '' }
		res = dispatch_demo_request(new_vslim_request(method, raw_path, body).to_slim_request())
	}

	ctx.return_map({
		'status': '${res.status}'
		'body': res.body
		'content_type': res.headers['content-type'] or { '' }
	})
}

@[php_function]
fn vslim_demo_dispatch(ctx vphp.Context) {
	vslim_handle_request(ctx)
}
