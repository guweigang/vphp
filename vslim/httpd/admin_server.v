module main

import json
import net.http
import veb

pub struct AdminApp {
	veb.Middleware[Context]
pub:
	admin_host  string
	admin_port  int
	admin_token string
pub mut:
	shared &App = unsafe { nil }
}

fn (app AdminApp) admin_authorized(ctx Context) bool {
	if app.admin_token == '' {
		return true
	}
	headers := header_map_from_request(ctx.req)
	mut token := headers['x-vhttpd-admin-token']
	if token == '' {
		token = ctx.query['admin_token'] or { '' }
	}
	return token == app.admin_token
}

@[get]
pub fn (mut app AdminApp) health(mut ctx Context) veb.Result {
	ctx.res.set_status(.ok)
	return ctx.text('OK')
}

@['/admin/workers'; get]
pub fn (mut app AdminApp) admin_workers(mut ctx Context) veb.Result {
	path := if ctx.req.url == '' { '/admin/workers' } else { ctx.req.url }
	req_id := resolve_request_id(ctx, path)
	trace_id := resolve_trace_id(ctx, path)
	if !app.admin_authorized(ctx) {
		ctx.set_custom_header('x-request-id', req_id) or {}
		ctx.set_custom_header('x-vhttpd-trace-id', trace_id) or {}
		ctx.res.set_status(http.status_from_int(403))
		return ctx.text('Forbidden')
	}
	body := json.encode(app.shared.worker_admin_snapshot())
	ctx.set_custom_header('x-request-id', req_id) or {}
	ctx.set_custom_header('x-vhttpd-trace-id', trace_id) or {}
	ctx.set_content_type('application/json; charset=utf-8')
	app.shared.emit('http.request', {
		'method': 'GET'
		'path': '/admin/workers'
		'status': '200'
		'request_id': req_id
		'trace_id': trace_id
		'plane': 'admin'
	})
	return ctx.text(body)
}

fn run_admin_server(shared_app &App, host string, port int, token string) {
	mut admin := &AdminApp{
		admin_host: host
		admin_port: port
		admin_token: token
		shared: unsafe { shared_app }
	}
	veb.run_at[AdminApp, Context](mut admin, host: host, port: port, family: .ip) or {
		eprintln('admin server failed: ${err}')
	}
}
