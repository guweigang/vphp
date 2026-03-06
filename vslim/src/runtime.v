module main

import vphp

pub fn new_slim_app() VSlimRuntime {
	return VSlimRuntime{}
}

pub fn (mut app VSlimRuntime) use(mw VSlimMiddleware) {
	app.middlewares << mw
}

pub fn (mut app VSlimRuntime) get(pattern string, handler VSlimHandler) {
	app.routes << VSlimRoute{
		method: 'GET'
		pattern: pattern
		handler_type: .v_native
		v_handler: handler
		php_handler: vphp.ZVal.new_null()
	}
}

pub fn (mut app VSlimRuntime) post(pattern string, handler VSlimHandler) {
	app.routes << VSlimRoute{
		method: 'POST'
		pattern: pattern
		handler_type: .v_native
		v_handler: handler
		php_handler: vphp.ZVal.new_null()
	}
}

pub fn (mut app VSlimRuntime) put(pattern string, handler VSlimHandler) {
	app.routes << VSlimRoute{
		method: 'PUT'
		pattern: pattern
		handler_type: .v_native
		v_handler: handler
		php_handler: vphp.ZVal.new_null()
	}
}

pub fn (mut app VSlimRuntime) patch(pattern string, handler VSlimHandler) {
	app.routes << VSlimRoute{
		method: 'PATCH'
		pattern: pattern
		handler_type: .v_native
		v_handler: handler
		php_handler: vphp.ZVal.new_null()
	}
}

pub fn (mut app VSlimRuntime) delete(pattern string, handler VSlimHandler) {
	app.routes << VSlimRoute{
		method: 'DELETE'
		pattern: pattern
		handler_type: .v_native
		v_handler: handler
		php_handler: vphp.ZVal.new_null()
	}
}

pub fn (mut app VSlimRuntime) any(pattern string, handler VSlimHandler) {
	app.routes << VSlimRoute{
		method: '*'
		pattern: pattern
		handler_type: .v_native
		v_handler: handler
		php_handler: vphp.ZVal.new_null()
	}
}

pub fn (app VSlimRuntime) dispatch(req VSlimRequest) VSlimResponse {
	return app.run_middleware(0, req)
}

fn (app VSlimRuntime) run_middleware(index int, req VSlimRequest) VSlimResponse {
	if index >= app.middlewares.len {
		return app.dispatch_route(req)
	}
	mw := app.middlewares[index]
	next := fn [app, index] (r VSlimRequest) VSlimResponse {
		return app.run_middleware(index + 1, r)
	}
	return mw(req, next)
}

fn (app VSlimRuntime) dispatch_route(req VSlimRequest) VSlimResponse {
	method := req.method.to_upper()
	path := RoutePath.normalize(req.path)
	mut method_not_allowed := false

	for route in app.routes {
		ok, params := route.matches(path)
		if !ok {
			continue
		}
		if route.method != '*' && route.method != method {
			method_not_allowed = true
			continue
		}
		mut bound := req
		bound.params = params.clone()
		return route.v_handler(bound)
	}

	if method_not_allowed {
		return method_not_allowed_response()
	}
	return not_found_response()
}

fn with_trace_id(req VSlimRequest, next VSlimNext) VSlimResponse {
	mut out := req
	if out.query['trace_id'] == '' {
		out.query['trace_id'] = 'trace-local-mvp'
	}
	return next(out)
}

fn auth_guard(req VSlimRequest, next VSlimNext) VSlimResponse {
	if req.path == '/private' {
		token := req.query['token'] or { '' }
		if token != 'ok' {
			return text_response(401, 'Unauthorized')
		}
	}
	return next(req)
}

fn health_handler(req VSlimRequest) VSlimResponse {
	_ = req
	return text_response(200, 'OK')
}

fn user_handler(req VSlimRequest) VSlimResponse {
	user_id := req.params['id'] or { 'unknown' }
	trace_id := req.query['trace_id'] or { '' }
	return json_response(200, '{"user":"${user_id}","trace":"${trace_id}"}')
}

fn private_handler(req VSlimRequest) VSlimResponse {
	_ = req
	return text_response(200, 'secret')
}

fn panic_handler(req VSlimRequest) VSlimResponse {
	_ = req
	return internal_error_response()
}

fn meta_handler(req VSlimRequest) VSlimResponse {
	trace_id := req.query['trace_id'] or { '' }
	return json_response(200, '{"runtime":"vslim","bridge":"vphp","server":"vhttpd","trace":"${trace_id}"}')
}

fn new_slim_demo_app() VSlimRuntime {
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

fn dispatch_demo_request(req VSlimRequest) VSlimResponse {
	mut app := new_slim_demo_app()
	return app.dispatch(req)
}

fn dispatch_demo_request_with_params(req VSlimRequest) (VSlimResponse, map[string]string) {
	mut app := new_slim_demo_app()
	method := req.method.to_upper()
	path := RoutePath.normalize(req.path)
	mut method_not_allowed := false
	for route in app.routes {
		ok, params := route.matches(path)
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
