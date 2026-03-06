module main

import os
import toml

struct ServerConfig {
mut:
	host string = '127.0.0.1'
	port int    = 18081
}

struct FilesConfig {
mut:
	event_log string = '/tmp/vhttpd.events.ndjson'
	pid_file  string = '/tmp/vhttpd.pid'
}

struct WorkerConfig {
mut:
	read_timeout_ms        int = 3000 @[toml: 'read_timeout_ms']
	autostart              bool
	cmd                    string
	restart_backoff_ms     int = 500 @[toml: 'restart_backoff_ms']
	restart_backoff_max_ms int = 8000 @[toml: 'restart_backoff_max_ms']
	max_requests           int @[toml: 'max_requests']
	socket                 string
	pool_size              int = 1    @[toml: 'pool_size']
	socket_prefix          string @[toml: 'socket_prefix']
	sockets                []string
	env                    map[string]string
}

struct AdminConfig {
mut:
	host  string = '127.0.0.1'
	port  int
	token string
}

struct VhttpdConfig {
mut:
	server ServerConfig
	files  FilesConfig
	worker WorkerConfig
	admin  AdminConfig
}

fn default_vhttpd_config() VhttpdConfig {
	return VhttpdConfig{}
}

fn arg_has(args []string, key string) bool {
	for a in args {
		if a == key || a.starts_with('${key}=') {
			return true
		}
	}
	return false
}

fn arg_string_or(args []string, key string, default_val string) string {
	if !arg_has(args, key) {
		return default_val
	}
	return get_arg(args, key, default_val)
}

fn arg_int_or(args []string, key string, default_val int) int {
	if !arg_has(args, key) {
		return default_val
	}
	raw := get_arg(args, key, '${default_val}')
	return raw.int()
}

fn parse_boolish(raw string) bool {
	return raw.trim_space().to_lower() in ['1', 'true', 'yes', 'on']
}

fn arg_bool_or(args []string, key string, default_val bool) bool {
	for i, a in args {
		if a == key {
			if i + 1 < args.len && !args[i + 1].starts_with('--') {
				return parse_boolish(args[i + 1])
			}
			return true
		}
		prefix := '${key}='
		if a.starts_with(prefix) {
			return parse_boolish(a.all_after(prefix))
		}
	}
	return default_val
}

fn load_vhttpd_config(args []string) !VhttpdConfig {
	mut config_path := arg_string_or(args, '--config', '')
	if config_path == '' {
		config_path = os.getenv('VHTTPD_CONFIG')
	}
	if config_path == '' {
		for a in args {
			if a.starts_with('--') {
				continue
			}
			if a.to_lower().ends_with('.toml') {
				config_path = a
				break
			}
		}
	}
	if config_path == '' {
		return default_vhttpd_config()
	}
	text := os.read_file(config_path)!
	mut cfg := toml.decode[VhttpdConfig](text)!
	resolve_config_variables(mut cfg)!
	return cfg
}

fn resolve_config_variables(mut cfg VhttpdConfig) ! {
	env_map := os.environ()
	max_passes := 12
	for _ in 0 .. max_passes {
		mut changed := false
		vars := build_config_variable_map(cfg)
		cfg.server.host, changed = expand_config_string(cfg.server.host, vars, env_map,
			changed)!
		cfg.files.event_log, changed = expand_config_string(cfg.files.event_log, vars,
			env_map, changed)!
		cfg.files.pid_file, changed = expand_config_string(cfg.files.pid_file, vars, env_map,
			changed)!
		cfg.worker.cmd, changed = expand_config_string(cfg.worker.cmd, vars, env_map,
			changed)!
		cfg.worker.socket, changed = expand_config_string(cfg.worker.socket, vars, env_map,
			changed)!
		cfg.worker.socket_prefix, changed = expand_config_string(cfg.worker.socket_prefix,
			vars, env_map, changed)!
		for i, raw in cfg.worker.sockets {
			next, c := expand_config_string(raw, vars, env_map, false)!
			if c {
				cfg.worker.sockets[i] = next
				changed = true
			}
		}
		mut next_env := map[string]string{}
		for key, value in cfg.worker.env {
			next, c := expand_config_string(value, vars, env_map, false)!
			next_env[key] = next
			if c {
				changed = true
			}
		}
		cfg.worker.env = next_env.clone()
		cfg.admin.host, changed = expand_config_string(cfg.admin.host, vars, env_map,
			changed)!
		cfg.admin.token, changed = expand_config_string(cfg.admin.token, vars, env_map,
			changed)!
		if !changed {
			return
		}
	}
	return error('config variable expansion exceeded max passes (possible cyclic reference)')
}

fn build_config_variable_map(cfg VhttpdConfig) map[string]string {
	return {
		'server.host':                   cfg.server.host
		'server.port':                   '${cfg.server.port}'
		'files.event_log':               cfg.files.event_log
		'files.pid_file':                cfg.files.pid_file
		'worker.read_timeout_ms':        '${cfg.worker.read_timeout_ms}'
		'worker.autostart':              '${cfg.worker.autostart}'
		'worker.cmd':                    cfg.worker.cmd
		'worker.restart_backoff_ms':     '${cfg.worker.restart_backoff_ms}'
		'worker.restart_backoff_max_ms': '${cfg.worker.restart_backoff_max_ms}'
		'worker.max_requests':           '${cfg.worker.max_requests}'
		'worker.socket':                 cfg.worker.socket
		'worker.pool_size':              '${cfg.worker.pool_size}'
		'worker.socket_prefix':          cfg.worker.socket_prefix
		'admin.host':                    cfg.admin.host
		'admin.port':                    '${cfg.admin.port}'
		'admin.token':                   cfg.admin.token
	}
}

fn expand_config_string(raw string, vars map[string]string, env map[string]string, changed bool) !(string, bool) {
	if !raw.contains('\${') {
		return raw, changed
	}
	mut out := raw
	mut any_change := changed
	for {
		start := out.index('\${') or { break }
		end_rel := out[start + 2..].index('}') or {
			return error('invalid variable expression in config string: missing "}"')
		}
		end := start + 2 + end_rel
		expr := out[start + 2..end].trim_space()
		if expr == '' {
			return error('invalid empty variable expression in config string')
		}
		replacement := resolve_config_variable(expr, vars, env)!
		out = out[..start] + replacement + out[end + 1..]
		any_change = true
	}
	return out, any_change
}

fn resolve_config_variable(expr string, vars map[string]string, env map[string]string) !string {
	mut key := expr
	mut has_default := false
	mut default_raw := ''
	idx := expr.index(':-') or { -1 }
	if idx >= 0 {
		key = expr[..idx].trim_space()
		default_raw = expr[idx + 2..]
		has_default = true
	}
	if key == '' {
		return error('invalid variable expression')
	}
	if key.starts_with('env.') {
		env_key := key.all_after('env.')
		if env_key == '' {
			return error('invalid env variable expression')
		}
		if env_key in env {
			return env[env_key]
		}
		if has_default {
			return default_raw
		}
		return error('missing environment variable "${env_key}"')
	}
	if key in vars {
		return vars[key]
	}
	if has_default {
		return default_raw
	}
	return error('unknown config variable "${key}"')
}
