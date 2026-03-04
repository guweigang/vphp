module main

import vphp

fn normalize_path(path string) string {
	if path.len == 0 {
		return '/'
	}
	if path.starts_with('/') {
		return path
	}
	return '/${path}'
}

fn normalize_group_prefix(prefix string) string {
	if prefix == '' || prefix == '/' {
		return ''
	}
	mut out := normalize_path(prefix)
	if out.len > 1 && out.ends_with('/') {
		out = out[..out.len - 1]
	}
	return out
}

fn normalize_base_path(base_path string) string {
	if base_path == '' || base_path == '/' {
		return ''
	}
	mut out := normalize_path(base_path)
	if out.len > 1 && out.ends_with('/') {
		out = out[..out.len - 1]
	}
	return out
}

fn join_route_prefix(prefix string, pattern string) string {
	base := normalize_group_prefix(prefix)
	mut tail := normalize_path(pattern)
	if base == '' {
		return tail
	}
	if tail == '/' {
		return base
	}
	if tail.starts_with('/') {
		tail = tail[1..]
	}
	return '${base}/${tail}'
}

fn (app &VSlimApp) apply_base_path(path string) string {
	base := normalize_base_path(app.base_path)
	if base == '' || path == '' {
		return path
	}
	if path == '/' {
		return base
	}
	if path.starts_with('/') {
		return base + path
	}
	return '${base}/${path}'
}

fn join_absolute_url(scheme string, host string, path string) string {
	clean_scheme := if scheme == '' { 'http' } else { scheme }
	clean_host := host.trim_space()
	if clean_host == '' {
		return path
	}
	return '${clean_scheme}://${clean_host}${path}'
}

fn render_route_url(pattern string, params &map[string]string, query &map[string]string) ?string {
	p := normalize_path(pattern)
	mut parts := []string{}
	for part in p.trim('/').split('/') {
		if part == '' {
			continue
		}
		if part.starts_with(':') {
			key := part.all_after(':')
			if key !in params {
				return none
			}
			unsafe {
				parts << params[key]
			}
			continue
		}
		parts << part
	}
	mut path := if parts.len == 0 { '/' } else { '/' + parts.join('/') }
	if query.len > 0 {
		path += '?' + encode_query_params(query)
	}
	return path
}

fn encode_query_params(query &map[string]string) string {
	mut keys := query.keys()
	keys.sort()
	mut parts := []string{}
	for key in keys {
		unsafe {
			parts << '${key}=${query[key]}'
		}
	}
	return parts.join('&')
}

fn normalize_request_target(raw_path string) (string, string) {
	path := normalize_path(raw_path)
	if !path.contains('?') {
		return path, ''
	}
	base := normalize_path(path.all_before('?'))
	query := path.all_after('?')
	return base, query
}

fn parse_query_string(query_str string) map[string]string {
	mut out := map[string]string{}
	if query_str == '' {
		return out
	}
	for pair in query_str.split('&') {
		if pair == '' {
			continue
		}
		if pair.contains('=') {
			k := pair.all_before('=')
			v := pair.all_after('=')
			out[k] = v
		} else {
			out[pair] = ''
		}
	}
	return out
}

fn normalize_header_name(name string) string {
	return name.trim_space().to_lower()
}

fn zval_to_name_map(z vphp.ZVal) map[string]string {
	if !z.is_valid() || z.is_null() || z.is_undef() {
		return map[string]string{}
	}
	return z.to_v[map[string]string]() or { map[string]string{} }
}

fn match_route(pattern string, path string) (bool, map[string]string) {
	p := normalize_path(pattern)
	u := normalize_path(path)
	if p == u {
		return true, map[string]string{}
	}

	p_parts := p.trim('/').split('/')
	u_parts := u.trim('/').split('/')
	if p_parts.len != u_parts.len {
		return false, map[string]string{}
	}

	mut params := map[string]string{}
	for i in 0 .. p_parts.len {
		pp := p_parts[i]
		up := u_parts[i]
		if pp.starts_with(':') {
			params[pp.all_after(':')] = up
			continue
		}
		if pp != up {
			return false, map[string]string{}
		}
	}
	return true, params
}
