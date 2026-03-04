module main

import vphp

#include "php_bridge.h"

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
		writable.params = params.clone()
		if writable.attributes.len == 0 {
			writable.attributes = params.clone()
		}
	}
	return to_vslim_response(res)
}

@[php_method]
pub fn (app &VSlimApp) dispatch_envelope(envelope vphp.ZVal) &VSlimResponse {
	req := new_vslim_request_from_zval(envelope)
	return app.dispatch_request(req)
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
pub fn (mut app VSlimApp) put(pattern string, handler vphp.ZVal) &VSlimApp {
	app.add_php_route('PUT', '', pattern, handler)
	return app
}

@[php_method]
pub fn (mut app VSlimApp) patch(pattern string, handler vphp.ZVal) &VSlimApp {
	app.add_php_route('PATCH', '', pattern, handler)
	return app
}

@[php_method]
pub fn (mut app VSlimApp) delete(pattern string, handler vphp.ZVal) &VSlimApp {
	app.add_php_route('DELETE', '', pattern, handler)
	return app
}

@[php_method]
pub fn (mut app VSlimApp) any(pattern string, handler vphp.ZVal) &VSlimApp {
	app.add_php_route('*', '', pattern, handler)
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
pub fn (mut app VSlimApp) put_named(name string, pattern string, handler vphp.ZVal) &VSlimApp {
	app.add_php_route('PUT', name, pattern, handler)
	return app
}

@[php_method]
pub fn (mut app VSlimApp) patch_named(name string, pattern string, handler vphp.ZVal) &VSlimApp {
	app.add_php_route('PATCH', name, pattern, handler)
	return app
}

@[php_method]
pub fn (mut app VSlimApp) delete_named(name string, pattern string, handler vphp.ZVal) &VSlimApp {
	app.add_php_route('DELETE', name, pattern, handler)
	return app
}

@[php_method]
pub fn (mut app VSlimApp) any_named(name string, pattern string, handler vphp.ZVal) &VSlimApp {
	app.add_php_route('*', name, pattern, handler)
	return app
}

@[php_method]
pub fn (mut app VSlimApp) middleware(handler vphp.ZVal) &VSlimApp {
	return app.before(handler)
}

@[php_method]
pub fn (mut app VSlimApp) before(handler vphp.ZVal) &VSlimApp {
	if handler.is_valid() && handler.is_callable() {
		app.php_before_hooks << handler.dup()
	}
	return app
}

@[php_method]
pub fn (mut app VSlimApp) after(handler vphp.ZVal) &VSlimApp {
	if handler.is_valid() && handler.is_callable() {
		app.php_after_hooks << handler.dup()
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
	return group.before(handler)
}

@[php_method]
pub fn (group &VSlimRouteGroup) before(handler vphp.ZVal) &VSlimRouteGroup {
	if !handler.is_valid() || !handler.is_callable() {
		return group
	}
	unsafe {
		mut app := &VSlimApp(group.app)
		app.php_group_before << PhpGroupHook{
			prefix: normalize_group_prefix(group.prefix)
			handler: handler.dup()
		}
	}
	return group
}

@[php_method]
pub fn (group &VSlimRouteGroup) after(handler vphp.ZVal) &VSlimRouteGroup {
	if !handler.is_valid() || !handler.is_callable() {
		return group
	}
	unsafe {
		mut app := &VSlimApp(group.app)
		app.php_group_after << PhpGroupHook{
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
pub fn (group &VSlimRouteGroup) put(pattern string, handler vphp.ZVal) &VSlimRouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('PUT', '', join_route_prefix(group.prefix, pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &VSlimRouteGroup) patch(pattern string, handler vphp.ZVal) &VSlimRouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('PATCH', '', join_route_prefix(group.prefix, pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &VSlimRouteGroup) delete(pattern string, handler vphp.ZVal) &VSlimRouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('DELETE', '', join_route_prefix(group.prefix, pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &VSlimRouteGroup) any(pattern string, handler vphp.ZVal) &VSlimRouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('*', '', join_route_prefix(group.prefix, pattern), handler)
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
pub fn (group &VSlimRouteGroup) put_named(name string, pattern string, handler vphp.ZVal) &VSlimRouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('PUT', name, join_route_prefix(group.prefix, pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &VSlimRouteGroup) patch_named(name string, pattern string, handler vphp.ZVal) &VSlimRouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('PATCH', name, join_route_prefix(group.prefix, pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &VSlimRouteGroup) delete_named(name string, pattern string, handler vphp.ZVal) &VSlimRouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('DELETE', name, join_route_prefix(group.prefix, pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &VSlimRouteGroup) any_named(name string, pattern string, handler vphp.ZVal) &VSlimRouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('*', name, join_route_prefix(group.prefix, pattern), handler)
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
		if route.method != '*' && route.method != method {
			method_not_allowed = true
			continue
		}
		payload := build_php_request_object(req, params)
		route_before := matching_group_before_hooks(app, path)
		before_res := run_php_before_hooks(app, route_before, payload)
		if before_res.is_valid() && !before_res.is_null() && !before_res.is_undef() {
			res := normalize_php_route_response(before_res)
			return apply_php_after_hooks(app, path, payload, res), params, true
		}
		raw_res := route.handler.call([payload])
		res := normalize_php_route_response(raw_res)
		return apply_php_after_hooks(app, path, payload, res), params, true
	}

	if method_not_allowed {
		return method_not_allowed_response(), map[string]string{}, true
	}
	payload := build_php_request_object(req, map[string]string{})
	before_res := run_php_before_hooks(app, matching_group_before_hooks(app, path), payload)
	if before_res.is_valid() && !before_res.is_null() && !before_res.is_undef() {
		res := normalize_php_route_response(before_res)
		return apply_php_after_hooks(app, path, payload, res), map[string]string{}, true
	}
	return SlimResponse{}, map[string]string{}, false
}

fn dispatch_php_before_hooks(app &VSlimApp, route_before []vphp.ZVal, payload vphp.ZVal, index int) vphp.ZVal {
	total := app.php_before_hooks.len + route_before.len
	if index >= total {
		return vphp.ZVal.new_null()
	}
	hook := if index < app.php_before_hooks.len {
		app.php_before_hooks[index]
	} else {
		route_before[index - app.php_before_hooks.len]
	}
	res := hook.call([payload])
	if !res.is_valid() || res.is_null() || res.is_undef() {
		return dispatch_php_before_hooks(app, route_before, payload, index + 1)
	}
	return res
}

fn run_php_before_hooks(app &VSlimApp, route_before []vphp.ZVal, payload vphp.ZVal) vphp.ZVal {
	if app.php_before_hooks.len == 0 && route_before.len == 0 {
		return vphp.ZVal.new_null()
	}
	return dispatch_php_before_hooks(app, route_before, payload, 0)
}

fn matching_group_before_hooks(app &VSlimApp, path string) []vphp.ZVal {
	mut out := []vphp.ZVal{}
	for item in app.php_group_before {
		if path_has_prefix(path, item.prefix) {
			out << item.handler
		}
	}
	return out
}

fn matching_group_after_hooks(app &VSlimApp, path string) []vphp.ZVal {
	mut out := []vphp.ZVal{}
	for item in app.php_group_after {
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
			scheme: req.scheme
			host: req.host
			port: req.port
			protocol_version: req.protocol_version
			remote_addr: req.remote_addr
			query: req.query.clone()
			headers: req.headers.clone()
			cookies: req.cookies.clone()
			attributes: req.attributes.clone()
			server: req.server.clone()
			uploaded_files: req.uploaded_files.clone()
			params: params.clone()
		}
		C.vphp_return_obj(payload.raw, bound, C.vslimrequest_ce)
		C.vphp_bind_handlers(C.vphp_get_obj_from_zval(payload.raw), &C.vphp_class_handlers(vslimrequest_handlers()))
		return payload
	}
}

fn build_php_response_object(res SlimResponse) vphp.ZVal {
	unsafe {
		mut payload := vphp.ZVal.new_null()
		bound := to_vslim_response(res)
		C.vphp_return_obj(payload.raw, bound, C.vslimresponse_ce)
		C.vphp_bind_handlers(C.vphp_get_obj_from_zval(payload.raw), &C.vphp_class_handlers(vslimresponse_handlers()))
		return payload
	}
}

fn apply_php_after_hooks(app &VSlimApp, path string, request_payload vphp.ZVal, initial SlimResponse) SlimResponse {
	if app.php_after_hooks.len == 0 && app.php_group_after.len == 0 {
		return initial
	}
	mut current := initial
	group_after := matching_group_after_hooks(app, path)
	total := app.php_after_hooks.len + group_after.len
	for i in 0 .. total {
		hook := if i < app.php_after_hooks.len {
			app.php_after_hooks[i]
		} else {
			group_after[i - app.php_after_hooks.len]
		}
		response_payload := build_php_response_object(current)
		res := hook.call([request_payload, response_payload])
		if res.is_valid() && !res.is_null() && !res.is_undef() {
			current = normalize_php_route_response(res)
		}
	}
	return current
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
