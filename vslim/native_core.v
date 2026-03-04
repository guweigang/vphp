module main

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

pub fn (mut app SlimApp) put(pattern string, handler SlimHandler) {
	app.routes << SlimRoute{
		method: 'PUT'
		pattern: pattern
		handler: handler
	}
}

pub fn (mut app SlimApp) patch(pattern string, handler SlimHandler) {
	app.routes << SlimRoute{
		method: 'PATCH'
		pattern: pattern
		handler: handler
	}
}

pub fn (mut app SlimApp) delete(pattern string, handler SlimHandler) {
	app.routes << SlimRoute{
		method: 'DELETE'
		pattern: pattern
		handler: handler
	}
}

pub fn (mut app SlimApp) any(pattern string, handler SlimHandler) {
	app.routes << SlimRoute{
		method: '*'
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
		if route.method != '*' && route.method != method {
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
