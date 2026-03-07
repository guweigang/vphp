module main

import vphp

pub type VSlimHandler = fn (VSlimRequest) VSlimResponse
pub type VSlimNext = fn (VSlimRequest) VSlimResponse
pub type VSlimMiddleware = fn (VSlimRequest, VSlimNext) VSlimResponse

pub enum VSlimRouteHandlerType {
	v_native
	php_callable
}

pub struct VSlimRoute {
pub mut:
	method       string
	name         string
	pattern      string
	handler_type VSlimRouteHandlerType
	v_handler    VSlimHandler = unsafe { nil }
	php_handler  vphp.PersistentOwnedZVal
}

pub struct RoutePath {}

pub struct VSlimRuntime {
mut:
	routes      []VSlimRoute
	middlewares []VSlimMiddleware
}

struct RouteHook {
	prefix  string
	handler vphp.PersistentOwnedZVal
}

struct MiddlewareChain {
mut:
	app               &VSlimApp = unsafe { nil }
	path              string
	middlewares       []vphp.RequestOwnedZVal
	route_handler     vphp.RequestOwnedZVal
	index             int
	has_terminal      bool
	terminal_response VSlimResponse
}

@[heap]
@[php_class: 'VSlim\\RouteGroup']
struct RouteGroup {
mut:
	app    &VSlimApp = unsafe { nil }
	prefix string
}

@[heap]
@[php_class: 'VSlim\\Request']
struct VSlimRequest {
pub mut:
	method           string
	raw_path         string
	path             string
	body             string
	query_string     string
	scheme           string
	host             string
	port             string
	protocol_version string
	remote_addr      string
mut:
	query          map[string]string
	headers        map[string]string
	cookies        map[string]string
	attributes     map[string]string
	server         map[string]string
	uploaded_files []string
	params         map[string]string
}

@[heap]
@[php_class: 'VSlim\\Response']
struct VSlimResponse {
pub mut:
	status       int
	body         string
	content_type string
mut:
	headers map[string]string
}

@[heap]
@[php_class: 'VSlim\\App']
struct VSlimApp {
mut:
	routes            []VSlimRoute
	php_before_hooks  []vphp.PersistentOwnedZVal
	php_after_hooks   []vphp.PersistentOwnedZVal
	php_middlewares   []vphp.PersistentOwnedZVal
	php_group_before  []RouteHook
	php_group_after   []RouteHook
	php_group_middle  []RouteHook
	not_found_handler vphp.PersistentOwnedZVal
	error_handler     vphp.PersistentOwnedZVal
	container_ref     &VSlimContainer = unsafe { nil }
	base_path         string
	use_demo          bool
}

fn (mut req VSlimRequest) free() {
	unsafe {
		req.method.free()
		req.raw_path.free()
		req.path.free()
		req.body.free()
		req.query_string.free()
		req.scheme.free()
		req.host.free()
		req.port.free()
		req.protocol_version.free()
		req.remote_addr.free()
		req.query.free()
		req.headers.free()
		req.cookies.free()
		req.attributes.free()
		req.server.free()
		req.uploaded_files.free()
		req.params.free()
	}
}

fn (mut res VSlimResponse) free() {
	unsafe {
		res.body.free()
		res.content_type.free()
		res.headers.free()
	}
}
