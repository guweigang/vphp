module serve

import time

pub fn run(args []string) ! {
	if has_flag(args, '--help') || has_flag(args, '-h') {
		print_help()
		return
	}

	listen := get_flag(args, '--listen', '127.0.0.1:8080')
	upstream := get_flag(args, '--upstream', 'http://127.0.0.1:9501')
	mode := get_flag(args, '--mode', 'proxy')

	println('[vphpx/serve] starting...')
	println('  listen   = ${listen}')
	println('  upstream = ${upstream}')
	println('  mode     = ${mode}')
	println('  status   = bootstrapped (MVP skeleton)')
	println('  next     = implement proxy and middleware chain')
	println('[vphpx/serve] startup complete at ${time.now()}')
}

fn print_help() {
	println('vphpx serve')
	println('')
	println('Options:')
	println('  --listen <host:port>     Listen address (default: 127.0.0.1:8080)')
	println('  --upstream <url>         Upstream url (default: http://127.0.0.1:9501)')
	println('  --mode <proxy|mock>      Runtime mode (default: proxy)')
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
