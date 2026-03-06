module main

import net.unix
import os
import time

struct ManagedWorker {
	id          int
	socket_path string
	worker_cmd  string
mut:
	proc          &os.Process = unsafe { nil }
	restart_count int
	last_exit_ts  i64
	next_retry_ts i64
	served_requests i64
	inflight_requests i64
	draining bool
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

fn cmd_with_socket(worker_cmd string, worker_socket string, pool_size int) !string {
	if worker_cmd == '' {
		return error('empty worker command')
	}
	if worker_socket == '' {
		return error('worker socket is required when autostart is enabled')
	}
	if worker_cmd.contains('{socket}') {
		return worker_cmd.replace('{socket}', worker_socket)
	}
	if pool_size > 1 && worker_cmd.contains('--socket') {
		return error('worker-cmd for pool mode must use {socket} placeholder when --socket is present')
	}
	if !worker_cmd.contains('--socket') {
		return '${worker_cmd} --socket ${worker_socket}'
	}
	return worker_cmd
}

fn start_managed_worker(id int, worker_cmd string, worker_socket string, workdir string, pool_size int) !ManagedWorker {
	cmd := cmd_with_socket(worker_cmd, worker_socket, pool_size)!
	cmd_with_parent := 'VHTTPD_PARENT_PID=${os.getpid()} ${cmd}'
	mut proc := os.new_process('/bin/sh')
	proc.set_args(['-lc', cmd_with_parent])
	proc.set_work_folder(workdir)
	proc.use_pgroup = true
	proc.run()
	wait_for_worker(worker_socket, 5000)!
	return ManagedWorker{
		id: id
		socket_path: worker_socket
		worker_cmd: cmd_with_parent
		proc: proc
		last_exit_ts: 0
		next_retry_ts: 0
		served_requests: 0
		inflight_requests: 0
		draining: false
	}
}

fn (mut w ManagedWorker) stop() {
	if isnil(w.proc) {
		return
	}
	if w.proc.is_alive() {
		w.proc.signal_term()
		time.sleep(200 * time.millisecond)
		if w.proc.is_alive() {
			w.proc.signal_pgkill()
			time.sleep(100 * time.millisecond)
		}
		if w.proc.is_alive() {
			w.proc.signal_kill()
		}
		w.proc.wait()
	}
	w.proc.close()
}

fn stop_worker_pool(mut workers []ManagedWorker) {
	for i in 0 .. workers.len {
		mut w := workers[i]
		w.stop()
	}
}

fn socket_prefix(worker_socket string) string {
	if worker_socket.len >= 5 && worker_socket.ends_with('.sock') {
		return worker_socket[..worker_socket.len - 5]
	}
	if worker_socket != '' {
		return worker_socket
	}
	return '/tmp/vslim_worker'
}

fn resolve_worker_sockets(args []string) []string {
	worker_sockets_arg := get_arg(args, '--worker-sockets', '')
	if worker_sockets_arg != '' {
		mut sockets := []string{}
		for raw in worker_sockets_arg.split(',') {
			s := raw.trim_space()
			if s != '' {
				sockets << s
			}
		}
		return sockets
	}
	worker_socket := get_arg(args, '--worker-socket', '')
	pool_size := get_arg(args, '--worker-pool-size', '1').int()
	if pool_size <= 1 {
		return if worker_socket == '' { []string{} } else { [worker_socket] }
	}
	mut prefix := get_arg(args, '--worker-socket-prefix', '')
	if prefix == '' {
		prefix = socket_prefix(worker_socket)
	}
	mut sockets := []string{cap: pool_size}
	for i in 0 .. pool_size {
		sockets << '${prefix}_${i}.sock'
	}
	return sockets
}

fn start_worker_pool(worker_cmd string, worker_sockets []string, workdir string) ![]ManagedWorker {
	if worker_sockets.len == 0 {
		return []ManagedWorker{}
	}
	mut workers := []ManagedWorker{}
	for i, socket_path in worker_sockets {
		worker := start_managed_worker(i, worker_cmd, socket_path, workdir, worker_sockets.len)!
		workers << worker
	}
	return workers
}

fn restart_backoff_ms(restart_count int, base_ms int, max_ms int) int {
	mut delay := if base_ms > 0 { base_ms } else { 500 }
	mut step := if restart_count > 0 { restart_count - 1 } else { 0 }
	for step > 0 {
		delay *= 2
		if delay >= max_ms {
			return max_ms
		}
		step--
	}
	if delay > max_ms {
		return max_ms
	}
	return delay
}

fn (mut app App) ensure_worker_slot(idx int) {
	if !app.worker_autostart || idx < 0 || idx >= app.managed_workers.len {
		return
	}
	now := time.now().unix_milli()
	mut w := app.managed_workers[idx]
	if !isnil(w.proc) && w.proc.is_alive() {
		return
	}
	if w.next_retry_ts > now {
		return
	}
	delay_ms := restart_backoff_ms(w.restart_count, app.worker_restart_backoff_ms, app.worker_restart_backoff_max_ms)
	mut proc := os.new_process('/bin/sh')
	proc.set_args(['-lc', w.worker_cmd])
	proc.set_work_folder(app.worker_workdir)
	proc.use_pgroup = true
	proc.run()
	wait_for_worker(w.socket_path, 1500) or {
		w.restart_count++
		w.last_exit_ts = now
		w.next_retry_ts = now + delay_ms
		app.managed_workers[idx] = w
		app.emit('worker.restart_scheduled', {
			'worker_id': '${w.id}'
			'socket': w.socket_path
			'restart_count': '${w.restart_count}'
			'next_retry_ts': '${w.next_retry_ts}'
			'reason': err.msg()
		})
		return
	}
	w.proc = proc
	w.restart_count++
	w.last_exit_ts = now
	w.next_retry_ts = 0
	w.served_requests = 0
	app.managed_workers[idx] = w
	app.emit('worker.started', {
		'worker_id': '${w.id}'
		'socket': w.socket_path
		'restart_count': '${w.restart_count}'
	})
}

fn (mut app App) worker_index_by_socket(socket_path string) int {
	for i, w in app.managed_workers {
		if w.socket_path == socket_path {
			return i
		}
	}
	return -1
}

fn (mut app App) restart_worker_slot_now(idx int, reason string) {
	if idx < 0 || idx >= app.managed_workers.len {
		return
	}
	mut w := app.managed_workers[idx]
	if isnil(w.proc) {
		app.ensure_worker_slot(idx)
		return
	}
	if w.proc.is_alive() {
		w.proc.signal_pgkill()
		w.proc.wait()
	}
	w.proc.close()
	now := time.now().unix_milli()
	delay_ms := restart_backoff_ms(w.restart_count, app.worker_restart_backoff_ms, app.worker_restart_backoff_max_ms)
	mut proc := os.new_process('/bin/sh')
	proc.set_args(['-lc', w.worker_cmd])
	proc.set_work_folder(app.worker_workdir)
	proc.use_pgroup = true
	proc.run()
	wait_for_worker(w.socket_path, 1500) or {
		w.restart_count++
		w.last_exit_ts = now
		w.next_retry_ts = now + delay_ms
		app.managed_workers[idx] = w
		app.emit('worker.restart_scheduled', {
			'worker_id': '${w.id}'
			'socket': w.socket_path
			'restart_count': '${w.restart_count}'
			'next_retry_ts': '${w.next_retry_ts}'
			'reason': '${reason}; ${err.msg()}'
		})
		return
	}
	w.proc = proc
	w.restart_count++
	w.last_exit_ts = now
	w.next_retry_ts = 0
	w.served_requests = 0
	w.inflight_requests = 0
	w.draining = false
	app.managed_workers[idx] = w
	app.emit('worker.restarted', {
		'worker_id': '${w.id}'
		'socket': w.socket_path
		'restart_count': '${w.restart_count}'
		'reason': reason
	})
}

fn (mut app App) on_worker_request_started(socket_path string) {
	if !app.worker_autostart || app.managed_workers.len == 0 {
		return
	}
	idx := app.worker_index_by_socket(socket_path)
	if idx < 0 {
		return
	}
	mut w := app.managed_workers[idx]
	w.inflight_requests++
	app.managed_workers[idx] = w
}

fn (mut app App) on_worker_request_finished(socket_path string) {
	if !app.worker_autostart || app.managed_workers.len == 0 {
		return
	}
	idx := app.worker_index_by_socket(socket_path)
	if idx < 0 {
		return
	}
	mut w := app.managed_workers[idx]
	if w.inflight_requests > 0 {
		w.inflight_requests--
	}
	if app.worker_max_requests > 0 {
		w.served_requests++
	}
	if app.worker_max_requests > 0 && !w.draining && w.served_requests >= app.worker_max_requests {
		w.draining = true
		app.emit('worker.max_requests_reached', {
			'worker_id': '${w.id}'
			'socket': w.socket_path
			'served_requests': '${w.served_requests}'
			'max_requests': '${app.worker_max_requests}'
		})
	}
	app.managed_workers[idx] = w
	if w.draining && w.inflight_requests == 0 {
		app.restart_worker_slot_now(idx, 'max_requests_reached')
	}
}

fn (mut app App) ensure_workers_alive() {
	if !app.worker_autostart || app.managed_workers.len == 0 {
		return
	}
	for i in 0 .. app.managed_workers.len {
		app.ensure_worker_slot(i)
	}
}

fn (mut app App) next_worker_socket() ?string {
	app.pool_mu.@lock()
	defer {
		app.pool_mu.unlock()
	}
	if app.worker_sockets.len == 0 {
		return none
	}
	idx := app.worker_rr_index % app.worker_sockets.len
	socket_path := app.worker_sockets[idx]
	app.worker_rr_index = (idx + 1) % app.worker_sockets.len
	return socket_path
}

fn connect_any_worker(mut app App) !string {
	app.ensure_workers_alive()
	if app.worker_sockets.len == 0 {
		return error('worker not configured')
	}
	mut last_err := 'worker unavailable'
	mut draining_ready := []int{}
	for _ in 0 .. app.worker_sockets.len {
		socket_path := app.next_worker_socket() or { break }
		if app.worker_autostart {
			idx := app.worker_index_by_socket(socket_path)
			if idx >= 0 {
				w := app.managed_workers[idx]
				if w.draining {
					if w.inflight_requests == 0 {
						draining_ready << idx
					}
					last_err = 'all workers draining'
					continue
				}
				return socket_path
			}
		}
		mut probe_conn := unix.connect_stream(socket_path) or {
			last_err = err.msg()
			continue
		}
		probe_conn.close() or {}
		return socket_path
	}
	if app.worker_autostart {
		for idx in draining_ready {
			app.restart_worker_slot_now(idx, 'drain_complete')
		}
	}
	return error(last_err)
}

fn (mut app App) worker_admin_snapshot() WorkerPoolAdminStatus {
	app.pool_mu.@lock()
	defer {
		app.pool_mu.unlock()
	}
	mut workers := []WorkerAdminStatus{cap: app.managed_workers.len}
	for worker in app.managed_workers {
		mut w := worker
		workers << WorkerAdminStatus{
			id: w.id
			socket: w.socket_path
			alive: if isnil(w.proc) { false } else { w.proc.is_alive() }
			draining: w.draining
			inflight_requests: w.inflight_requests
			served_requests: w.served_requests
			restart_count: w.restart_count
			next_retry_ts: w.next_retry_ts
		}
	}
	return WorkerPoolAdminStatus{
		worker_autostart: app.worker_autostart
		worker_pool_size: app.worker_sockets.len
		worker_rr_index: app.worker_rr_index
		worker_max_requests: app.worker_max_requests
		worker_sockets: app.worker_sockets.clone()
		workers: workers
	}
}
