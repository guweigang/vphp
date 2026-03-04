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

struct PhpRoute {
	method  string
	name    string
	pattern string
	handler vphp.ZVal
}

struct PhpGroupHook {
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
@[php_class]
struct VSlimResponse {
pub mut:
	status       int
	body         string
	content_type string
mut:
	headers map[string]string
}

@[heap]
@[php_class]
struct VSlimApp {
mut:
	routes            []PhpRoute
	php_before_hooks  []vphp.ZVal
	php_after_hooks   []vphp.ZVal
	php_group_before  []PhpGroupHook
	php_group_after   []PhpGroupHook
	base_path         string
	use_demo          bool
}
