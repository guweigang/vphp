module compiler

import compiler.builder
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
