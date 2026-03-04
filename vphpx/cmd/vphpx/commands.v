module main

import time

fn serve_run(args []string) ! {
	if has_flag(args, '--help') || has_flag(args, '-h') {
		println('vphpx serve')
		println('  --listen <host:port>   default: 127.0.0.1:8080')
		println('  --upstream <url>       default: http://127.0.0.1:9501')
		return
	}

	listen := get_flag(args, '--listen', '127.0.0.1:8080')
	upstream := get_flag(args, '--upstream', 'http://127.0.0.1:9501')
	mode := get_flag(args, '--mode', 'proxy')
	println('[vphpx/serve] listen=${listen} upstream=${upstream} mode=${mode}')
	println('[vphpx/serve] startup complete at ${time.now()}')
}

fn poold_run(args []string) ! {
	if has_flag(args, '--help') || has_flag(args, '-h') {
		println('vphpx poold')
		println('  --socket <path>        default: /run/vphpx/poold.sock')
		println('  --max-conns <n>        default: 64')
		return
	}

	socket := get_flag(args, '--socket', '/run/vphpx/poold.sock')
	max_conns := get_flag(args, '--max-conns', '64')
	println('[vphpx/poold] socket=${socket} max_conns=${max_conns}')
	println('[vphpx/poold] protocol skeleton ready')
}

fn data_run(args []string) ! {
	if args.len == 0 || has_flag(args, '--help') || has_flag(args, '-h') {
		println('vphpx data')
		println('  agg --in <file> --group-by <col> --sum <col>')
		return
	}

	cmd := args[0]
	sub_args := if args.len > 1 { args[1..] } else { []string{} }
	match cmd {
		'agg' {
			input := get_flag(sub_args, '--in', 'input.csv')
			group_by := get_flag(sub_args, '--group-by', 'key')
			sum_col := get_flag(sub_args, '--sum', 'value')
			println('[vphpx/data:agg] in=${input} group_by=${group_by} sum=${sum_col}')
		}
		else {
			return error('unknown data subcommand: ${cmd}')
		}
	}
}

fn bench_run(args []string) ! {
	if has_flag(args, '--help') || has_flag(args, '-h') {
		println('vphpx bench')
		println('  --scenario <name>      default: json_transform')
		println('  --iterations <n>       default: 10000')
		return
	}

	scenario := get_flag(args, '--scenario', 'json_transform')
	iterations := get_flag(args, '--iterations', '10000')
	println('[vphpx/bench] scenario=${scenario} iterations=${iterations}')
}

