module main

import json
import net.http
import net.unix
import os
import sync
import time
import veb

pub struct Context {
	veb.Context
}

pub struct App {
pub:
	event_log string
pub mut:
	worker_socket string
	mu sync.Mutex
}

struct ManagedWorker {
mut:
	proc &os.Process = unsafe { nil }
}

struct WorkerResponse {
	id           string
	status       int
	body         string
	headers       map[string]string
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

fn dispatch_core(method string, path string) (int, string, string) {
	m := method.to_upper()
	p := normalize_path(path)

	if p == '/panic' {
		return 500, 'Internal Server Error', 'text/plain; charset=utf-8'
	}

	if p == '/health' {
		if m == 'GET' {
			return 200, 'OK', 'text/plain; charset=utf-8'
		}
		return 405, 'Method Not Allowed', 'text/plain; charset=utf-8'
	}

	if p.starts_with('/users/') {
		if m != 'GET' {
			return 405, 'Method Not Allowed', 'text/plain; charset=utf-8'
		}
		user_id := p.all_after('/users/')
		return 200, '{"user":"${user_id}"}', 'application/json; charset=utf-8'
	}

	return 404, 'Not Found', 'text/plain; charset=utf-8'
}

fn write_frame(mut conn unix.StreamConn, payload string) ! {
	size := payload.len
	header := [u8((size >> 24) & 0xff), u8((size >> 16) & 0xff), u8((size >> 8) & 0xff), u8(size & 0xff)]
	conn.write_ptr(&header[0], 4)!
	conn.write_string(payload)!
}

fn read_exact(mut conn unix.StreamConn, size int) ![]u8 {
	mut out := []u8{len: size}
	mut read := 0
	for read < size {
		n := conn.read(mut out[read..])!
		if n <= 0 {
			return error('unexpected EOF')
		}
		read += n
	}
	return out
}

fn read_frame(mut conn unix.StreamConn) !string {
	header := read_exact(mut conn, 4)!
	size := (int(header[0]) << 24) | (int(header[1]) << 16) | (int(header[2]) << 8) | int(header[3])
	if size <= 0 || size > 16 * 1024 * 1024 {
		return error('invalid frame size ${size}')
	}
	body := read_exact(mut conn, size)!
	return body.bytestr()
}

fn dispatch_via_worker(socket_path string, method string, path string) !(int, string, string) {
	mut conn := unix.connect_stream(socket_path)!
	defer {
		conn.close() or {}
	}
	normalized_path, query_string := normalize_request_target(path)
	query_json := json.encode(parse_query_string(query_string))
	payload := json.encode({
		'id':          'vhttpd-${time.now().unix_micro()}'
		'method':      method.to_upper()
		'path':        path
		'body':        ''
		'scheme':      'http'
		'host':        ''
		'port':        ''
		'protocol_version': '1.1'
		'remote_addr': ''
		'query_json':  query_json
		'headers_json': '{}'
		'cookies_json': '{}'
		'attributes_json': '{}'
		'server_json': '{}'
		'uploaded_files_json': '[]'
	})
	write_frame(mut conn, payload)!
	resp_raw := read_frame(mut conn)!
	resp := json.decode(WorkerResponse, resp_raw)!
	ctype := resp.headers['content-type'] or { 'text/plain; charset=utf-8' }
	return resp.status, resp.body, ctype
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

fn wait_for_worker(socket_path string, timeout_ms int) ! {
	deadline := time.now().add(time.millisecond * timeout_ms)
	for time.now() < deadline {
		mut conn := unix.connect_stream(socket_path) or {
			time.sleep(100 * time.millisecond)
			continue
		}
		conn.close() or {}
		return
	}
	return error('worker socket not ready: ${socket_path}')
}

fn start_managed_worker(worker_cmd string, worker_socket string, workdir string) !ManagedWorker {
	if worker_cmd == '' {
		return error('empty worker command')
	}
	if worker_socket == '' {
		return error('worker socket is required when autostart is enabled')
	}
	mut proc := os.new_process('/bin/sh')
	proc.set_args(['-lc', worker_cmd])
	proc.set_work_folder(workdir)
	proc.use_pgroup = true
	proc.run()
	wait_for_worker(worker_socket, 5000)!
	return ManagedWorker{
		proc: proc
	}
}

fn (mut w ManagedWorker) stop() {
	if isnil(w.proc) {
		return
	}
	if w.proc.is_alive() {
		w.proc.signal_pgkill()
		w.proc.wait()
	}
	w.proc.close()
}

fn to_http_status(code int) http.Status {
	return match code {
		200 { .ok }
		401 { .unauthorized }
		404 { .not_found }
		405 { .method_not_allowed }
		500 { .internal_server_error }
		else { .ok }
	}
}

fn get_arg(args []string, key string, default_val string) string {
	for i, a in args {
		if a == key && i + 1 < args.len {
			return args[i + 1]
		}
		prefix := '${key}='
		if a.starts_with(prefix) {
			return a.all_after(prefix)
		}
	}
	return default_val
}

fn (mut app App) emit(kind string, fields map[string]string) {
	app.mu.@lock()
	defer {
		app.mu.unlock()
	}
	mut row := map[string]string{}
	row['type'] = kind
	row['ts'] = '${time.now().unix()}'
	for k, v in fields {
		row[k] = v
	}
	mut f := os.open_append(app.event_log) or { return }
	defer {
		f.close()
	}
	f.writeln(json.encode(row)) or {}
}

@[get]
pub fn (mut app App) health(mut ctx Context) veb.Result {
	status, body, _ := dispatch_core('GET', '/health')
	app.emit('http.request', {
		'method': 'GET'
		'path':   '/health'
		'status': '${status}'
	})
	ctx.res.set_status(to_http_status(status))
	return ctx.text(body)
}

@['/dispatch'; get]
pub fn (mut app App) dispatch(mut ctx Context) veb.Result {
	method := ctx.query['method'] or { 'GET' }
	path := ctx.query['path'] or { '/health' }
	status, body, ctype := if app.worker_socket != '' {
		dispatch_via_worker(app.worker_socket, method, path) or {
			500, 'Worker Unavailable', 'text/plain; charset=utf-8'
		}
	} else {
		dispatch_core(method, path)
	}
	app.emit('http.request', {
		'method': method.to_upper()
		'path':   normalize_path(path)
		'status': '${status}'
	})
	ctx.res.set_status(to_http_status(status))
	ctx.set_content_type(ctype)
	return ctx.text(body)
}

fn run_server(args []string) {
	host := get_arg(args, '--host', '127.0.0.1')
	port := get_arg(args, '--port', '18081').int()
	event_log := get_arg(args, '--event-log', '/tmp/vhttpd.events.ndjson')
	pid_file := get_arg(args, '--pid-file', '/tmp/vhttpd.pid')
	worker_socket := get_arg(args, '--worker-socket', '')
	worker_cmd := get_arg(args, '--worker-cmd', '')
	worker_autostart := get_arg(args, '--worker-autostart', '').trim_space() in ['1', 'true', 'yes', 'on']

	os.mkdir_all(os.dir(event_log)) or {}
	os.mkdir_all(os.dir(pid_file)) or {}
	os.write_file(pid_file, '${os.getpid()}') or {}
	mut managed := ManagedWorker{}
	defer {
		managed.stop()
		os.rm(pid_file) or {}
	}

	if worker_autostart {
		managed = start_managed_worker(worker_cmd, worker_socket, os.getwd()) or {
			eprintln('worker start failed: ${err}')
			return
		}
	}

	mut app := &App{
		event_log: event_log
		worker_socket: worker_socket
	}
	app.emit('server.started', {
		'host': host
		'port': '${port}'
		'pid':  '${os.getpid()}'
		'worker_autostart': if worker_autostart { 'true' } else { 'false' }
	})

	veb.run_at[App, Context](mut app, host: host, port: port, family: .ip) or {
		eprintln('server failed: ${err}')
	}
}

fn main() {
	args := os.args[1..]
	run_server(args)
}
