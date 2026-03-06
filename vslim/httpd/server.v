module main

import os
import time
import veb
import veb.request_id

fn run_server(args []string) {
	host := get_arg(args, '--host', '127.0.0.1')
	port := get_arg(args, '--port', '18081').int()
	event_log := get_arg(args, '--event-log', '/tmp/vhttpd.events.ndjson')
	pid_file := get_arg(args, '--pid-file', '/tmp/vhttpd.pid')
	worker_read_timeout_ms := get_arg(args, '--worker-read-timeout-ms', '3000').int()
	worker_cmd := get_arg(args, '--worker-cmd', '')
	worker_autostart := get_arg(args, '--worker-autostart', '').trim_space() in ['1', 'true', 'yes', 'on']
	worker_restart_backoff_ms := get_arg(args, '--worker-restart-backoff-ms', '500').int()
	worker_restart_backoff_max_ms := get_arg(args, '--worker-restart-backoff-max-ms', '8000').int()
	worker_max_requests := get_arg(args, '--worker-max-requests', '0').int()
	admin_host_arg := get_arg(args, '--admin-host', '').trim_space()
	admin_port := get_arg(args, '--admin-port', '0').int()
	admin_token := get_arg(args, '--admin-token', '')
	admin_enabled := admin_port > 0
	admin_host := if admin_host_arg == '' { '127.0.0.1' } else { admin_host_arg }
	worker_sockets := resolve_worker_sockets(args)
	workdir := os.getwd()

	os.mkdir_all(os.dir(event_log)) or {}
	os.mkdir_all(os.dir(pid_file)) or {}
	os.write_file(pid_file, '${os.getpid()}') or {}

	mut app := &App{
		event_log: event_log
		worker_sockets: worker_sockets
		worker_read_timeout_ms: worker_read_timeout_ms
		worker_autostart: worker_autostart
		worker_cmd: worker_cmd
		worker_workdir: workdir
		worker_restart_backoff_ms: worker_restart_backoff_ms
		worker_restart_backoff_max_ms: worker_restart_backoff_max_ms
		worker_max_requests: worker_max_requests
		admin_on_data_plane: !admin_enabled
	}
	defer {
		stop_worker_pool(mut app.managed_workers)
		os.rm(pid_file) or {}
	}

	if worker_autostart {
		app.managed_workers = start_worker_pool(worker_cmd, worker_sockets, workdir) or {
			eprintln('worker start failed: ${err}')
			return
		}
		for w in app.managed_workers {
			app.emit('worker.started', {
				'worker_id': '${w.id}'
				'socket': w.socket_path
				'restart_count': '${w.restart_count}'
			})
		}
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
		'pid': '${os.getpid()}'
		'worker_autostart': if worker_autostart { 'true' } else { 'false' }
		'worker_pool_size': '${worker_sockets.len}'
		'admin_enabled': if admin_enabled { 'true' } else { 'false' }
		'admin_host': if admin_enabled { admin_host } else { '' }
		'admin_port': if admin_enabled { '${admin_port}' } else { '' }
	})
	if admin_enabled {
		go run_admin_server(app, admin_host, admin_port, admin_token)
		app.emit('admin.started', {
			'host': admin_host
			'port': '${admin_port}'
		})
	}

	veb.run_at[App, Context](mut app, host: host, port: port, family: .ip) or {
		eprintln('server failed: ${err}')
	}
}

fn main() {
	args := os.args[1..]
	run_server(args)
}
