module main

import os

const version = '0.0.1'

fn main() {
	args := os.args[1..]
	if args.len == 0 {
		print_help()
		return
	}

	cmd := args[0]
	sub_args := if args.len > 1 { args[1..] } else { []string{} }

	match cmd {
		'help', '--help', '-h' {
			print_help()
		}
		'version', '--version', '-v' {
			println('vphpx ${version}')
		}
		'serve' {
			serve_run(sub_args) or {
				eprintln('serve error: ${err}')
				exit(1)
			}
		}
		'poold' {
			poold_run(sub_args) or {
				eprintln('poold error: ${err}')
				exit(1)
			}
		}
		'data' {
			data_run(sub_args) or {
				eprintln('data error: ${err}')
				exit(1)
			}
		}
		'bench' {
			bench_run(sub_args) or {
				eprintln('bench error: ${err}')
				exit(1)
			}
		}
		else {
			eprintln('unknown command: ${cmd}')
			print_help()
			exit(2)
		}
	}
}

fn print_help() {
	println('vphpx ${version}')
	println('')
	println('Usage:')
	println('  vphpx <command> [options]')
	println('')
	println('Commands:')
	println('  serve    Start API gateway / reverse proxy')
	println('  poold    Start sidecar connection pool daemon')
	println('  data     Run data processing tasks (CSV/JSON)')
	println('  bench    Run benchmark scenarios')
	println('  version  Show version')
	println('')
	println('Examples:')
	println('  vphpx serve --listen 127.0.0.1:8080 --upstream http://127.0.0.1:9501')
	println('  vphpx poold --socket /run/vphpx/poold.sock')
	println('  vphpx data agg --in sales.csv --group-by region --sum amount')
	println('  vphpx bench --scenario json_transform')
}
