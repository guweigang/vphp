module compiler

import compiler.builder
import compiler.php_types
import compiler.repr

pub struct CGenerator {
pub:
	ext_name          string
	class_ce_by_type  map[string]string
	class_php_by_type map[string]string
}

fn (g CGenerator) build_func_export(f &repr.PhpFuncRepr) builder.ExportFragments {
	mut fragments := g.build_func(f).export_fragments()
	fragments.implementations = g.gen_func_c(f)
	return fragments
}

fn (g CGenerator) build_interface_export(r &repr.PhpInterfaceRepr) builder.ExportFragments {
	mut fragments := g.build_interface_type(r).export_fragments()
	fragments.implementations = g.gen_interface_c(r)
	return fragments
}

fn (g CGenerator) build_enum_export(r &repr.PhpEnumRepr) builder.ExportFragments {
	mut fragments := g.build_enum_type(r).export_fragments()
	fragments.implementations = g.gen_enum_c(r)
	return fragments
}

fn (g CGenerator) build_class_export(r &repr.PhpClassRepr) builder.ExportFragments {
	has_init := r.methods.any(is_constructor_method(it.name))
	mut fragments := g.build_class_type(r, has_init).export_fragments()
	fragments.implementations = g.gen_class_c(r)
	return fragments
}

// 模板变量替换
fn render_tpl(tpl string, vars map[string]string) string {
	mut out := tpl
	for k, v in vars {
		out = out.replace('{{${k}}}', v)
	}
	return out
}

// 将 V 字符串中的 \ 转义为 C 字符串字面量的 \\
fn c_string_escape(s string) string {
	return s.replace('\\', '\\\\')
}

fn (g CGenerator) ce_var_for_type(v_type string) string {
	key := php_types.normalize_export_type_key(v_type)
	if key in g.class_ce_by_type {
		return g.class_ce_by_type[key]
	}
	if key.contains('\\') {
		return '${key.replace('\\', '_').to_lower()}_ce'
	}
	return '${key.to_lower()}_ce'
}

fn (g CGenerator) php_name_for_type(v_type string) string {
	key := php_types.normalize_export_type_key(v_type)
	if key in g.class_php_by_type {
		return g.class_php_by_type[key]
	}
	return ''
}
