module main

import json
import net
import net.http
import net.urllib
import net.unix
import os
import strings
import sync
import time
import veb
import veb.request_id
import veb.sse

pub struct Context {
	veb.Context
	request_id.RequestIdContext
}

pub struct App {
	veb.Middleware[Context]
pub:
	event_log string
pub mut:
	worker_socket          string
	worker_read_timeout_ms int
	mu                     sync.Mutex
}

struct ManagedWorker {
mut:
	proc &os.Process = unsafe { nil }
}

struct WorkerResponse {
	id           string
	status       int
	body         string
	headers      map[string]string
}

struct WorkerStreamFrame {
	mode         string
	event        string
	id           string
	status       int
	stream_type  string @[json: 'stream_type']
	content_type string @[json: 'content_type']
	headers      map[string]string
	data         string
	sse_id       string @[json: 'sse_id']
	sse_event    string @[json: 'sse_event']
	sse_retry    int    @[json: 'sse_retry']
	error        string
	error_class  string @[json: 'error_class']
}

struct WorkerRequestPayload {
	id               string
	method           string
	path             string
	body             string
	scheme           string
	host             string
	port             string
	protocol_version string
	remote_addr      string
	query            map[string]string
	headers          map[string]string
	cookies          map[string]string
	attributes       map[string]string
	server           map[string]string
	uploaded_files   []string
}

fn header_map_from_request(req http.Request) map[string]string {
	mut out := map[string]string{}
	for key in req.header.keys() {
		values := req.header.custom_values(key)
		if values.len == 0 {
			continue
		}
		out[key.to_lower()] = values.join(', ')
	}
	return out
}

fn cookie_map_from_request(req http.Request) map[string]string {
	mut out := map[string]string{}
	for cookie in http.read_cookies(req.header, '') {
		out[cookie.name] = cookie.value
	}
	return out
}

fn server_map_from_request(req http.Request, remote_addr string) map[string]string {
	mut host := req.host
	mut port := ''
	if host == '' {
		host = req.header.get(.host) or { '' }
	}
	if host != '' {
		host, port = urllib.split_host_port(host)
	}
	return {
		'host':        host
		'port':        port
		'remote_addr': remote_addr
		'method':      req.method.str()
		'url':         req.url
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
	size_u32 := (u32(header[0]) << 24) | (u32(header[1]) << 16) | (u32(header[2]) << 8) | u32(header[3])
	size := int(size_u32)
	if size <= 0 || size > 16 * 1024 * 1024 {
		return error('invalid frame size ${size}')
	}
	body := read_exact(mut conn, size)!
	return body.bytestr()
}

fn resolve_trace_id(ctx Context, path string) string {
	_, query_str := normalize_request_target(path)
	query := parse_query_map(query_str)
	if query['trace_id'] != '' {
		return query['trace_id']
	}
	headers := header_map_from_request(ctx.req)
	for key in ['x-trace-id', 'x-request-id'] {
		if headers[key] != '' {
			return headers[key]
		}
	}
	if ctx.request_id != '' {
		return ctx.request_id
	}
	return 'vhttpd-${time.now().unix_micro()}'
}

fn resolve_request_id(ctx Context, path string) string {
	_, query_str := normalize_request_target(path)
	query := parse_query_map(query_str)
	if query['request_id'] != '' {
		return query['request_id']
	}
	if ctx.request_id != '' {
		return ctx.request_id
	}
	headers := header_map_from_request(ctx.req)
	header_rid := headers['x-request-id']
	if header_rid != '' {
		return header_rid
	}
	return 'req-${time.now().unix_micro()}'
}

fn dispatch_via_worker(socket_path string, method string, path string, req http.Request, remote_addr string, trace_id string, req_id string, read_timeout_ms int) !WorkerResponse {
	mut conn := unix.connect_stream(socket_path)!
	if read_timeout_ms > 0 {
		conn.set_read_timeout(time.millisecond * read_timeout_ms)
	}
	defer {
		conn.close() or {}
	}
	normalized_path, query_string := normalize_request_target(path)
	query := parse_query_map(query_string)
	mut headers := header_map_from_request(req)
	if headers['x-request-id'] == '' {
		headers['x-request-id'] = req_id
	}
	cookies := cookie_map_from_request(req)
	server := server_map_from_request(req, remote_addr)
	host := server['host'] or { req.host }
	port := server['port'] or { '' }
	scheme := req.header.get(.x_forwarded_proto) or { 'http' }
	payload := json.encode(WorkerRequestPayload{
		id: trace_id
		method: method.to_upper()
		path: normalized_path
		body: req.data
		scheme: scheme
		host: host
		port: port
		protocol_version: req.version.str().trim_left('HTTP/')
		remote_addr: remote_addr
		query: query
		headers: headers
		cookies: cookies
		attributes: map[string]string{}
		server: server
		uploaded_files: []string{}
	})
	write_frame(mut conn, payload)!
	resp_raw := read_frame(mut conn)!
	resp := json.decode(WorkerResponse, resp_raw)!
	return resp
}

fn encode_worker_request(method string, path string, req http.Request, remote_addr string, trace_id string, req_id string) string {
	normalized_path, query_string := normalize_request_target(path)
	query := parse_query_map(query_string)
	mut headers := header_map_from_request(req)
	if headers['x-request-id'] == '' {
		headers['x-request-id'] = req_id
	}
	cookies := cookie_map_from_request(req)
	server := server_map_from_request(req, remote_addr)
	host := server['host'] or { req.host }
	port := server['port'] or { '' }
	scheme := req.header.get(.x_forwarded_proto) or { 'http' }
	return json.encode(WorkerRequestPayload{
		id: trace_id
		method: method.to_upper()
		path: normalized_path
		body: req.data
		scheme: scheme
		host: host
		port: port
		protocol_version: req.version.str().trim_left('HTTP/')
		remote_addr: remote_addr
		query: query
		headers: headers
		cookies: cookies
		attributes: map[string]string{}
		server: server
		uploaded_files: []string{}
	})
}

fn try_decode_stream_start(raw string) ?WorkerStreamFrame {
	frame := json.decode(WorkerStreamFrame, raw) or { return none }
	if frame.mode == 'stream' && frame.event == 'start' {
		return frame
	}
	return none
}

fn status_reason_phrase(status int) string {
	return match status {
		200 { 'OK' }
		201 { 'Created' }
		202 { 'Accepted' }
		204 { 'No Content' }
		301 { 'Moved Permanently' }
		302 { 'Found' }
		304 { 'Not Modified' }
		400 { 'Bad Request' }
		401 { 'Unauthorized' }
		403 { 'Forbidden' }
		404 { 'Not Found' }
		405 { 'Method Not Allowed' }
		408 { 'Request Timeout' }
		409 { 'Conflict' }
		429 { 'Too Many Requests' }
		500 { 'Internal Server Error' }
		502 { 'Bad Gateway' }
		503 { 'Service Unavailable' }
		504 { 'Gateway Timeout' }
		else { 'OK' }
	}
}

fn write_http_stream_headers(mut ctx Context, status int, content_type string, extra_headers map[string]string, chunked bool) ! {
	mut code := status
	if code <= 0 {
		code = 200
	}
	mut sb := strings.new_builder(512)
	sb.write_string('HTTP/1.1 ${code} ${status_reason_phrase(code)}\r\n')
	sb.write_string('Server: veb\r\n')
	sb.write_string('Connection: close\r\n')
	if chunked {
		sb.write_string('Transfer-Encoding: chunked\r\n')
	}
	if content_type != '' {
		sb.write_string('Content-Type: ${content_type}\r\n')
	}
	for name, value in extra_headers {
		lower := name.to_lower()
		if lower == 'content-type' || lower == 'content-length' || lower == 'transfer-encoding' || lower == 'connection' || lower == 'server' {
			continue
		}
		sb.write_string('${name}: ${value}\r\n')
	}
	sb.write_string('\r\n')
	ctx.conn.write_string(sb.str())!
}

fn write_chunk(mut conn net.TcpConn, data string) ! {
	if data.len == 0 {
		return
	}
	conn.write_string('${data.len:x}\r\n')!
	conn.write_string(data)!
	conn.write_string('\r\n')!
}

fn write_sse_message(mut conn net.TcpConn, frame WorkerStreamFrame) ! {
	mut sb := strings.new_builder(256)
	if frame.sse_id != '' {
		sb.write_string('id: ${frame.sse_id}\n')
	}
	if frame.sse_event != '' {
		sb.write_string('event: ${frame.sse_event}\n')
	}
	if frame.data != '' {
		sb.write_string('data: ${frame.data}\n')
	}
	if frame.sse_retry != 0 {
		sb.write_string('retry: ${frame.sse_retry}\n')
	}
	sb.write_string('\n')
	conn.write_string(sb.str())!
}

fn stream_via_sse(mut app App, mut ctx Context, mut conn unix.StreamConn, start WorkerStreamFrame, method string, path string, req_id string, trace_id string, start_ms i64) veb.Result {
	ctx.takeover_conn()
	mut status := start.status
	if status <= 0 {
		status = 200
	}
	mut headers := start.headers.clone()
	headers['x-request-id'] = req_id
	headers['x-vhttpd-trace-id'] = trace_id
	headers['x-accel-buffering'] = 'no'
	ctype := if start.content_type != '' { start.content_type } else { 'text/event-stream' }
	write_http_stream_headers(mut ctx, status, ctype, headers, false) or {
		return veb.no_result()
	}
	for {
		raw := read_frame(mut conn) or { break }
		frame := json.decode(WorkerStreamFrame, raw) or { continue }
		if frame.mode != 'stream' {
			continue
		}
		if frame.event == 'chunk' {
			if method.to_upper() != 'HEAD' {
				write_sse_message(mut ctx.conn, frame) or { break }
			}
			continue
		}
		if frame.event == 'error' {
			app.emit('http.stream.error', {
				'method': method.to_upper()
				'path': normalize_path(path)
				'request_id': req_id
				'trace_id': trace_id
				'error_class': frame.error_class
				'error': frame.error
			})
			break
		}
		if frame.event == 'end' {
			break
		}
	}
	ctx.conn.close() or {}
	app.emit('http.request', {
		'method': method.to_upper()
		'path': normalize_path(path)
		'status': '${status}'
		'request_id': req_id
		'trace_id': trace_id
		'duration_ms': '${time.now().unix_milli() - start_ms}'
		'response_mode': 'stream'
		'stream_type': 'sse'
	})
	return veb.no_result()
}

fn stream_via_passthrough(mut app App, mut ctx Context, mut conn unix.StreamConn, start WorkerStreamFrame, method string, path string, req_id string, trace_id string, start_ms i64) veb.Result {
	ctx.takeover_conn()
	mut status := start.status
	if status <= 0 {
		status = 200
	}
	mut headers := start.headers.clone()
	headers['x-request-id'] = req_id
	headers['x-vhttpd-trace-id'] = trace_id
	headers['x-vhttpd-stream-mode'] = 'passthrough'
	ctype := if start.content_type != '' { start.content_type } else { 'text/plain; charset=utf-8' }
	write_http_stream_headers(mut ctx, status, ctype, headers, true) or {
		return veb.no_result()
	}
	for {
		raw := read_frame(mut conn) or { break }
		frame := json.decode(WorkerStreamFrame, raw) or { continue }
		if frame.mode != 'stream' {
			continue
		}
		if frame.event == 'chunk' {
			if method.to_upper() != 'HEAD' {
				write_chunk(mut ctx.conn, frame.data) or { break }
			}
			continue
		}
		if frame.event == 'error' {
			app.emit('http.stream.error', {
				'method': method.to_upper()
				'path': normalize_path(path)
				'request_id': req_id
				'trace_id': trace_id
				'error_class': frame.error_class
				'error': frame.error
			})
			break
		}
		if frame.event == 'end' {
			break
		}
	}
	ctx.conn.write_string('0\r\n\r\n') or {}
	ctx.conn.close() or {}
	app.emit('http.request', {
		'method': method.to_upper()
		'path': normalize_path(path)
		'status': '${status}'
		'request_id': req_id
		'trace_id': trace_id
		'duration_ms': '${time.now().unix_milli() - start_ms}'
		'response_mode': 'stream'
		'stream_type': if start.stream_type != '' { start.stream_type } else { 'passthrough' }
	})
	return veb.no_result()
}

fn classify_worker_error(err_msg string) (int, string) {
	msg := err_msg.to_lower()
	if msg.contains('timed out') || msg.contains('timeout') {
		return 504, 'timeout'
	}
	return 502, 'transport_error'
}

fn proxy_worker_response(mut app App, mut ctx Context, method string, path string, body_on_head string) veb.Result {
	start_ms := time.now().unix_milli()
	remote_addr := if isnil(ctx.conn) { '' } else { ctx.conn.peer_ip() or { '' } }
	req_id := resolve_request_id(ctx, path)
	trace_id := resolve_trace_id(ctx, path)
	mut conn := unix.connect_stream(app.worker_socket) or {
		err_msg := err.msg()
		status, error_class := classify_worker_error(err_msg)
		app.emit('http.request', {
			'method': method.to_upper()
			'path':   normalize_path(path)
			'status': '${status}'
			'request_id': req_id
			'trace_id': trace_id
			'duration_ms': '${time.now().unix_milli() - start_ms}'
			'error_class': error_class
			'error': err_msg
		})
		ctx.set_custom_header('x-request-id', req_id) or {}
		ctx.set_custom_header('x-vhttpd-trace-id', trace_id) or {}
		ctx.set_custom_header('x-vhttpd-error-class', error_class) or {}
		ctx.res.set_status(http.status_from_int(status))
		return ctx.text(body_on_head)
	}
	defer {
		conn.close() or {}
	}
	if app.worker_read_timeout_ms > 0 {
		conn.set_read_timeout(time.millisecond * app.worker_read_timeout_ms)
	}
	payload := encode_worker_request(method, path, ctx.req, remote_addr, trace_id, req_id)
	write_frame(mut conn, payload) or {
		err_msg := err.msg()
		status, error_class := classify_worker_error(err_msg)
		ctx.set_custom_header('x-request-id', req_id) or {}
		ctx.set_custom_header('x-vhttpd-trace-id', trace_id) or {}
		ctx.set_custom_header('x-vhttpd-error-class', error_class) or {}
		ctx.res.set_status(http.status_from_int(status))
		return ctx.text(body_on_head)
	}
	first_raw := read_frame(mut conn) or {
		err_msg := err.msg()
		status, error_class := classify_worker_error(err_msg)
		ctx.set_custom_header('x-request-id', req_id) or {}
		ctx.set_custom_header('x-vhttpd-trace-id', trace_id) or {}
		ctx.set_custom_header('x-vhttpd-error-class', error_class) or {}
		ctx.res.set_status(http.status_from_int(status))
		return ctx.text(body_on_head)
	}
	if start := try_decode_stream_start(first_raw) {
		if (start.stream_type == 'sse' || start.content_type.starts_with('text/event-stream')) && method.to_upper() != 'HEAD' {
			return stream_via_sse(mut app, mut ctx, mut conn, start, method, path, req_id,
				trace_id, start_ms)
		}
		return stream_via_passthrough(mut app, mut ctx, mut conn, start, method, path,
			req_id, trace_id, start_ms)
	}
	resp := json.decode(WorkerResponse, first_raw) or {
		ctx.set_custom_header('x-request-id', req_id) or {}
		ctx.set_custom_header('x-vhttpd-trace-id', trace_id) or {}
		ctx.set_custom_header('x-vhttpd-error-class', 'transport_error') or {}
		ctx.res.set_status(http.status_from_int(502))
		return ctx.text(body_on_head)
	}
	app.emit('http.request', {
		'method': method.to_upper()
		'path':   normalize_path(path)
		'status': '${resp.status}'
		'request_id': req_id
		'trace_id': trace_id
		'duration_ms': '${time.now().unix_milli() - start_ms}'
	})
	ctx.set_custom_header('x-request-id', req_id) or {}
	ctx.set_custom_header('x-vhttpd-trace-id', trace_id) or {}
	ctx.res.set_status(http.status_from_int(resp.status))
	apply_worker_headers(mut ctx, resp.headers)
	ctype := resp.headers['content-type'] or { 'text/plain; charset=utf-8' }
	ctx.set_content_type(ctype)
	return ctx.text(if body_on_head == '' && method.to_upper() == 'HEAD' { '' } else { resp.body })
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

fn parse_query_map(query_str string) map[string]string {
	mut out := map[string]string{}
	if query_str == '' {
		return out
	}
	values := urllib.parse_query(query_str) or { return out }
	for key, entries in values.to_map() {
		if entries.len == 0 {
			out[key] = ''
			continue
		}
		out[key] = entries[0]
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

fn apply_worker_headers(mut ctx Context, headers map[string]string) {
	for name, value in headers {
		lower := name.to_lower()
		if lower == 'content-type' || lower == 'content-length' {
			continue
		}
		ctx.set_custom_header(name, value) or {}
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
	req_id := resolve_request_id(ctx, '/health')
	status, body, _ := dispatch_core('GET', '/health')
	ctx.set_custom_header('x-request-id', req_id) or {}
	app.emit('http.request', {
		'method': 'GET'
		'path':   '/health'
		'status': '${status}'
		'request_id': req_id
	})
	ctx.res.set_status(http.status_from_int(status))
	return ctx.text(body)
}

@['/dispatch'; get]
pub fn (mut app App) dispatch(mut ctx Context) veb.Result {
	start_ms := time.now().unix_milli()
	method := ctx.query['method'] or { 'GET' }
	path := ctx.query['path'] or { '/health' }
	req_id := resolve_request_id(ctx, path)
	ctx.set_custom_header('x-request-id', req_id) or {}
	if app.worker_socket != '' {
		return proxy_worker_response(mut app, mut ctx, method, path, 'Bad Gateway')
	}
	mut status := 200
	mut body := ''
	mut ctype := 'text/plain; charset=utf-8'
	status, body, ctype = dispatch_core(method, path)
	app.emit('http.request', {
		'method': method.to_upper()
		'path':   normalize_path(path)
		'status': '${status}'
		'request_id': req_id
		'duration_ms': '${time.now().unix_milli() - start_ms}'
	})
	ctx.res.set_status(http.status_from_int(status))
	ctx.set_content_type(ctype)
	return ctx.text(body)
}

@['/dispatch'; head]
pub fn (mut app App) dispatch_head(mut ctx Context) veb.Result {
	start_ms := time.now().unix_milli()
	method := ctx.query['method'] or { 'GET' }
	path := ctx.query['path'] or { '/health' }
	req_id := resolve_request_id(ctx, path)
	ctx.set_custom_header('x-request-id', req_id) or {}
	if app.worker_socket != '' {
		return proxy_worker_response(mut app, mut ctx, method, path, '')
	}
	mut status := 200
	mut body := ''
	mut ctype := 'text/plain; charset=utf-8'
	status, body, ctype = dispatch_core(method, path)
	app.emit('http.request', {
		'method': method.to_upper()
		'path':   normalize_path(path)
		'status': '${status}'
		'request_id': req_id
		'duration_ms': '${time.now().unix_milli() - start_ms}'
	})
	ctx.res.set_status(http.status_from_int(status))
	ctx.set_content_type(ctype)
	return ctx.text(body)
}

@['/events/stream'; get]
pub fn (mut app App) events_stream(mut ctx Context) veb.Result {
	start_ms := time.now().unix_milli()
	path := if ctx.req.url == '' { '/events/stream' } else { ctx.req.url }
	req_id := resolve_request_id(ctx, path)
	trace_id := resolve_trace_id(ctx, path)
	mut count := (ctx.query['count'] or { '3' }).int()
	if count < 1 {
		count = 1
	}
	if count > 20 {
		count = 20
	}
	mut interval_ms := (ctx.query['interval_ms'] or { '150' }).int()
	if interval_ms < 0 {
		interval_ms = 0
	}
	if interval_ms > 1000 {
		interval_ms = 1000
	}

	ctx.takeover_conn()
	ctx.set_custom_header('x-request-id', req_id) or {}
	ctx.set_custom_header('x-vhttpd-trace-id', trace_id) or {}
	ctx.set_custom_header('x-accel-buffering', 'no') or {}
	mut stream := sse.start_connection(mut ctx.Context)
	stream.send_message(retry: 1000) or {
		return ctx.server_error_with_status(.not_implemented)
	}
	for i in 0 .. count {
		payload := json.encode({
			'request_id': req_id
			'trace_id':   trace_id
			'seq':        '${i + 1}'
			'ts':         '${time.now().unix()}'
		})
		stream.send_message(id: '${req_id}-${i + 1}', event: 'ping', data: payload) or {
			return veb.no_result()
		}
		if i + 1 < count && interval_ms > 0 {
			time.sleep(time.millisecond * interval_ms)
		}
	}
	stream.close()

	app.emit('http.request', {
		'method': 'GET'
		'path': '/events/stream'
		'status': '200'
		'request_id': req_id
		'trace_id': trace_id
		'duration_ms': '${time.now().unix_milli() - start_ms}'
	})
	return veb.no_result()
}

@['/:path...'; get]
pub fn (mut app App) proxy_get(mut ctx Context, path string) veb.Result {
	if app.worker_socket == '' {
		ctx.res.set_status(.not_found)
		return ctx.text('Not Found')
	}
	target := if ctx.req.url == '' { path } else { ctx.req.url }
	return proxy_worker_response(mut app, mut ctx, 'GET', target, '')
}

@['/:path...'; post]
pub fn (mut app App) proxy_post(mut ctx Context, path string) veb.Result {
	if app.worker_socket == '' {
		ctx.res.set_status(.not_found)
		return ctx.text('Not Found')
	}
	target := if ctx.req.url == '' { path } else { ctx.req.url }
	return proxy_worker_response(mut app, mut ctx, 'POST', target, '')
}

@['/:path...'; put]
pub fn (mut app App) proxy_put(mut ctx Context, path string) veb.Result {
	if app.worker_socket == '' {
		ctx.res.set_status(.not_found)
		return ctx.text('Not Found')
	}
	target := if ctx.req.url == '' { path } else { ctx.req.url }
	return proxy_worker_response(mut app, mut ctx, 'PUT', target, '')
}

@['/:path...'; patch]
pub fn (mut app App) proxy_patch(mut ctx Context, path string) veb.Result {
	if app.worker_socket == '' {
		ctx.res.set_status(.not_found)
		return ctx.text('Not Found')
	}
	target := if ctx.req.url == '' { path } else { ctx.req.url }
	return proxy_worker_response(mut app, mut ctx, 'PATCH', target, '')
}

@['/:path...'; delete]
pub fn (mut app App) proxy_delete(mut ctx Context, path string) veb.Result {
	if app.worker_socket == '' {
		ctx.res.set_status(.not_found)
		return ctx.text('Not Found')
	}
	target := if ctx.req.url == '' { path } else { ctx.req.url }
	return proxy_worker_response(mut app, mut ctx, 'DELETE', target, '')
}

@['/:path...'; head]
pub fn (mut app App) proxy_head(mut ctx Context, path string) veb.Result {
	if app.worker_socket == '' {
		ctx.res.set_status(.not_found)
		return ctx.text('')
	}
	target := if ctx.req.url == '' { path } else { ctx.req.url }
	return proxy_worker_response(mut app, mut ctx, 'HEAD', target, '')
}

fn run_server(args []string) {
	host := get_arg(args, '--host', '127.0.0.1')
	port := get_arg(args, '--port', '18081').int()
	event_log := get_arg(args, '--event-log', '/tmp/vhttpd.events.ndjson')
	pid_file := get_arg(args, '--pid-file', '/tmp/vhttpd.pid')
	worker_socket := get_arg(args, '--worker-socket', '')
	worker_read_timeout_ms := get_arg(args, '--worker-read-timeout-ms', '3000').int()
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
		worker_read_timeout_ms: worker_read_timeout_ms
	}
	app.use(request_id.middleware[Context](request_id.Config{
		header: 'X-Request-ID'
		generator: fn () string {
			return 'req-${time.now().unix_micro()}'
		}
	}))
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
