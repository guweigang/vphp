module main

import net.urllib

fn (route VSlimRoute) normalized_pattern() string {
	return RoutePath.normalize(route.pattern)
}

fn (route VSlimRoute) matches(path string) (bool, map[string]string) {
	p := route.normalized_pattern()
	u := RoutePath.normalize(path)
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

fn RoutePath.normalize_group_prefix(prefix string) string {
	if prefix == '' || prefix == '/' {
		return ''
	}
	mut out := RoutePath.normalize(prefix)
	if out.len > 1 && out.ends_with('/') {
		out = out[..out.len - 1]
	}
	return out
}

fn (group RouteGroup) normalized_prefix() string {
	return RoutePath.normalize_group_prefix(group.prefix)
}

fn (group RouteGroup) prefixed_pattern(pattern string) string {
	return RoutePath.prefixed_pattern(group.prefix, pattern)
}

fn RoutePath.prefixed_pattern(prefix string, pattern string) string {
	base := RoutePath.normalize_group_prefix(prefix)
	mut tail := RoutePath.normalize(pattern)
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

fn RoutePath.normalize_base_path(base_path string) string {
	if base_path == '' || base_path == '/' {
		return ''
	}
	mut out := RoutePath.normalize(base_path)
	if out.len > 1 && out.ends_with('/') {
		out = out[..out.len - 1]
	}
	return out
}

fn RoutePath.apply_base_path(base_path string, path string) string {
	base := RoutePath.normalize_base_path(base_path)
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

fn RoutePath.absolute_url(scheme string, host string, path string) string {
	clean_scheme := if scheme == '' { 'http' } else { scheme }
	clean_host := host.trim_space()
	if clean_host == '' {
		return path
	}
	return '${clean_scheme}://${clean_host}${path}'
}

fn (app &VSlimApp) render_route_url(pattern string, params &map[string]string, query &map[string]string) ?string {
	p := RoutePath.normalize(pattern)
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
		path += '?' + app.encode_query_params(query)
	}
	return path
}

fn (app &VSlimApp) encode_query_params(query &map[string]string) string {
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

fn VSlimRequest.normalize_target(raw_path string) (string, string) {
	path := RoutePath.normalize(raw_path)
	if !path.contains('?') {
		return path, ''
	}
	base := RoutePath.normalize(path.all_before('?'))
	query := path.all_after('?')
	return base, query
}

fn RoutePath.normalize(path string) string {
	if path.len == 0 {
		return '/'
	}
	if path.starts_with('/') {
		return path
	}
	return '/${path}'
}

fn VSlimRequest.parse_query(query_str string) map[string]string {
	mut out := map[string]string{}
	if query_str == '' {
		return out
	}
	values := urllib.parse_query(query_str) or { return out }
	for key, entries in values.to_map() {
		if entries.len == 0 {
			out[key] = ''
			continue
		}
		out[key] = entries[0]
	}
	return out
}

fn VSlimRequest.normalize_header_name(name string) string {
	return name.trim_space().to_lower()
}
