module main

import os
import math
import vphp

@[php_method]
pub fn (mut app VSlimApp) set_view_base_path(base_path string) &VSlimApp {
	app.view_base_path = base_path.trim_space()
	return app
}

@[php_method]
pub fn (app &VSlimApp) view_base_path() string {
	return app.view_base_path
}

@[php_method]
pub fn (mut app VSlimApp) set_assets_prefix(prefix string) &VSlimApp {
	app.assets_prefix = normalize_assets_prefix(prefix)
	return app
}

@[php_method]
pub fn (app &VSlimApp) assets_prefix() string {
	if app.assets_prefix == '' {
		return '/assets'
	}
	return app.assets_prefix
}

@[php_method]
pub fn (app &VSlimApp) make_view() &VSlimView {
	return &VSlimView{
		base_path: app.view_base_path
		assets_prefix: app.assets_prefix()
	}
}

@[php_method]
pub fn (app &VSlimApp) view(template string, data vphp.ZVal) &VSlimResponse {
	mut view := app.make_view()
	return view.render_response(template, data)
}

@[php_method]
pub fn (app &VSlimApp) view_with_layout(template string, layout string, data vphp.ZVal) &VSlimResponse {
	mut view := app.make_view()
	return view.render_response_with_layout(template, layout, data)
}

@[php_method]
pub fn (mut view VSlimView) construct(base_path string, assets_prefix string) &VSlimView {
	view.base_path = base_path.trim_space()
	view.assets_prefix = normalize_assets_prefix(assets_prefix)
	return &view
}

@[php_method]
pub fn (mut view VSlimView) set_base_path(base_path string) &VSlimView {
	view.base_path = base_path.trim_space()
	return &view
}

@[php_method]
pub fn (view &VSlimView) base_path() string {
	return view.base_path
}

@[php_method]
pub fn (mut view VSlimView) set_assets_prefix(prefix string) &VSlimView {
	view.assets_prefix = normalize_assets_prefix(prefix)
	return &view
}

@[php_method]
pub fn (view &VSlimView) assets_prefix() string {
	if view.assets_prefix == '' {
		return '/assets'
	}
	return view.assets_prefix
}

@[php_method]
pub fn (view &VSlimView) asset(path string) string {
	clean := path.trim_space().trim_left('/')
	if clean == '' {
		return view.assets_prefix()
	}
	return '${view.assets_prefix()}/${clean}'
}

@[php_method]
pub fn (view &VSlimView) render(template string, data vphp.ZVal) string {
	scalars, lists := extract_template_data(data)
	return view.render_maps(template, scalars, lists)
}

pub fn (view &VSlimView) render_map(template string, data map[string]string) string {
	return view.render_maps(template, data, map[string][]string{})
}

fn (view &VSlimView) render_maps(template string, scalars map[string]string, lists map[string][]string) string {
	return view.render_map_with_depth(template, scalars, lists, 0)
}

fn (view &VSlimView) render_map_with_depth(template string, scalars map[string]string, lists map[string][]string, depth int) string {
	if depth > 8 {
		return ''
	}
	path := view.resolve_template_path(template)
	source := os.read_file(path) or { return '' }
	return view.render_source(source, scalars, lists, depth)
}

@[php_method]
pub fn (view &VSlimView) render_with_layout(template string, layout string, data vphp.ZVal) string {
	scalars, lists := extract_template_data(data)
	return view.render_maps_with_layout(template, layout, scalars, lists)
}

pub fn (view &VSlimView) render_map_with_layout(template string, layout string, data map[string]string) string {
	return view.render_maps_with_layout(template, layout, data, map[string][]string{})
}

pub fn (view &VSlimView) render_maps_with_layout(template string, layout string, scalars map[string]string, lists map[string][]string) string {
	content := view.render_map_with_depth(template, scalars, lists, 0)
	if content == '' {
		return ''
	}
	layout_path := view.resolve_template_path(layout)
	layout_source := os.read_file(layout_path) or { return content }
	layout_rendered := view.render_source(layout_source, scalars, lists, 0)
	return replace_slot_tokens(layout_rendered, 'content', content)
}

@[php_method]
pub fn (view &VSlimView) render_response(template string, data vphp.ZVal) &VSlimResponse {
	body := view.render(template, data)
	return &VSlimResponse{
		status: 200
		body: body
		content_type: 'text/html; charset=utf-8'
		headers: {
			'content-type': 'text/html; charset=utf-8'
		}
	}
}

@[php_method]
pub fn (view &VSlimView) render_response_with_layout(template string, layout string, data vphp.ZVal) &VSlimResponse {
	body := view.render_with_layout(template, layout, data)
	return &VSlimResponse{
		status: 200
		body: body
		content_type: 'text/html; charset=utf-8'
		headers: {
			'content-type': 'text/html; charset=utf-8'
		}
	}
}

fn (view &VSlimView) render_source(source string, scalars map[string]string, lists map[string][]string, depth int) string {
	mut out := source
	out = view.render_include_tokens(out, scalars, lists, depth)
	out = render_for_blocks(out, scalars, lists)
	out = render_if_blocks(out, scalars, lists)
	out = render_function_tokens(out, scalars, lists)
	out = render_raw_value_tokens(out, scalars)
	for key, value in scalars {
		escaped := escape_html_text(value)
		out = out.replace('{{${key}}}', escaped)
		out = out.replace('{{ ${key} }}', escaped)
	}
	return render_asset_tokens(out, view.assets_prefix())
}

fn (view &VSlimView) render_include_tokens(source string, scalars map[string]string, lists map[string][]string, depth int) string {
	mut out := source
	for {
		start := out.index('{{include:') or { break }
		end := out[start..].index('}}') or { break }
		token_end := start + end + 2
		token := out[start..token_end]
		partial := token.replace('{{include:', '').replace('}}', '').trim_space()
		replacement := view.render_map_with_depth(partial, scalars, lists, depth + 1)
		out = out.replace(token, replacement)
	}
	return out
}

fn (view &VSlimView) resolve_template_path(template string) string {
	clean := template.trim_space()
	if clean == '' {
		return ''
	}
	if clean.starts_with('/') {
		return clean
	}
	if view.base_path == '' {
		return clean
	}
	return os.join_path(view.base_path, clean)
}

fn render_asset_tokens(source string, assets_prefix string) string {
	mut out := source
	for {
		start := out.index('{{asset:') or { break }
		end := out[start..].index('}}') or { break }
		token_end := start + end + 2
		token := out[start..token_end]
		asset_path := token.replace('{{asset:', '').replace('}}', '').trim_space().trim_left('/')
		replacement := if asset_path == '' {
			assets_prefix
		} else {
			'${assets_prefix}/${asset_path}'
		}
		out = out.replace(token, replacement)
	}
	return out
}

fn replace_slot_tokens(source string, slot string, content string) string {
	mut out := source
	slot_token := '{{slot:${slot}}}'
	slot_token_spaced := '{{ slot:${slot} }}'
	if out.contains(slot_token) {
		out = out.replace(slot_token, content)
	}
	if out.contains(slot_token_spaced) {
		out = out.replace(slot_token_spaced, content)
	}
	return out
}

fn render_raw_value_tokens(source string, data map[string]string) string {
	mut out := source
	for key, value in data {
		out = out.replace('{{raw:${key}}}', value)
		out = out.replace('{{ raw:${key} }}', value)
	}
	return out
}

fn render_function_tokens(source string, scalars map[string]string, lists map[string][]string) string {
	mut out := source
	out = replace_function_tokens_by_prefix(out, 'trim:', scalars, lists)
	out = replace_function_tokens_by_prefix(out, 'first:', scalars, lists)
	out = replace_function_tokens_by_prefix(out, 'last:', scalars, lists)
	out = replace_function_tokens_by_prefix(out, 'join:', scalars, lists)
	out = replace_function_tokens_by_prefix(out, 'reduce:', scalars, lists)
	return out
}

fn replace_function_tokens_by_prefix(source string, prefix string, scalars map[string]string, lists map[string][]string) string {
	mut out := source
	open := '{{${prefix}'
	open_spaced := '{{ ${prefix}'
	for {
		mut start := out.index(open) or { -1 }
		mut actual_open := open
		if start == -1 {
			start = out.index(open_spaced) or { break }
			actual_open = open_spaced
		}
		end_rel := out[start..].index('}}') or { break }
		end := start + end_rel + 2
		token := out[start..end]
		payload := token.replace(actual_open, '').replace('}}', '')
		raw := eval_template_function(prefix.trim_right(':'), payload, scalars, lists)
		out = out[..start] + escape_html_text(raw) + out[end..]
	}
	return out
}

fn eval_template_function(fn_name string, payload string, scalars map[string]string, lists map[string][]string) string {
	if payload == '' {
		return ''
	}
	match fn_name {
		'trim' {
			return template_scalar_value(payload, scalars).trim_space()
		}
		'first' {
			items := template_list_values(payload, scalars, lists)
			if items.len == 0 {
				return ''
			}
			return items[0]
		}
		'last' {
			items := template_list_values(payload, scalars, lists)
			if items.len == 0 {
				return ''
			}
			return items[items.len - 1]
		}
		'join' {
			path, sep := split_function_args(payload)
			items := template_list_values(path, scalars, lists)
			return items.join(sep)
		}
		'reduce' {
			path, reducer, seed := split_reduce_args(payload)
			items := template_list_values(path, scalars, lists)
			value, err_msg := reduce_template_values(items, reducer, seed)
			if err_msg != '' && is_view_debug_enabled() {
				return '[vslim.reduce.error reducer="${reducer}" seed="${seed}" reason="${err_msg}"]'
			}
			return value
		}
		else {
			return ''
		}
	}
}

fn reduce_template_values(items []string, reducer string, seed string) (string, string) {
	if items.len == 0 && seed.trim_space() == '' {
		return '', ''
	}
	mut reducer_expr := reducer.trim_space()
	if reducer_expr == '' {
		reducer_expr = 'acc+item'
	}
	if reducer_expr.to_lower() == 'avg' {
		mut sum := 0.0
		mut count := 0
		if seed.trim_space() != '' && is_numeric_template_value(seed.trim_space()) {
			sum = seed.trim_space().f64()
			count = 1
		}
		for item in items {
			raw := item.trim_space()
			if !is_numeric_template_value(raw) {
				continue
			}
			sum += raw.f64()
			count++
		}
		if count == 0 {
			return '', ''
		}
		return format_reduced_number(sum / f64(count)), ''
	}
	mut acc := 0.0
	if seed.trim_space() != '' && is_numeric_template_value(seed.trim_space()) {
		acc = seed.trim_space().f64()
	}
	mut seen := seed.trim_space() != ''
	mut last_err := ''
	for item in items {
		raw := item.trim_space()
		if !is_numeric_template_value(raw) {
			continue
		}
		value := raw.f64()
		if !seen && (reducer_expr.to_lower() == 'min' || reducer_expr.to_lower() == 'max') {
			acc = value
			seen = true
			continue
		}
		if !seen {
			acc = 0.0
			seen = true
		}
		if named := apply_named_reducer(reducer_expr, acc, value) {
			acc = named
		} else {
			acc = eval_reduce_expr(reducer_expr, acc, value) or {
				last_err = err.msg()
				acc
			}
		}
	}
	if !seen {
		return '', last_err
	}
	return format_reduced_number(acc), last_err
}

fn apply_named_reducer(name string, acc f64, item f64) ?f64 {
	match name.trim_space().to_lower() {
		'sum', 'add' { return acc + item }
		'count' { return acc + 1.0 }
		'min' { return if acc < item { acc } else { item } }
		'max' { return if acc > item { acc } else { item } }
		else { return none }
	}
}

struct ReduceExprParser {
	src  string
mut:
	pos  int
	acc  f64
	item f64
}

fn eval_reduce_expr(expr string, acc f64, item f64) !f64 {
	mut p := ReduceExprParser{
		src: expr
		acc: acc
		item: item
	}
	value := p.parse_expr()!
	p.skip_ws()
	if p.pos < p.src.len {
		return error('unexpected token')
	}
	return value
}

fn (mut p ReduceExprParser) parse_expr() !f64 {
	mut left := p.parse_term()!
	for {
		p.skip_ws()
		if p.match_char(`+`) {
			left += p.parse_term()!
		} else if p.match_char(`-`) {
			left -= p.parse_term()!
		} else {
			break
		}
	}
	return left
}

fn (mut p ReduceExprParser) parse_term() !f64 {
	mut left := p.parse_factor()!
	for {
		p.skip_ws()
		if p.match_char(`*`) {
			left *= p.parse_factor()!
		} else if p.match_char(`/`) {
			right := p.parse_factor()!
			if math.abs(right) < 1e-12 {
				return error('division by zero')
			}
			left /= right
		} else {
			break
		}
	}
	return left
}

fn (mut p ReduceExprParser) parse_factor() !f64 {
	p.skip_ws()
	if p.match_char(`+`) {
		return p.parse_factor()!
	}
	if p.match_char(`-`) {
		return -p.parse_factor()!
	}
	if p.match_char(`(`) {
		value := p.parse_expr()!
		p.skip_ws()
		if !p.match_char(`)`) {
			return error('missing )')
		}
		return value
	}
	if ident := p.parse_ident() {
		match ident {
			'acc' { return p.acc }
			'item' { return p.item }
			else { return error('unknown identifier') }
		}
	}
	if num := p.parse_number() {
		return num
	}
	return error('invalid factor')
}

fn (mut p ReduceExprParser) parse_ident() ?string {
	p.skip_ws()
	if p.pos >= p.src.len {
		return none
	}
	first := p.src[p.pos]
	if !first.is_letter() && first != `_` {
		return none
	}
	start := p.pos
	for p.pos < p.src.len {
		ch := p.src[p.pos]
		if ch.is_letter() || ch.is_digit() || ch == `_` {
			p.pos++
			continue
		}
		break
	}
	if p.pos == start {
		return none
	}
	return p.src[start..p.pos]
}

fn (mut p ReduceExprParser) parse_number() ?f64 {
	p.skip_ws()
	start := p.pos
	mut seen_dot := false
	for p.pos < p.src.len {
		ch := p.src[p.pos]
		if ch.is_digit() {
			p.pos++
			continue
		}
		if ch == `.` && !seen_dot {
			seen_dot = true
			p.pos++
			continue
		}
		break
	}
	if p.pos == start {
		return none
	}
	raw := p.src[start..p.pos]
	return raw.f64()
}

fn (mut p ReduceExprParser) skip_ws() {
	for p.pos < p.src.len && p.src[p.pos].is_space() {
		p.pos++
	}
}

fn (mut p ReduceExprParser) match_char(ch u8) bool {
	if p.pos < p.src.len && p.src[p.pos] == ch {
		p.pos++
		return true
	}
	return false
}

fn format_reduced_number(value f64) string {
	as_int := i64(value)
	if math.abs(value - f64(as_int)) < 1e-9 {
		return '${as_int}'
	}
	return '${value}'
}

fn is_numeric_template_value(raw string) bool {
	if raw == '' {
		return false
	}
	mut seen_digit := false
	mut seen_dot := false
	for i, ch in raw {
		if (ch == `+` || ch == `-`) && i == 0 {
			continue
		}
		if ch == `.` {
			if seen_dot {
				return false
			}
			seen_dot = true
			continue
		}
		if !ch.is_digit() {
			return false
		}
		seen_digit = true
	}
	return seen_digit
}

fn split_function_args(payload string) (string, string) {
	if !payload.contains('|') {
		return payload.trim_space(), ','
	}
	path := payload.all_before('|').trim_space()
	sep := payload.all_after('|')
	return path, sep
}

fn split_reduce_args(payload string) (string, string, string) {
	parts := payload.split('|')
	if parts.len == 0 {
		return '', '', ''
	}
	path := parts[0].trim_space()
	reducer := if parts.len >= 2 { parts[1].trim_space() } else { 'acc+item' }
	seed := if parts.len >= 3 { parts[2].trim_space() } else { '' }
	return path, reducer, seed
}

fn is_view_debug_enabled() bool {
	raw := os.getenv_opt('VSLIM_VIEW_DEBUG') or { '' }
	flag := raw.trim_space().to_lower()
	return flag in ['1', 'true', 'yes', 'on']
}

fn template_scalar_value(path string, scalars map[string]string) string {
	key := path.trim_space()
	if key == '' {
		return ''
	}
	if key in scalars {
		return scalars[key]
	}
	alias := alias_template_key(key)
	if alias in scalars {
		return scalars[alias]
	}
	return ''
}

fn template_list_values(path string, scalars map[string]string, lists map[string][]string) []string {
	key := path.trim_space()
	if key == '' {
		return []string{}
	}
	if key in lists {
		unsafe { return lists[key].clone() }
	}
	alias := alias_template_key(key)
	if alias in lists {
		unsafe { return lists[alias].clone() }
	}
	return parse_for_items(template_scalar_value(key, scalars))
}

fn render_if_blocks(source string, scalars map[string]string, lists map[string][]string) string {
	mut out := source
	for {
		start := out.index('{{if:') or { break }
		key_end_rel := out[start..].index('}}') or { break }
		key_end := start + key_end_rel + 2
		open_token := out[start..key_end]
		key := open_token.replace('{{if:', '').replace('}}', '').trim_space()
		close_token := '{{/if}}'
		close_rel := out[key_end..].index(close_token) or { break }
		close_start := key_end + close_rel
		close_end := close_start + close_token.len
		block := out[key_end..close_start]
		else_token := '{{else}}'
		else_token_spaced := '{{ else }}'
		mut true_block := block
		mut false_block := ''
		if else_pos := block.index(else_token) {
			true_block = block[..else_pos]
			false_block = block[else_pos + else_token.len..]
		} else if else_pos := block.index(else_token_spaced) {
			true_block = block[..else_pos]
			false_block = block[else_pos + else_token_spaced.len..]
		}
		mut truthy := false
		if key in lists {
			unsafe { truthy = lists[key].len > 0 }
		} else {
			val := scalars[key] or { '' }
			truthy = is_truthy_template_value(val)
		}
		replacement := if truthy { true_block } else { false_block }
		out = out[..start] + replacement + out[close_end..]
	}
	return out
}

fn render_for_blocks(source string, scalars map[string]string, lists map[string][]string) string {
	mut out := source
	for {
		start := out.index('{{for:') or { break }
		key_end_rel := out[start..].index('}}') or { break }
		key_end := start + key_end_rel + 2
		open_token := out[start..key_end]
		key := open_token.replace('{{for:', '').replace('}}', '').trim_space()
		close_token := '{{/for}}'
		close_rel := out[key_end..].index(close_token) or { break }
		close_start := key_end + close_rel
		close_end := close_start + close_token.len
		block := out[key_end..close_start]
		mut rendered := ''
		object_locals := collect_object_loop_locals_from_block(key, block, scalars)
		if object_locals.len > 0 {
			for local in object_locals {
				rendered += render_for_item_block(block, local, scalars, lists)
			}
		} else {
			items := if key in lists {
				unsafe { lists[key].clone() }
			} else {
				raw := scalars[key] or { '' }
				parse_for_items(raw)
			}
			for idx, item in items {
				mut local := map[string]string{}
				local['index'] = '${idx}'
				local['item'] = item
				if item != '' && is_numeric_path_segment(item) {
					populate_indexed_item_fields(key, item, scalars, mut local)
				}
				rendered += render_for_item_block(block, local, scalars, lists)
			}
		}
		out = out[..start] + rendered + out[close_end..]
	}
	return out
}

fn populate_indexed_item_fields(loop_key string, idx string, scalars map[string]string, mut local map[string]string) {
	prefix_dot := '${loop_key}.${idx}.'
	prefix_bracket := '${loop_key}[${idx}].'
	for key, value in scalars {
		if key.starts_with(prefix_dot) {
			field := key[prefix_dot.len..]
			if field != '' {
				local['item.${field}'] = value
			}
			continue
		}
		if key.starts_with(prefix_bracket) {
			field := key[prefix_bracket.len..]
			if field != '' {
				local['item.${field}'] = value
			}
		}
	}
}

fn render_for_item_block(block string, local map[string]string, scalars map[string]string, lists map[string][]string) string {
	mut merged := scalars.clone()
	for k, v in local {
		merged[k] = v
	}
	mut part := block
	part = render_if_blocks(part, merged, lists)
	part = render_function_tokens(part, merged, lists)
	part = render_raw_value_tokens(part, merged)
	for key, value in local {
		escaped := escape_html_text(value)
		part = part.replace('{{${key}}}', escaped)
		part = part.replace('{{ ${key} }}', escaped)
	}
	return part
}

fn collect_object_loop_locals_from_block(loop_key string, block string, scalars map[string]string) []map[string]string {
	fields := extract_item_field_tokens(block)
	if fields.len == 0 {
		return []map[string]string{}
	}
	mut out := []map[string]string{}
	mut started := false
	for idx in 0 .. 512 {
		mut local := map[string]string{}
		local['index'] = '${idx}'
		local['item'] = ''
		mut found := false
		for field in fields {
			dot_path := '${loop_key}.${idx}.${field}'
			bracket_path := '${loop_key}[${idx}].${field}'
			mut val := template_scalar_value(dot_path, scalars)
			if val == '' {
				val = template_scalar_value(bracket_path, scalars)
			}
			if val != '' {
				local['item.${field}'] = val
				found = true
			}
		}
		if found {
			started = true
			out << local
			continue
		}
		if started {
			break
		}
	}
	return out
}

fn extract_item_field_tokens(block string) []string {
	mut out := []string{}
	mut seen := map[string]bool{}
	mut i := 0
	for i < block.len {
		pos := block[i..].index('item.') or { break }
		start := i + pos + 'item.'.len
		mut end := start
		for end < block.len {
			ch := block[end]
			if ch.is_letter() || ch.is_digit() || ch == `.` || ch == `_` || ch == `[` || ch == `]` {
				end++
				continue
			}
			break
		}
		field := block[start..end].trim_space()
		if field != '' && field !in seen {
			seen[field] = true
			out << field
		}
		i = end
	}
	return out
}

fn extract_template_data(data vphp.ZVal) (map[string]string, map[string][]string) {
	mut scalars := map[string]string{}
	mut lists := map[string][]string{}
	if !data.is_valid() || (!data.is_array() && !data.is_object()) {
		return scalars, lists
	}
	collect_template_values('', data, mut scalars, mut lists, 0)
	return scalars, lists
}

fn collect_template_values(prefix string, value vphp.ZVal, mut scalars map[string]string, mut lists map[string][]string, depth int) {
	if depth > 8 || !value.is_valid() || value.is_null() || value.is_undef() {
		if prefix != '' && prefix !in scalars {
			scalars[prefix] = ''
		}
		return
	}
	if value.is_array() {
		if is_template_list(value) {
			if template_list_has_complex_items(value) {
				if prefix != '' {
					mut idx_items := []string{}
					for i in 0 .. value.array_count() {
						idx_items << '${i}'
					}
					lists[prefix] = idx_items
				}
				for i in 0 .. value.array_count() {
					child := value.array_get(i)
					next_prefix := if prefix == '' { '${i}' } else { '${prefix}.${i}' }
					collect_template_values(next_prefix, child, mut scalars, mut lists, depth + 1)
				}
			} else {
				items := extract_template_list_items(value)
				if prefix != '' {
					lists[prefix] = items
					alias := alias_template_key(prefix)
					if alias != '' && alias != prefix {
						lists[alias] = items
					}
					if prefix !in scalars {
						scalars[prefix] = items.join(',')
					}
					if alias != '' && alias != prefix && alias !in scalars {
						scalars[alias] = items.join(',')
					}
				}
			}
			return
		}
		children := value.fold[map[string]vphp.ZVal](map[string]vphp.ZVal{}, fn (key vphp.ZVal, val vphp.ZVal, mut acc map[string]vphp.ZVal) {
			key_name := key.to_string().trim_space()
			if key_name == '' {
				return
			}
			acc[key_name] = val
		})
		for key_name, child in children {
			next_prefix := if prefix == '' { key_name } else { '${prefix}.${key_name}' }
			collect_template_values(next_prefix, child, mut scalars, mut lists, depth + 1)
		}
		return
	}
	if value.is_object() {
		children := value.fold[map[string]vphp.ZVal](map[string]vphp.ZVal{}, fn (key vphp.ZVal, val vphp.ZVal, mut acc map[string]vphp.ZVal) {
			key_name := key.to_string().trim_space()
			if key_name == '' {
				return
			}
			acc[key_name] = val
		})
		for key_name, child in children {
			next_prefix := if prefix == '' { key_name } else { '${prefix}.${key_name}' }
			collect_template_values(next_prefix, child, mut scalars, mut lists, depth + 1)
		}
		return
	}
	if prefix != '' {
		scalars[prefix] = to_template_scalar(value)
		alias := alias_template_key(prefix)
		if alias != '' && alias != prefix {
			scalars[alias] = scalars[prefix]
		}
	}
}

fn alias_template_key(path string) string {
	if path == '' {
		return path
	}
	parts := path.split('.')
	mut out := []string{}
	for idx, part in parts {
		if part == '' {
			continue
		}
		is_num := is_numeric_path_segment(part)
		if is_num {
			if out.len == 0 {
				out << '[${part}]'
			} else {
				out[out.len - 1] = out[out.len - 1] + '[${part}]'
			}
			continue
		}
		if idx == 0 {
			out << part
		} else {
			out << '.${part}'
		}
	}
	return out.join('')
}

fn is_numeric_path_segment(part string) bool {
	if part.len == 0 {
		return false
	}
	for ch in part {
		if !ch.is_digit() {
			return false
		}
	}
	return true
}

fn is_template_list(value vphp.ZVal) bool {
	if !value.is_array() {
		return false
	}
	is_list := vphp.call_php('array_is_list', [value])
	return is_list.is_valid() && is_list.to_bool()
}

fn extract_template_list_items(value vphp.ZVal) []string {
	mut items := []string{}
	for i in 0 .. value.array_count() {
		items << to_template_scalar(value.array_get(i))
	}
	return items
}

fn template_list_has_complex_items(value vphp.ZVal) bool {
	for i in 0 .. value.array_count() {
		item := value.array_get(i)
		if item.is_array() || item.is_object() {
			return true
		}
	}
	return false
}

fn to_template_scalar(value vphp.ZVal) string {
	if !value.is_valid() || value.is_null() || value.is_undef() {
		return ''
	}
	if value.is_bool() {
		return if value.to_bool() { '1' } else { '0' }
	}
	return value.to_string()
}

fn parse_for_items(raw string) []string {
	mut out := []string{}
	if raw.trim_space() == '' {
		return out
	}
	for part in raw.split(',') {
		item := part.trim_space()
		if item != '' {
			out << item
		}
	}
	return out
}

fn is_truthy_template_value(raw string) bool {
	value := raw.trim_space().to_lower()
	if value == '' {
		return false
	}
	return value !in ['0', 'false', 'no', 'off', 'null']
}

fn escape_html_text(input string) string {
	mut out := input
	out = out.replace('&', '&amp;')
	out = out.replace('<', '&lt;')
	out = out.replace('>', '&gt;')
	out = out.replace('"', '&quot;')
	out = out.replace("'", '&#39;')
	return out
}

fn normalize_assets_prefix(prefix string) string {
	mut clean := prefix.trim_space()
	if clean == '' {
		return '/assets'
	}
	if !clean.starts_with('/') {
		clean = '/${clean}'
	}
	return clean.trim_right('/')
}

@[php_method]
pub fn (mut c VSlimController) construct(app &VSlimApp) &VSlimController {
	c.app_ref = app
	return &c
}

@[php_method]
pub fn (mut c VSlimController) set_app(app &VSlimApp) &VSlimController {
	c.app_ref = app
	return &c
}

@[php_method]
pub fn (mut c VSlimController) set_view(view &VSlimView) &VSlimController {
	c.view_ref = view
	return &c
}

@[php_method]
pub fn (mut c VSlimController) view() &VSlimView {
	if c.view_ref != unsafe { nil } {
		return c.view_ref
	}
	if c.app_ref != unsafe { nil } {
		c.view_ref = c.app_ref.make_view()
		return c.view_ref
	}
	c.view_ref = &VSlimView{
		base_path: ''
		assets_prefix: '/assets'
	}
	return c.view_ref
}

@[php_method]
pub fn (mut c VSlimController) render(template string, data vphp.ZVal) &VSlimResponse {
	mut view := c.view()
	return view.render_response(template, data)
}

@[php_method]
pub fn (mut c VSlimController) render_with_layout(template string, layout string, data vphp.ZVal) &VSlimResponse {
	mut view := c.view()
	return view.render_response_with_layout(template, layout, data)
}

@[php_method]
pub fn (c &VSlimController) url_for(name string, params vphp.ZVal) string {
	if c.app_ref == unsafe { nil } {
		return ''
	}
	return c.app_ref.url_for(name, params)
}

@[php_method]
pub fn (c &VSlimController) url_for_query(name string, params vphp.ZVal, query vphp.ZVal) string {
	if c.app_ref == unsafe { nil } {
		return ''
	}
	return c.app_ref.url_for_query(name, params, query)
}

@[php_method]
pub fn (c &VSlimController) text(body string, status int) &VSlimResponse {
	return &VSlimResponse{
		status: status
		body: body
		content_type: 'text/plain; charset=utf-8'
		headers: {
			'content-type': 'text/plain; charset=utf-8'
		}
	}
}

@[php_method]
pub fn (c &VSlimController) json(body string, status int) &VSlimResponse {
	return &VSlimResponse{
		status: status
		body: body
		content_type: 'application/json; charset=utf-8'
		headers: {
			'content-type': 'application/json; charset=utf-8'
		}
	}
}

@[php_method]
pub fn (c &VSlimController) redirect(location string, status int) &VSlimResponse {
	mut res := VSlimResponse{
		status: if status == 0 { 302 } else { status }
		body: ''
		content_type: 'text/plain; charset=utf-8'
		headers: {
			'content-type': 'text/plain; charset=utf-8'
		}
	}
	res.set_header('location', location)
	return to_vslim_response(res)
}

@[php_method]
pub fn (c &VSlimController) redirect_to(name string, params vphp.ZVal, status int) &VSlimResponse {
	location := c.url_for(name, params)
	if location == '' {
		return c.text('route not found', 404)
	}
	return c.redirect(location, status)
}

@[php_method]
pub fn (c &VSlimController) redirect_to_query(name string, params vphp.ZVal, query vphp.ZVal, status int) &VSlimResponse {
	location := c.url_for_query(name, params, query)
	if location == '' {
		return c.text('route not found', 404)
	}
	return c.redirect(location, status)
}
