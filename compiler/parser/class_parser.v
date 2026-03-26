module parser

import v.ast
import compiler.repr

fn normalize_attr_value(raw string) string {
	return raw.trim_space().trim("'\"")
}

fn parse_attr_list(raw string) []string {
	mut out := []string{}
	for part in raw.split(',') {
		name := normalize_attr_value(part)
		if name != '' {
			out << name
		}
	}
	return out
}

fn parse_attr_args(raw string) []repr.PhpAttributeArg {
	mut out := []repr.PhpAttributeArg{}
	mut current := []rune{}
	mut quote := rune(0)
	mut escaped := false
	for ch in raw.runes() {
		if escaped {
			current << ch
			escaped = false
			continue
		}
		if quote != rune(0) {
			if ch == `\\` {
				escaped = true
				current << ch
				continue
			}
			current << ch
			if ch == quote {
				quote = rune(0)
			}
			continue
		}
		if ch == `"` || ch == `'` {
			quote = ch
			current << ch
			continue
		}
		if ch == `,` {
			token := current.string().trim_space()
			if token != '' {
				out << parse_attr_arg(token)
			}
			current = []rune{}
			continue
		}
		current << ch
	}
	token := current.string().trim_space()
	if token != '' {
		out << parse_attr_arg(token)
	}
	return out
}

fn decode_attr_string(raw string) string {
	if raw.len < 2 {
		return raw
	}
	quote := raw[0]
	if (quote != `'` && quote != `"`) || raw[raw.len - 1] != quote {
		return raw
	}
	mut out := []rune{}
	mut escaped := false
	for ch in raw[1..raw.len - 1].runes() {
		if escaped {
			out << match ch {
				`n` { `\n` }
				`t` { `\t` }
				`r` { `\r` }
				`\\` { `\\` }
				`'` { `'` }
				`"` { `"` }
				else { ch }
			}
			escaped = false
			continue
		}
		if ch == `\\` {
			escaped = true
			continue
		}
		out << ch
	}
	return out.string()
}

fn parse_attr_arg(token string) repr.PhpAttributeArg {
	value := token.trim_space()
	lower := value.to_lower()
	if (value.starts_with("'") && value.ends_with("'")) || (value.starts_with('"') && value.ends_with('"')) {
		return repr.PhpAttributeArg{
			kind: 'string'
			value: decode_attr_string(value)
		}
	}
	if lower == 'true' || lower == 'false' {
		return repr.PhpAttributeArg{
			kind: 'bool'
			value: lower
		}
	}
	if lower == 'null' {
		return repr.PhpAttributeArg{
			kind: 'null'
			value: ''
		}
	}
	if value.contains('.') && (value.f64() != 0.0 || value == '0.0' || value == '-0.0') {
		return repr.PhpAttributeArg{
			kind: 'float'
			value: value
		}
	}
	if value.i64() != 0 || value == '0' || value == '-0' {
		return repr.PhpAttributeArg{
			kind: 'int'
			value: value
		}
	}
	return repr.PhpAttributeArg{
		kind: 'string'
		value: value
	}
}

fn parse_php_attr(raw string) ?repr.PhpAttributeRepr {
	normalized := normalize_attr_value(raw)
	if normalized == '' {
		return none
	}
	if !normalized.contains('(') {
		return repr.PhpAttributeRepr{
			name: normalized
			args: []repr.PhpAttributeArg{}
		}
	}
	open := normalized.index_after('(', 0) or { return none }
	if !normalized.ends_with(')') || open <= 0 {
		return none
	}
	name := normalized[..open].trim_space()
	if name == '' {
		return none
	}
	args_raw := normalized[open + 1..normalized.len - 1]
	return repr.PhpAttributeRepr{
		name: name
		args: parse_attr_args(args_raw)
	}
}

pub fn parse_class_decl(stmt ast.Stmt, table &ast.Table) ?&repr.PhpClassRepr {
	if stmt !is ast.StructDecl {
		return none
	}
	struct_decl := stmt as ast.StructDecl
	mut cls := repr.new_class_repr()
	if !struct_decl.attrs.any(it.name == 'php_class' || it.name == 'php_trait') {
		return none
	}
	cls.is_trait = struct_decl.attrs.any(it.name == 'php_trait')

	cls.name = struct_decl.name.all_after('.')
	if attr := struct_decl.attrs.find_first(if cls.is_trait { 'php_trait' } else { 'php_class' }) {
		cls.php_name = if attr.arg != '' { attr.arg } else { cls.name }
	} else {
		cls.php_name = cls.name
	}
	if attr := struct_decl.attrs.find_first('php_extends') {
		cls.parent = normalize_attr_value(attr.arg)
	}
	for attr in struct_decl.attrs {
		if attr.name == 'php_const' {
			cls.shadow_const_name = attr.arg
		} else if attr.name == 'php_static' {
			cls.shadow_static_name = attr.arg
		} else if attr.name == 'php_abstract' {
			cls.is_abstract = true
		} else if attr.name == 'php_implements' {
			cls.implements_attr << parse_attr_list(attr.arg)
		} else if attr.name == 'php_attr' {
			if php_attr := parse_php_attr(attr.arg) {
				cls.attributes << php_attr
			}
		}
	}
	if struct_decl.is_implements {
		for iface in struct_decl.implements_types {
			name := strip_module(table.get_type_name(iface.typ))
			if name != '' {
				cls.implements_v << name
			}
		}
	}
	for embed in struct_decl.embeds {
		embed_name := strip_module(table.get_type_name(embed.typ))
		if embed_name != '' {
			cls.embeds_v << embed_name
		}
	}
	for field in struct_decl.fields {
		type_name := table.get_type_name(field.typ)
		mut is_static := field.attrs.any(it.name == 'php_static')
		if !is_static {
			for comment in field.comments {
				if comment.text.contains('@[php_static]') {
					is_static = true
					break
				}
			}
		}

		cls.properties << repr.PhpClassProp{
			name: field.name
			v_type: type_name
			visibility: if field.is_pub { 'public' } else { 'protected' }
			is_static: is_static
			is_mut: field.is_mut
		}
	}
	return cls
}

pub fn add_class_method(mut cls repr.PhpClassRepr, stmt ast.FnDecl, table &ast.Table) {
	if stmt.name == 'free' && stmt.is_method {
		cls.has_free_method = true
	}
	if !stmt.attrs.any(it.name == 'php_method') {
		return
	}

	mut has_export := false
	mut php_name := stmt.name
	for attr in stmt.attrs {
		if attr.name == 'export' && attr.arg != '' {
			has_export = true
		}
		if attr.name == 'php_method' && attr.arg != '' {
			php_name = attr.arg
		}
	}

	is_abstract := stmt.attrs.any(it.name == 'php_abstract')
	mut args := []repr.PhpArg{}
	start_idx := if stmt.is_method { 1 } else { 0 }

	for i := start_idx; i < stmt.params.len; i++ {
		param := stmt.params[i]
		args << repr.PhpArg{
			name: param.name
			v_type: strip_module(table.get_type_name(param.typ))
		}
	}

	ret_type := strip_module(table.type_to_str(stmt.return_type))
	cls.methods << repr.PhpMethodRepr{
		name: php_name
		v_name: stmt.name
		v_c_func: '${cls.name}_${stmt.name}'
		is_static: false
		return_type: ret_type
		visibility: if stmt.is_pub { 'public' } else { 'protected' }
		args: args
		has_export: has_export
		is_abstract: is_abstract
	}
}

pub fn add_class_static_method(mut cls repr.PhpClassRepr, stmt ast.FnDecl, table &ast.Table, method_name string) {
	if !stmt.attrs.any(it.name == 'php_method') {
		return
	}

	mut has_export := false
	mut php_name := method_name
	for attr in stmt.attrs {
		if attr.name == 'export' && attr.arg != '' {
			has_export = true
		}
		if attr.name == 'php_method' && attr.arg != '' {
			php_name = attr.arg
		}
	}

	is_abstract := stmt.attrs.any(it.name == 'php_abstract')
	mut args := []repr.PhpArg{}
	for param in stmt.params {
		args << repr.PhpArg{
			name: param.name
			v_type: strip_module(table.get_type_name(param.typ))
		}
	}

	ret_type := strip_module(table.type_to_str(stmt.return_type))
	cls.methods << repr.PhpMethodRepr{
		name: php_name
		v_name: method_name
		v_c_func: '${cls.name}_${method_name}'
		is_static: true
		return_type: ret_type
		visibility: if stmt.is_pub { 'public' } else { 'protected' }
		args: args
		has_export: has_export
		is_abstract: is_abstract
	}
}
