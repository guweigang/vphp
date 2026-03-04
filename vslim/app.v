module main

import vphp

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

@[heap]
@[php_class]
struct VSlimRequest {
pub mut:
	method string
	raw_path string
	path string
	body string
	query_string string
}

@[php_method]
pub fn (mut r VSlimRequest) construct(method string, raw_path string, body string) &VSlimRequest {
	r.method = method
	r.raw_path = raw_path
	r.path, r.query_string = normalize_request_target(raw_path)
	r.body = body
	return r
}

@[php_method]
pub fn (r &VSlimRequest) str() string {
	return '${r.method} ${r.raw_path}'
}

pub fn (r &VSlimRequest) to_slim_request() SlimRequest {
	return SlimRequest{
		method: r.method
		path: r.path
		params: map[string]string{}
		query: parse_query_string(r.query_string)
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
}

@[php_method]
pub fn (mut r VSlimResponse) construct(status int, body string, content_type string) &VSlimResponse {
	r.status = status
	r.body = body
	r.content_type = content_type
	return r
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
struct VSlimApp {}

pub fn new_vslim_request(method string, raw_path string, body string) &VSlimRequest {
	path, query_string := normalize_request_target(raw_path)
	return &VSlimRequest{
		method: method
		raw_path: raw_path
		path: path
		query_string: query_string
		body: body
	}
}

@[php_method]
pub fn VSlimApp.demo() &VSlimApp {
	return &VSlimApp{}
}

@[php_method]
pub fn (app &VSlimApp) dispatch(method string, raw_path string) &VSlimResponse {
	_ = app
	mut slim := new_slim_demo_app()
	res := slim.dispatch(new_vslim_request(method, raw_path, '').to_slim_request())
	return to_vslim_response(res)
}

@[php_method]
pub fn (app &VSlimApp) dispatch_request(req &VSlimRequest) &VSlimResponse {
	_ = app
	mut slim := new_slim_demo_app()
	res := slim.dispatch(req.to_slim_request())
	return to_vslim_response(res)
}

fn to_vslim_response(res SlimResponse) &VSlimResponse {
	return &VSlimResponse{
		status: res.status
		body: res.body
		content_type: res.headers['content-type'] or { '' }
	}
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
	method := envelope['method'] or { 'GET' }
	raw_path := envelope['path'] or { '/' }
	body := envelope['body'] or { '' }
	path, query := split_path_and_query(raw_path)
	return SlimRequest{
		method: method
		path: path
		params: map[string]string{}
		query: query
		body: body
	}
}

fn dispatch_demo_request(req SlimRequest) SlimResponse {
	mut app := new_slim_demo_app()
	return app.dispatch(req)
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
