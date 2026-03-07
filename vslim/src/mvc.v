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
	return view.render_map(template, data.to_string_map())
}

pub fn (view &VSlimView) render_map(template string, data map[string]string) string {
	return view.render_map_with_depth(template, data, 0)
}

fn (view &VSlimView) render_map_with_depth(template string, data map[string]string, depth int) string {
	if depth > 8 {
		return ''
	}
	path := view.resolve_template_path(template)
	source := os.read_file(path) or { return '' }
	return view.render_source(source, data, depth)
}

@[php_method]
pub fn (view &VSlimView) render_with_layout(template string, layout string, data vphp.ZVal) string {
	return view.render_map_with_layout(template, layout, data.to_string_map())
}

pub fn (view &VSlimView) render_map_with_layout(template string, layout string, data map[string]string) string {
	content := view.render_map_with_depth(template, data, 0)
	if content == '' {
		return ''
	}
	layout_path := view.resolve_template_path(layout)
	layout_source := os.read_file(layout_path) or { return content }
	layout_rendered := view.render_source(layout_source, data, 0)
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

fn (view &VSlimView) render_source(source string, data map[string]string, depth int) string {
	mut out := source
	out = view.render_include_tokens(out, data, depth)
	out = render_raw_value_tokens(out, data)
	for key, value in data {
		escaped := escape_html_text(value)
		out = out.replace('{{${key}}}', escaped)
		out = out.replace('{{ ${key} }}', escaped)
	}
	return render_asset_tokens(out, view.assets_prefix())
}

fn (view &VSlimView) render_include_tokens(source string, data map[string]string, depth int) string {
	mut out := source
	for {
		start := out.index('{{include:') or { break }
		end := out[start..].index('}}') or { break }
		token_end := start + end + 2
		token := out[start..token_end]
		partial := token.replace('{{include:', '').replace('}}', '').trim_space()
		replacement := view.render_map_with_depth(partial, data, depth + 1)
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
