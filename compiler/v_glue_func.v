module compiler

import compiler.repr

// ---- Func V Glue ----
fn (g VGenerator) gen_func_glue(f &repr.PhpFuncRepr) []string {
	return FunctionGlue.new(f, g.params_structs).render_lines()
}

fn (g VGenerator) gen_func_glue_for_module(f &repr.PhpFuncRepr, module_name string) []string {
	return FunctionGlue.new_for_module(f, g.params_structs, module_name).render_lines()
}
