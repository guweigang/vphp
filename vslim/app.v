module main

import vphp

pub struct RouteRequest {
pub mut:
	method string
	path   string
	params map[string]string
	query  map[string]string
	body   string
}

pub struct RouteResponse {
pub mut:
	status       int
	body         string
	content_type string
}

pub type RouteHandler = fn (RouteRequest) RouteResponse

pub struct Route {
pub:
	method  string
	pattern string
	handler RouteHandler = unsafe { nil }
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
		'status':       '${r.status}'
		'body':         r.body
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

@[php_method]
pub fn VSlimApp.demo() &VSlimApp {
	return &VSlimApp{}
}

@[php_method]
pub fn (app &VSlimApp) dispatch(method string, raw_path string) &VSlimResponse {
	_ = app
	path, query := split_path_and_query(raw_path)
	res := demo_dispatch(RouteRequest{
		method: method
		path: path
		params: map[string]string{}
		query: query
		body: ''
	})
	return &VSlimResponse{
		status: res.status
		body: res.body
		content_type: res.content_type
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

fn split_path_and_query(raw_path string) (string, map[string]string) {
	path := normalize_path(raw_path)
	if !path.contains('?') {
		return path, map[string]string{}
	}
	base := path.all_before('?')
	query_str := path.all_after('?')
	mut out := map[string]string{}
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
	return normalize_path(base), out
}

fn text_response(status int, body string) RouteResponse {
	return RouteResponse{
		status: status
		body: body
		content_type: 'text/plain; charset=utf-8'
	}
}

fn json_response(status int, json_body string) RouteResponse {
	return RouteResponse{
		status: status
		body: json_body
		content_type: 'application/json; charset=utf-8'
	}
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

fn demo_routes() []Route {
	return [
		Route{
			method: 'GET'
			pattern: '/health'
			handler: fn (_ RouteRequest) RouteResponse {
				return text_response(200, 'OK')
			}
		},
		Route{
			method: 'GET'
			pattern: '/hello/:name'
			handler: fn (req RouteRequest) RouteResponse {
				name := req.params['name'] or { 'world' }
				return text_response(200, 'Hello, ${name}')
			}
		},
		Route{
			method: 'GET'
			pattern: '/meta'
			handler: fn (_ RouteRequest) RouteResponse {
				return json_response(200, '{"runtime":"vslim","bridge":"vphp","server":"vhttpd"}')
			}
		},
	]
}

fn demo_dispatch(req RouteRequest) RouteResponse {
	method := req.method.to_upper()
	path := normalize_path(req.path)
	mut method_not_allowed := false
	for route in demo_routes() {
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
		return text_response(405, 'Method Not Allowed')
	}
	return text_response(404, 'Not Found')
}

@[php_function]
fn vslim_handle_request(ctx vphp.Context) {
	method := ctx.arg[string](0)
	raw_path := ctx.arg[string](1)
	app := VSlimApp.demo()
	res := app.dispatch(method, raw_path)
	ctx.return_map(res.as_array())
}

@[php_function]
fn vslim_demo_dispatch(ctx vphp.Context) {
	vslim_handle_request(ctx)
}
