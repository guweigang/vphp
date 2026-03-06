module main

import os
import toml

struct ServerConfig {
	host string = '127.0.0.1'
	port int    = 18081
}

struct FilesConfig {
	event_log string = '/tmp/vhttpd.events.ndjson'
	pid_file  string = '/tmp/vhttpd.pid'
}

struct WorkerConfig {
	read_timeout_ms         int      = 3000 @[toml: 'read_timeout_ms']
	autostart               bool
	cmd                     string
	restart_backoff_ms      int      = 500 @[toml: 'restart_backoff_ms']
	restart_backoff_max_ms  int      = 8000 @[toml: 'restart_backoff_max_ms']
	max_requests            int      @[toml: 'max_requests']
	socket                  string
	pool_size               int      = 1 @[toml: 'pool_size']
	socket_prefix           string   @[toml: 'socket_prefix']
	sockets                 []string
	env                     map[string]string
}

struct AdminConfig {
	host  string = '127.0.0.1'
	port  int
	token string
}

struct VhttpdConfig {
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
	return toml.decode[VhttpdConfig](text)!
}
