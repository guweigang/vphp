module main

import os
import time
import veb
import veb.request_id

const vhttpd_version = '0.1.0'

const known_long_flags = [
	'--help',
	'--version',
	'--config',
	'--host',
	'--port',
	'--event-log',
	'--pid-file',
	'--worker-read-timeout-ms',
	'--worker-cmd',
	'--worker-autostart',
	'--worker-restart-backoff-ms',
	'--worker-restart-backoff-max-ms',
	'--worker-max-requests',
	'--worker-socket',
	'--worker-sockets',
	'--worker-pool-size',
	'--worker-socket-prefix',
	'--admin-host',
	'--admin-port',
	'--admin-token',
]

fn has_flag(args []string, flags []string) bool {
	for a in args {
		for f in flags {
			if a == f {
				return true
			}
		}
	}
	return false
}

fn print_vhttpd_help() {
	println('vhttpd ${vhttpd_version}')
	println('')
	println('Usage:')
	println('  vhttpd [--config <file.toml>] [options]')
	println('  vhttpd <file.toml>')
	println('')
	println('Common options:')
	println('  --help, -h')
	println('  --version, -v')
	println('  --config <path>              TOML config file')
	println('  --host <host>                Data plane host')
	println('  --port <port>                Data plane port')
	println('  --admin-host <host>          Admin plane host')
	println('  --admin-port <port>          Admin plane port')
	println('  --admin-token <token>        Admin API token')
	println('  --event-log <path>           Event log path')
	println('  --pid-file <path>            PID file path')
	println('  --worker-autostart <0|1>')
	println('  --worker-cmd <command>')
	println('  --worker-socket <path>       Single worker socket')
	println('  --worker-pool-size <N>       Managed worker pool size')
	println('  --worker-socket-prefix <p>   Prefix for pool sockets')
	println('')
	println('Examples:')
	println('  vhttpd --config /path/to/vhttpd.toml')
	println('  vhttpd /path/to/vhttpd.toml')
}

fn validate_args(args []string) ! {
	for arg in args {
		if arg.len == 0 {
			continue
		}
		if arg == '-h' || arg == '-v' {
			continue
		}
		if arg.starts_with('--') {
			key := if arg.contains('=') { arg.all_before('=') } else { arg }
			if key in known_long_flags {
				continue
			}
			return error('unknown option: ${arg}')
		}
		if arg.starts_with('-') {
			return error('unknown option: ${arg}')
		}
		// positional args are allowed (e.g. config path shorthand)
	}
}

fn run_server(args []string) {
	cfg := load_vhttpd_config(args) or {
		eprintln('config load failed: ${err}')
		return
	}
	host := arg_string_or(args, '--host', cfg.server.host)
	port := arg_int_or(args, '--port', cfg.server.port)
	event_log := arg_string_or(args, '--event-log', cfg.files.event_log)
	pid_file := arg_string_or(args, '--pid-file', cfg.files.pid_file)
	worker_read_timeout_ms := arg_int_or(args, '--worker-read-timeout-ms', cfg.worker.read_timeout_ms)
	worker_cmd := arg_string_or(args, '--worker-cmd', cfg.worker.cmd)
	worker_autostart := arg_bool_or(args, '--worker-autostart', cfg.worker.autostart)
	worker_restart_backoff_ms := arg_int_or(args, '--worker-restart-backoff-ms', cfg.worker.restart_backoff_ms)
	worker_restart_backoff_max_ms := arg_int_or(args, '--worker-restart-backoff-max-ms',
		cfg.worker.restart_backoff_max_ms)
	worker_max_requests := arg_int_or(args, '--worker-max-requests', cfg.worker.max_requests)
	admin_host_arg := arg_string_or(args, '--admin-host', cfg.admin.host).trim_space()
	admin_port := arg_int_or(args, '--admin-port', cfg.admin.port)
	admin_token := arg_string_or(args, '--admin-token', cfg.admin.token)
	admin_enabled := admin_port > 0
	admin_host := if admin_host_arg == '' { '127.0.0.1' } else { admin_host_arg }
	worker_sockets := resolve_worker_sockets_with_defaults(args, cfg.worker.socket, cfg.worker.pool_size,
		cfg.worker.socket_prefix, cfg.worker.sockets.join(','))
	workdir := os.getwd()

	os.mkdir_all(os.dir(event_log)) or {}
	os.mkdir_all(os.dir(pid_file)) or {}
	os.write_file(pid_file, '${os.getpid()}') or {}

	mut app := &App{
		event_log:                     event_log
		started_at_unix:               time.now().unix()
		worker_sockets:                worker_sockets
		worker_read_timeout_ms:        worker_read_timeout_ms
		worker_autostart:              worker_autostart
		worker_cmd:                    worker_cmd
		worker_env:                    cfg.worker.env.clone()
		worker_workdir:                workdir
		worker_restart_backoff_ms:     worker_restart_backoff_ms
		worker_restart_backoff_max_ms: worker_restart_backoff_max_ms
		worker_max_requests:           worker_max_requests
		admin_on_data_plane:           !admin_enabled
	}
	defer {
		stop_worker_pool(mut app.managed_workers)
		os.rm(pid_file) or {}
	}

	if worker_autostart {
		app.managed_workers = start_worker_pool(worker_cmd, app.worker_env, worker_sockets,
			workdir) or {
			eprintln('worker start failed: ${err}')
			return
		}
		for w in app.managed_workers {
			app.emit('worker.started', {
				'worker_id':     '${w.id}'
				'socket':        w.socket_path
				'restart_count': '${w.restart_count}'
			})
		}
	}

	app.use(request_id.middleware[Context](request_id.Config{
		header:    'X-Request-ID'
		generator: fn () string {
			return 'req-${time.now().unix_micro()}'
		}
	}))
	app.emit('server.started', {
		'host':             host
		'port':             '${port}'
		'pid':              '${os.getpid()}'
		'worker_autostart': if worker_autostart { 'true' } else { 'false' }
		'worker_pool_size': '${worker_sockets.len}'
		'admin_enabled':    if admin_enabled { 'true' } else { 'false' }
		'admin_host':       if admin_enabled { admin_host } else { '' }
		'admin_port':       if admin_enabled { '${admin_port}' } else { '' }
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
	if has_flag(args, ['--help', '-h']) {
		print_vhttpd_help()
		return
	}
	if has_flag(args, ['--version', '-v']) {
		println(vhttpd_version)
		return
	}
	validate_args(args) or {
		eprintln('argument error: ${err}')
		eprintln('run `vhttpd --help` for usage.')
		exit(2)
	}
	run_server(args)
}
