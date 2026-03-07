module main

import os
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
	out = render_if_blocks(out, scalars, lists)
	out = render_for_blocks(out, scalars, lists)
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
		items := if key in lists {
			unsafe { lists[key].clone() }
		} else {
			raw := scalars[key] or { '' }
			parse_for_items(raw)
		}
		mut rendered := ''
		for idx, item in items {
			mut part := block
			escaped_item := escape_html_text(item)
			part = part.replace('{{item}}', escaped_item)
			part = part.replace('{{ item }}', escaped_item)
			part = part.replace('{{index}}', '${idx}')
			part = part.replace('{{ index }}', '${idx}')
			part = part.replace('{{raw:item}}', item)
			part = part.replace('{{ raw:item }}', item)
			rendered += part
		}
		out = out[..start] + rendered + out[close_end..]
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
			items := extract_template_list_items(value)
			if prefix != '' {
				lists[prefix] = items
				if prefix !in scalars {
					scalars[prefix] = items.join(',')
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
	}
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
