module compiler

import compiler.repr

fn (g CGenerator) gen_interface_c(r &repr.PhpInterfaceRepr) []string {
	mut c := []string{}
	class_builder := g.build_interface_type(r)
	c << class_builder.render_impl_prelude()
	c << class_builder.render_impl_postlude()
	return c
}

fn (g CGenerator) gen_enum_c(r &repr.PhpEnumRepr) []string {
	mut c := []string{}
	class_builder := g.build_enum_type(r)

	// PHP 8.1 native enum: only need ce declaration + empty methods array.
	// No PHP_METHOD implementations needed — native enums provide their own
	// methods (cases, from, tryFrom) via zend_register_internal_enum().
	c << class_builder.render_impl_prelude()
	c << class_builder.render_impl_postlude()

	return c
}
