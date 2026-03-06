module main

import vphp

#include "php_bridge.h"

__global (
	active_middleware_chain &MiddlewareChain
)

@[php_method]
pub fn VSlimApp.demo() &VSlimApp {
	return &VSlimApp{
		not_found_handler: vphp.ZVal.new_null()
		error_handler: vphp.ZVal.new_null()
		use_demo: true
	}
}

@[php_method]
pub fn (mut app VSlimApp) set_base_path(base_path string) &VSlimApp {
	app.base_path = RoutePath.normalize_base_path(base_path)
	return app
}

@[php_method]
pub fn (app &VSlimApp) has_container() bool {
	return app.container_ref != unsafe { nil }
}

@[php_method]
pub fn (mut app VSlimApp) set_container(container &VSlimContainer) &VSlimApp {
	app.container_ref = container
	return app
}

@[php_method]
pub fn (mut app VSlimApp) container() &VSlimContainer {
	if app.container_ref == unsafe { nil } {
		mut created := &VSlimContainer{}
		created.construct()
		app.container_ref = created
	}
	return app.container_ref
}

@[php_method]
pub fn (app &VSlimApp) group(prefix string) &RouteGroup {
	return &RouteGroup{
		app: app
		prefix: RoutePath.normalize_group_prefix(prefix)
	}
}

@[php_method]
pub fn (app &VSlimApp) dispatch(method string, raw_path string) &VSlimResponse {
	return app.dispatch_body(method, raw_path, '')
}

@[php_method]
pub fn (app &VSlimApp) dispatch_body(method string, raw_path string, body string) &VSlimResponse {
	req := new_vslim_request(method, raw_path, body)
	return app.dispatch_request(req)
}

@[php_method]
pub fn (app &VSlimApp) dispatch_request(req &VSlimRequest) &VSlimResponse {
	mut res, params := dispatch_app_request_with_params(app, req)
	if resolve_effective_method(req) == 'HEAD' {
		res.body = ''
	}
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
pub fn (mut app VSlimApp) head(pattern string, handler vphp.ZVal) &VSlimApp {
	app.add_php_route('HEAD', '', pattern, handler)
	return app
}

@[php_method]
pub fn (mut app VSlimApp) options(pattern string, handler vphp.ZVal) &VSlimApp {
	app.add_php_route('OPTIONS', '', pattern, handler)
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
pub fn (mut app VSlimApp) map(methods vphp.ZVal, pattern string, handler vphp.ZVal) &VSlimApp {
	for method in normalize_methods(methods) {
		app.add_php_route(method, '', pattern, handler)
	}
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
pub fn (mut app VSlimApp) head_named(name string, pattern string, handler vphp.ZVal) &VSlimApp {
	app.add_php_route('HEAD', name, pattern, handler)
	return app
}

@[php_method]
pub fn (mut app VSlimApp) options_named(name string, pattern string, handler vphp.ZVal) &VSlimApp {
	app.add_php_route('OPTIONS', name, pattern, handler)
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
pub fn (mut app VSlimApp) map_named(methods vphp.ZVal, name string, pattern string, handler vphp.ZVal) &VSlimApp {
	for method in normalize_methods(methods) {
		app.add_php_route(method, name, pattern, handler)
	}
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
pub fn (mut app VSlimApp) set_not_found_handler(handler vphp.ZVal) &VSlimApp {
	if !handler.is_valid() || !handler.is_callable() {
		vphp.throw_exception_class('InvalidArgumentException', 'not_found handler must be callable', 0)
		return app
	}
	app.not_found_handler = handler.dup()
	return app
}

@[php_method]
pub fn (mut app VSlimApp) not_found(handler vphp.ZVal) &VSlimApp {
	return app.set_not_found_handler(handler)
}

@[php_method]
pub fn (mut app VSlimApp) set_error_handler(handler vphp.ZVal) &VSlimApp {
	if !handler.is_valid() || !handler.is_callable() {
		vphp.throw_exception_class('InvalidArgumentException', 'error handler must be callable', 0)
		return app
	}
	app.error_handler = handler.dup()
	return app
}

@[php_method]
pub fn (mut app VSlimApp) error(handler vphp.ZVal) &VSlimApp {
	return app.set_error_handler(handler)
}

@[php_method]
pub fn (group &RouteGroup) group(prefix string) &RouteGroup {
	return &RouteGroup{
		app: group.app
		prefix: RoutePath.prefixed_pattern(group.prefix, prefix)
	}
}

@[php_method]
pub fn (group &RouteGroup) middleware(handler vphp.ZVal) &RouteGroup {
	if !handler.is_valid() || !handler.is_callable() {
		return group
	}
	unsafe {
		mut app := &VSlimApp(group.app)
		app.php_group_middle << RouteHook{
			prefix: group.normalized_prefix()
			handler: handler.dup()
		}
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) before(handler vphp.ZVal) &RouteGroup {
	if !handler.is_valid() || !handler.is_callable() {
		return group
	}
	unsafe {
		mut app := &VSlimApp(group.app)
		app.php_group_before << RouteHook{
			prefix: group.normalized_prefix()
			handler: handler.dup()
		}
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) after(handler vphp.ZVal) &RouteGroup {
	if !handler.is_valid() || !handler.is_callable() {
		return group
	}
	unsafe {
		mut app := &VSlimApp(group.app)
		app.php_group_after << RouteHook{
			prefix: group.normalized_prefix()
			handler: handler.dup()
		}
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) get(pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('GET', '', group.prefixed_pattern(pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) post(pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('POST', '', group.prefixed_pattern(pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) put(pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('PUT', '', group.prefixed_pattern(pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) head(pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('HEAD', '', group.prefixed_pattern(pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) options(pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('OPTIONS', '', group.prefixed_pattern(pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) patch(pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('PATCH', '', group.prefixed_pattern(pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) delete(pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('DELETE', '', group.prefixed_pattern(pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) any(pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('*', '', group.prefixed_pattern(pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) map(methods vphp.ZVal, pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		for method in normalize_methods(methods) {
			app.add_php_route(method, '', group.prefixed_pattern(pattern), handler)
		}
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) get_named(name string, pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('GET', name, group.prefixed_pattern(pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) post_named(name string, pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('POST', name, group.prefixed_pattern(pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) put_named(name string, pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('PUT', name, group.prefixed_pattern(pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) head_named(name string, pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('HEAD', name, group.prefixed_pattern(pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) options_named(name string, pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('OPTIONS', name, group.prefixed_pattern(pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) patch_named(name string, pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('PATCH', name, group.prefixed_pattern(pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) delete_named(name string, pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('DELETE', name, group.prefixed_pattern(pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) any_named(name string, pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		app.add_php_route('*', name, group.prefixed_pattern(pattern), handler)
	}
	return group
}

@[php_method]
pub fn (group &RouteGroup) map_named(methods vphp.ZVal, name string, pattern string, handler vphp.ZVal) &RouteGroup {
	unsafe {
		mut app := &VSlimApp(group.app)
		for method in normalize_methods(methods) {
			app.add_php_route(method, name, group.prefixed_pattern(pattern), handler)
		}
	}
	return group
}

@[php_method]
pub fn (app &VSlimApp) url_for(name string, params vphp.ZVal) string {
	return app.url_for_query(name, params, vphp.ZVal.new_null())
}

@[php_method]
pub fn (app &VSlimApp) url_for_query(name string, params vphp.ZVal, query vphp.ZVal) string {
	params_map := params.to_string_map()
	query_map := query.to_string_map()
	for route in app.routes {
		if route.name == name {
			raw := app.render_route_url(route.pattern, &params_map, &query_map) or { '' }
			return RoutePath.apply_base_path(app.base_path, raw)
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
	return RoutePath.absolute_url(scheme, host, path)
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

@[php_method]
pub fn (app &VSlimApp) route_count() int {
	return app.routes.len
}

@[php_method]
pub fn (app &VSlimApp) route_names() []string {
	mut out := []string{}
	for route in app.routes {
		if route.name == '' {
			continue
		}
		if route.name !in out {
			out << route.name
		}
	}
	return out
}

@[php_method]
pub fn (app &VSlimApp) has_route_name(name string) bool {
	for route in app.routes {
		if route.name == name {
			return true
		}
	}
	return false
}

@[php_method]
pub fn (app &VSlimApp) allowed_methods_for(raw_path string) []string {
	path := RoutePath.normalize(raw_path)
	mut allowed := []string{}
	for route in app.routes {
		ok, _ := route.matches(path)
		if !ok {
			continue
		}
		allowed = collect_allowed_methods(allowed, route.method)
	}
	if allowed.len > 0 && 'OPTIONS' !in allowed {
		allowed << 'OPTIONS'
	}
	return allowed
}

fn (mut app VSlimApp) add_php_route(method string, name string, pattern string, handler vphp.ZVal) {
	if !is_supported_route_handler(handler) {
		return
	}
	app.routes << VSlimRoute{
		method: method.to_upper()
		name: name
		pattern: pattern
		handler_type: .php_callable
		php_handler: handler.dup()
	}
}

fn dispatch_app_request_with_params(app &VSlimApp, req &VSlimRequest) (VSlimResponse, map[string]string) {
	if app.routes.len > 0 {
		res, params, ok := dispatch_php_routes_with_params(app, req)
		if ok {
			return res, params
		}
	}
	if app.use_demo {
		return dispatch_demo_request_with_params(req.to_vslim_request())
	}
	return run_not_found(app, req), map[string]string{}
}

fn dispatch_php_routes_with_params(app &VSlimApp, req &VSlimRequest) (VSlimResponse, map[string]string, bool) {
	method := resolve_effective_method(req)
	path := RoutePath.normalize(req.path)
	mut method_not_allowed := false
	mut allowed_methods := []string{}
	dispatch_req := request_with_method(req, method)

	for route in app.routes {
		if route.handler_type != .php_callable {
			continue
		}
		ok, params := route.matches(path)
		if !ok {
			continue
		}
		allowed_methods = collect_allowed_methods(allowed_methods, route.method)
		if route.method != '*' && route.method != method && !(method == 'HEAD' && route.method == 'GET') {
			method_not_allowed = true
			continue
		}
		payload := build_php_request_object(&dispatch_req, params)
		route_before := matching_group_before_hooks(app, path)
		before_res := run_php_before_hooks(app, route_before, payload)
		if before_res.is_valid() && !before_res.is_null() && !before_res.is_undef() {
			res := normalize_or_handle_error(app, payload, before_res, 500, 'Invalid route response')
			return apply_php_after_hooks(app, path, payload, res), params, true
		}
		route_middle := matching_group_middle_hooks(app, path)
		raw_res := dispatch_php_middleware_chain(app, path, payload, route_middle, route.php_handler) or {
			msg := if err.msg() == '' { 'Route handler is not callable' } else { err.msg() }
			res := run_error_handler(app, payload, 500, msg) or {
				text_response(500, msg)
			}
			return apply_php_after_hooks(app, path, payload, res), params, true
		}
		res := normalize_or_handle_error(app, payload, raw_res, 500, 'Invalid route response')
		return apply_php_after_hooks(app, path, payload, res), params, true
	}

	if method == 'OPTIONS' && allowed_methods.len > 0 {
		mut allow := allowed_methods.clone()
		if 'OPTIONS' !in allow {
			allow << 'OPTIONS'
		}
		payload := build_php_request_object(&dispatch_req, map[string]string{})
		mut res := VSlimResponse{
			status: 204
			body: ''
			content_type: 'text/plain; charset=utf-8'
			headers: {
				'content-type': 'text/plain; charset=utf-8'
				'allow': allow.join(', ')
			}
		}
		res = apply_php_after_hooks(app, path, payload, res)
		return res, map[string]string{}, true
	}

	if method_not_allowed {
		payload := build_php_request_object(&dispatch_req, map[string]string{})
		mut res := run_error_handler(app, payload, 405, 'Method not allowed') or { method_not_allowed_response() }
		if allowed_methods.len > 0 && 'allow' !in res.headers {
			res.headers['allow'] = allowed_methods.join(', ')
		}
		return apply_php_after_hooks(app, path, payload, res), map[string]string{}, true
	}
	payload := build_php_request_object(&dispatch_req, map[string]string{})
	before_res := run_php_before_hooks(app, matching_group_before_hooks(app, path), payload)
	if before_res.is_valid() && !before_res.is_null() && !before_res.is_undef() {
		res := normalize_or_handle_error(app, payload, before_res, 500, 'Invalid route response')
		return apply_php_after_hooks(app, path, payload, res), map[string]string{}, true
	}
	route_middle := matching_group_middle_hooks(app, path)
	if app.php_middlewares.len > 0 || route_middle.len > 0 {
		terminal := run_not_found_core(app, payload)
		raw_res := dispatch_php_middleware_chain_terminal(app, path, payload, route_middle, terminal) or {
			msg := if err.msg() == '' { 'Route handler is not callable' } else { err.msg() }
			res := run_error_handler(app, payload, 500, msg) or {
				text_response(500, msg)
			}
			return apply_php_after_hooks(app, path, payload, res), map[string]string{}, true
		}
		res := normalize_or_handle_error(app, payload, raw_res, 500, 'Invalid route response')
		return apply_php_after_hooks(app, path, payload, res), map[string]string{}, true
	}
	return VSlimResponse{}, map[string]string{}, false
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

fn matching_group_middle_hooks(app &VSlimApp, path string) []vphp.ZVal {
	mut out := []vphp.ZVal{}
	for item in app.php_group_middle {
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
			C.vphp_return_obj(payload.raw, bound, C.vslim__request_ce)
		C.vphp_bind_handlers(C.vphp_get_obj_from_zval(payload.raw), &C.vphp_class_handlers(vslimrequest_handlers()))
		return payload
	}
}

fn build_php_response_object(res VSlimResponse) vphp.ZVal {
	unsafe {
		mut payload := vphp.ZVal.new_null()
		bound := to_vslim_response(res)
			C.vphp_return_obj(payload.raw, bound, C.vslim__response_ce)
		C.vphp_bind_handlers(C.vphp_get_obj_from_zval(payload.raw), &C.vphp_class_handlers(vslimresponse_handlers()))
		return payload
	}
}

fn dispatch_php_middleware_chain(app &VSlimApp, path string, payload vphp.ZVal, route_middle []vphp.ZVal, route_handler vphp.ZVal) !vphp.ZVal {
	return dispatch_php_middleware_chain_with_terminal(app, path, payload, route_middle, route_handler, VSlimResponse{}, false)
}

fn dispatch_php_middleware_chain_terminal(app &VSlimApp, path string, payload vphp.ZVal, route_middle []vphp.ZVal, terminal VSlimResponse) !vphp.ZVal {
	return dispatch_php_middleware_chain_with_terminal(app, path, payload, route_middle, vphp.ZVal.new_null(), terminal, true)
}

fn dispatch_php_middleware_chain_with_terminal(app &VSlimApp, path string, payload vphp.ZVal, route_middle []vphp.ZVal, route_handler vphp.ZVal, terminal VSlimResponse, has_terminal bool) !vphp.ZVal {
	if app.php_middlewares.len == 0 && route_middle.len == 0 {
		if has_terminal {
			return build_php_response_object(terminal)
		}
		return dispatch_route_handler(app, route_handler, payload)
	}
	mut middlewares := []vphp.ZVal{}
	for hook in app.php_middlewares {
		middlewares << hook
	}
	for hook in route_middle {
		middlewares << hook
	}
	mut chain := &MiddlewareChain{
		app: app
		path: path
		middlewares: middlewares
		route_handler: route_handler
		has_terminal: has_terminal
		terminal_response: terminal
	}
	return chain.dispatch(payload)
}

fn (mut chain MiddlewareChain) dispatch(payload vphp.ZVal) !vphp.ZVal {
	if chain.index >= chain.middlewares.len {
		if chain.has_terminal {
			return build_php_response_object(chain.terminal_response)
		}
		return dispatch_route_handler(chain.app, chain.route_handler, payload)
	}
	mw := chain.middlewares[chain.index]
	chain.index++
	raw := with_active_middleware_chain(chain, fn [payload, mw] () vphp.ZVal {
		return mw.call([payload, vphp.ZVal.new_string('vslim_middleware_next')])
	})
	if !raw.is_valid() || raw.is_null() || raw.is_undef() {
		return error('Middleware must return a response')
	}
	return raw
}

fn with_active_middleware_chain(chain &MiddlewareChain, invoke fn () vphp.ZVal) vphp.ZVal {
	unsafe {
		previous := active_middleware_chain
		active_middleware_chain = chain
		result := invoke()
		active_middleware_chain = previous
		return result
	}
}

fn invoke_active_middleware_next(request_payload vphp.ZVal) vphp.ZVal {
	unsafe {
		mut chain := active_middleware_chain
		if chain == nil {
			return vphp.ZVal.new_null()
		}
		req := request_payload.to_object[VSlimRequest]() or {
			return vphp.ZVal.new_null()
		}
		payload := build_php_request_object(req, req.params.clone())
		raw := chain.dispatch(payload) or {
			msg := if err.msg() == '' { 'Route handler is not callable' } else { err.msg() }
			res := run_error_handler(chain.app, payload, 500, msg) or {
				text_response(500, msg)
			}
			return build_php_response_object(res)
		}
		res := normalize_or_handle_error(chain.app, payload, raw, 500, 'Invalid route response')
		return build_php_response_object(res)
	}
}

fn apply_php_after_hooks(app &VSlimApp, path string, request_payload vphp.ZVal, initial VSlimResponse) VSlimResponse {
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
			current = normalize_or_handle_error(app, request_payload, res, 500, 'Invalid route response')
		}
	}
	return current
}

fn normalize_or_handle_error(app &VSlimApp, request_payload vphp.ZVal, result vphp.ZVal, fallback_status int, fallback_message string) VSlimResponse {
	res, ok := normalize_php_route_response(result)
	if ok {
		return res
	}
	handled := run_error_handler(app, request_payload, fallback_status, fallback_message) or {
		return text_response(fallback_status, fallback_message)
	}
	return handled
}

fn run_not_found(app &VSlimApp, req &VSlimRequest) VSlimResponse {
	payload := build_php_request_object(req, map[string]string{})
	path := RoutePath.normalize(req.path)
	res := run_not_found_core(app, payload)
	return apply_php_after_hooks(app, path, payload, res)
}

fn run_not_found_core(app &VSlimApp, payload vphp.ZVal) VSlimResponse {
	if app.not_found_handler.is_valid() && app.not_found_handler.is_callable() {
		raw := app.not_found_handler.call([payload])
		return normalize_or_handle_error(app, payload, raw, 404, 'Not Found')
	}
	return not_found_response()
}

fn run_error_handler(app &VSlimApp, request_payload vphp.ZVal, status int, message string) ?VSlimResponse {
	if !app.error_handler.is_valid() || !app.error_handler.is_callable() {
		return none
	}
	raw := app.error_handler.call([
		request_payload,
		vphp.ZVal.new_string(message),
		vphp.ZVal.new_int(status),
	])
	res, ok := normalize_php_route_response(raw)
	if !ok {
		return none
	}
	return res
}

fn is_supported_route_handler(handler vphp.ZVal) bool {
	return handler.is_valid() && (handler.is_callable() || handler.is_string() || handler.is_array())
}

fn dispatch_route_handler(app &VSlimApp, handler vphp.ZVal, payload vphp.ZVal) !vphp.ZVal {
	if !handler.is_valid() {
		return error('Invalid route handler')
	}
	if handler.is_callable() {
		return handler.call([payload])
	}
	if handler.is_string() && app.has_container() {
		resolved := resolve_container_service(app, handler.to_string()) or {
			return error('Container service "${handler.to_string()}" not found')
		}
		if resolved.is_callable() {
			return resolved.call([payload])
		}
		if resolved.is_object() && resolved.method_exists('__invoke') {
			return resolved.method('__invoke', [payload])
		}
		return error('Container service "${handler.to_string()}" is not callable')
	}
	if handler.is_array() && app.has_container() {
		parts := handler.to_string_list()
		if parts.len == 1 && parts[0] != '' {
			service := resolve_container_service(app, parts[0]) or {
				return error('Container service "${parts[0]}" not found')
			}
			if service.is_callable() {
				return service.call([payload])
			}
			if service.is_object() && service.method_exists('__invoke') {
				return service.method('__invoke', [payload])
			}
			return error('Container service "${parts[0]}" is not callable')
		}
		if parts.len == 2 && parts[0] != '' {
			service := resolve_container_service(app, parts[0]) or {
				return error('Container service "${parts[0]}" not found')
			}
			method := if parts[1] == '' { '__invoke' } else { parts[1] }
			if service.is_object() && service.method_exists(method) {
				return service.method(method, [payload])
			}
			return error('Container service "${parts[0]}" has no method "${method}"')
		}
		return error('Invalid container array handler')
	}
	return error('Route handler is not callable')
}

fn resolve_container_service(app &VSlimApp, service_id string) !vphp.ZVal {
	if service_id == '' {
		return error('empty service id')
	}
	unsafe {
		mut mutable_app := &VSlimApp(app)
		if mutable_app.container_ref == nil {
			return error('container is not configured')
		}
		mut container := mutable_app.container_ref
		resolved := container.get_entry(service_id) or {
			if !vphp.class_exists(service_id) {
				return error('container service not found')
			}
			created := vphp.php_class(service_id).construct([])
			if !created.is_valid() || !created.is_object() {
				return error('class "${service_id}" could not be instantiated')
			}
			container.set(service_id, created)
			created
		}
		return resolved
	}
}

fn request_with_method(req &VSlimRequest, method string) VSlimRequest {
	return VSlimRequest{
		method: method
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
		params: req.params.clone()
	}
}

fn resolve_effective_method(req &VSlimRequest) string {
	method := req.method.to_upper()
	if method != 'POST' {
		return method
	}
	mut override := req.header('x-http-method-override').trim_space().to_upper()
	if override == '' {
		override = req.query('_method').trim_space().to_upper()
	}
	if override == '' {
		override = parse_body_method_override(req.body)
	}
	allowed := ['PUT', 'PATCH', 'DELETE', 'HEAD', 'OPTIONS']
	if override in allowed {
		return override
	}
	return method
}

fn parse_body_method_override(body string) string {
	if body == '' {
		return ''
	}
	for pair in body.split('&') {
		if !pair.starts_with('_method=') {
			continue
		}
		return pair.all_after('_method=').trim_space().to_upper()
	}
	return ''
}

fn collect_allowed_methods(existing []string, route_method string) []string {
	mut out := existing.clone()
	mut incoming := []string{}
	match route_method {
		'*' {
			incoming = ['GET', 'HEAD', 'POST', 'PUT', 'PATCH', 'DELETE']
		}
		'GET' {
			incoming = ['GET', 'HEAD']
		}
		else {
			incoming = [route_method]
		}
	}
	for method in incoming {
		if method !in out {
			out << method
		}
	}
	return out
}

fn normalize_methods(methods vphp.ZVal) []string {
	mut out := []string{}
	if methods.is_string() {
		raw := methods.to_string().replace('|', ',')
		for part in raw.split(',') {
			method := part.trim_space().to_upper()
			if method == '' {
				continue
			}
			if method == 'ANY' || method == '*' {
				return ['*']
			}
			if method !in out {
				out << method
			}
		}
		return out
	}
	if methods.is_array() {
		for part in methods.to_string_list() {
			method := part.trim_space().to_upper()
			if method == '' {
				continue
			}
			if method == 'ANY' || method == '*' {
				return ['*']
			}
			if method !in out {
				out << method
			}
		}
	}
	return out
}

fn normalize_php_route_response(result vphp.ZVal) (VSlimResponse, bool) {
	if !result.is_valid() || result.is_null() || result.is_undef() {
		return text_response(200, ''), true
	}
	if result.is_object() && (result.is_instance_of('VSlim\\Response') || result.is_instance_of('VSlimResponse')) {
		if resp := result.to_object[VSlimResponse]() {
			return VSlimResponse{
				status: resp.status
				body: resp.body
				content_type: resp.content_type
				headers: resp.headers()
			}, true
		}
	}
	if result.is_string() {
		return text_response(200, result.get_string()), true
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
		return VSlimResponse{
			status: status
			body: body
			content_type: headers['content-type'] or { '' }
			headers: headers
		}, true
	}
	return VSlimResponse{}, false
}
