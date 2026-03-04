module data

pub fn run(args []string) ! {
	if args.len == 0 || has_flag(args, '--help') || has_flag(args, '-h') {
		print_help()
		return
	}

	cmd := args[0]
	sub_args := if args.len > 1 { args[1..] } else { []string{} }

	match cmd {
		'agg' {
			run_agg(sub_args)
		}
		else {
			return error('unknown data subcommand: ${cmd}')
		}
	}
}

fn run_agg(args []string) {
	input := get_flag(args, '--in', 'input.csv')
	group_by := get_flag(args, '--group-by', 'key')
	sum_col := get_flag(args, '--sum', 'value')
	println('[vphpx/data:agg]')
	println('  in       = ${input}')
	println('  group_by = ${group_by}')
	println('  sum      = ${sum_col}')
	println('  status   = parser/engine skeleton ready')
}

fn print_help() {
	println('vphpx data')
	println('')
	println('Subcommands:')
	println('  agg --in <file> --group-by <col> --sum <col>')
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
