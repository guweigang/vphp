module parser

import v.ast
import compiler.php_types
import compiler.repr

pub fn collect_params_structs(stmts []ast.Stmt, table &ast.Table) map[string]repr.PhpParamsStruct {
	mut out := map[string]repr.PhpParamsStruct{}
	for stmt in stmts {
		if stmt !is ast.StructDecl {
			continue
		}
		struct_decl := stmt as ast.StructDecl
		if !struct_decl.attrs.any(it.name == 'params') {
			continue
		}
		struct_name := strip_module(struct_decl.name)
		mut params_struct := repr.PhpParamsStruct{
			name: struct_name
		}
		for field in struct_decl.fields {
			field_type := strip_module(table.type_to_str(field.typ))
			default_spec := php_types.PhpDefaultSpec.from_v_type(field_type)
			v_default := if field.has_default_expr {
				v_default_literal(field.default_expr, default_spec)
			} else {
				default_spec.v_expr
			}
			params_struct.fields << repr.PhpParamsField{
				name:        field.name
				v_type:      field_type
				v_default:   v_default
				php_default: default_spec.php_expr_for_v_default(v_default)
			}
		}
		out[struct_name] = params_struct
	}
	return out
}

fn v_default_literal(expr ast.Expr, default_spec php_types.PhpDefaultSpec) string {
	match expr {
		ast.StringLiteral {
			return "'${expr.val.replace("'", "\\'")}'"
		}
		ast.IntegerLiteral {
			return expr.val
		}
		ast.FloatLiteral {
			return expr.val
		}
		ast.BoolLiteral {
			return if expr.val { 'true' } else { 'false' }
		}
		ast.PrefixExpr {
			if expr.op == .minus {
				return '-' + v_default_literal(expr.right, default_spec)
			}
		}
		else {}
	}
	return default_spec.v_expr
}
