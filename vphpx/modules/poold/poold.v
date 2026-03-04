module poold

import time

pub fn run(args []string) ! {
	if has_flag(args, '--help') || has_flag(args, '-h') {
		print_help()
		return
	}

	socket := get_flag(args, '--socket', '/run/vphpx/poold.sock')
	max_conns := get_flag(args, '--max-conns', '64')
	idle_ttl := get_flag(args, '--idle-ttl-ms', '60000')

	println('[vphpx/poold] starting...')
	println('  socket      = ${socket}')
	println('  max_conns   = ${max_conns}')
	println('  idle_ttl_ms = ${idle_ttl}')
	println('  status      = protocol skeleton ready')
	println('  next        = implement unix socket server and pool backends')
	println('[vphpx/poold] startup complete at ${time.now()}')
}

fn print_help() {
	println('vphpx poold')
	println('')
	println('Options:')
	println('  --socket <path>          Unix socket path (default: /run/vphpx/poold.sock)')
	println('  --max-conns <n>          Max backend connections per pool (default: 64)')
	println('  --idle-ttl-ms <ms>       Idle recycle TTL in ms (default: 60000)')
}

fn get_flag(args []string, name string, default_value string) string {
	for i, a in args {
		if a == name && i + 1 < args.len {
			return args[i + 1]
		}
		prefix := '${name}='
		if a.starts_with(prefix) {
			return a.all_after(prefix)
		}
	}
	return default_value
}

fn has_flag(args []string, name string) bool {
	for a in args {
		if a == name || a.starts_with('${name}=') {
			return true
		}
	}
	return false
}
