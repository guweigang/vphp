module bench

import time

pub fn run(args []string) ! {
	if has_flag(args, '--help') || has_flag(args, '-h') {
		print_help()
		return
	}

	scenario := get_flag(args, '--scenario', 'json_transform')
	iterations := get_flag(args, '--iterations', '10000')

	started := time.now()
	println('[vphpx/bench] running...')
	println('  scenario   = ${scenario}')
	println('  iterations = ${iterations}')
	println('  status     = benchmark skeleton')
	println('  started_at = ${started}')
}

fn print_help() {
	println('vphpx bench')
	println('')
	println('Options:')
	println('  --scenario <name>        Scenario name (default: json_transform)')
	println('  --iterations <n>         Number of iterations (default: 10000)')
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
