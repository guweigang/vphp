module compiler

import compiler.repr

// ---- Func V Glue ----
fn (g VGenerator) gen_func_glue(f &repr.PhpFuncRepr) []string {
	return FunctionGlue.new(f, g.params_structs).render_lines()
}
