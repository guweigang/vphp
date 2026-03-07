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

struct AdminErrorResponse {
	error string
}

struct AdminRestartSingleResponse {
	ok     bool
	mode   string
	worker WorkerAdminStatus
}

struct AdminRestartAllResponse {
	ok        bool
	mode      string
	restarted int
	force     bool
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

fn admin_parse_boolish(raw string) bool {
	return raw.trim_space().to_lower() in ['1', 'true', 'yes', 'on']
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
		ctx.set_custom_header('x-vhttpd-trace-id', trace_id) or {}
		ctx.res.set_status(http.status_from_int(403))
		return ctx.text('Forbidden')
	}
	body := json.encode(app.shared.worker_admin_snapshot())
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

@['/admin/stats'; get]
pub fn (mut app AdminApp) admin_stats(mut ctx Context) veb.Result {
	path := if ctx.req.url == '' { '/admin/stats' } else { ctx.req.url }
	req_id := resolve_request_id(ctx, path)
	trace_id := resolve_trace_id(ctx, path)
	ctx.set_custom_header('x-vhttpd-trace-id', trace_id) or {}
	ctx.set_content_type('application/json; charset=utf-8')
	if !app.admin_authorized(ctx) {
		ctx.res.set_status(http.status_from_int(403))
		return ctx.text(json.encode(AdminErrorResponse{
			error: 'forbidden'
		}))
	}
	body := json.encode(app.shared.admin_stats_snapshot())
	app.shared.emit('http.request', {
		'method': 'GET'
		'path': '/admin/stats'
		'status': '200'
		'request_id': req_id
		'trace_id': trace_id
		'plane': 'admin'
	})
	return ctx.text(body)
}

@['/admin/workers/restart'; post]
pub fn (mut app AdminApp) admin_restart_worker(mut ctx Context) veb.Result {
	path := if ctx.req.url == '' { '/admin/workers/restart' } else { ctx.req.url }
	req_id := resolve_request_id(ctx, path)
	trace_id := resolve_trace_id(ctx, path)
	ctx.set_custom_header('x-vhttpd-trace-id', trace_id) or {}
	ctx.set_content_type('application/json; charset=utf-8')
	if !app.admin_authorized(ctx) {
		ctx.res.set_status(http.status_from_int(403))
		return ctx.text(json.encode(AdminErrorResponse{
			error: 'forbidden'
		}))
	}
	id_raw := (ctx.query['id'] or { '' }).trim_space()
	if id_raw == '' {
		ctx.res.set_status(http.status_from_int(400))
		return ctx.text(json.encode(AdminErrorResponse{
			error: 'missing worker id, use ?id=<worker_id>'
		}))
	}
	worker_id := id_raw.int()
	status := app.shared.restart_worker_by_id(worker_id) or {
		ctx.res.set_status(http.status_from_int(404))
		return ctx.text(json.encode(AdminErrorResponse{
			error: err.msg()
		}))
	}
	body := json.encode(AdminRestartSingleResponse{
		ok: true
		mode: 'single'
		worker: status
	})
	app.shared.emit('admin.worker.restart', {
		'request_id': req_id
		'trace_id': trace_id
		'mode': 'single'
		'worker_id': '${worker_id}'
	})
	ctx.res.set_status(http.status_from_int(200))
	return ctx.text(body)
}

@['/admin/workers/restart/all'; post]
pub fn (mut app AdminApp) admin_restart_all_workers(mut ctx Context) veb.Result {
	path := if ctx.req.url == '' { '/admin/workers/restart/all' } else { ctx.req.url }
	req_id := resolve_request_id(ctx, path)
	trace_id := resolve_trace_id(ctx, path)
	ctx.set_custom_header('x-vhttpd-trace-id', trace_id) or {}
	ctx.set_content_type('application/json; charset=utf-8')
	if !app.admin_authorized(ctx) {
		ctx.res.set_status(http.status_from_int(403))
		return ctx.text(json.encode(AdminErrorResponse{
			error: 'forbidden'
		}))
	}
	force := admin_parse_boolish(ctx.query['force'] or { 'false' })
	restarted := app.shared.restart_all_workers()
	body := json.encode(AdminRestartAllResponse{
		ok: true
		mode: 'all'
		restarted: restarted
		force: force
	})
	app.shared.emit('admin.worker.restart', {
		'request_id': req_id
		'trace_id': trace_id
		'mode': 'all'
		'restarted': '${restarted}'
	})
	ctx.res.set_status(http.status_from_int(200))
	return ctx.text(body)
}

fn run_admin_server(shared_app &App, host string, port int, token string) {
	mut admin := &AdminApp{
		admin_host: host
		admin_port: port
		admin_token: token
		shared: unsafe { shared_app }
	}
	veb.run_at[AdminApp, Context](mut admin, host: host, port: port, family: .ip, show_startup_message: false) or {
		eprintln('admin server failed: ${err}')
	}
}
