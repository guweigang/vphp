module parser

import v.ast
import compiler.repr

pub fn parse_constant_decl(stmt ast.Stmt, table &ast.Table) ?&repr.PhpConstRepr {
	if stmt !is ast.ConstDecl {
		return none
	}
	const_decl := stmt as ast.ConstDecl
	mut con := repr.new_const_repr()
	con.has_php_const = const_decl.attrs.any(it.name == 'php_const')

	for field in const_decl.fields {
		if field.name.ends_with('ext_config') {
			continue
		}

		raw_name := field.name.all_after('.')
		con.name = raw_name.to_upper()

		if field.expr is ast.StringLiteral {
			con.value = (field.expr as ast.StringLiteral).val
			con.const_type = 'string'
		} else if field.expr is ast.IntegerLiteral {
			con.value = (field.expr as ast.IntegerLiteral).val
			con.const_type = 'int'
		} else if field.expr is ast.FloatLiteral {
			con.value = (field.expr as ast.FloatLiteral).val
			con.const_type = 'f64'
		} else if field.expr is ast.BoolLiteral {
			con.value = if (field.expr as ast.BoolLiteral).val { '1' } else { '0' }
			con.const_type = 'bool'
		} else if field.expr is ast.StructInit {
			expr := field.expr as ast.StructInit
			con.const_type = 'struct'
			con.name = raw_name
			mut v_type := table.get_type_name(expr.typ)
			if v_type.contains('.') {
				v_type = v_type.all_after('.')
			}
			con.v_type = v_type

			for f in expr.init_fields {
				mut sub := repr.PhpConstRepr{
					name: f.name.to_upper()
				}
				if f.expr is ast.StringLiteral {
					sub.value = (f.expr as ast.StringLiteral).val
					sub.const_type = 'string'
				} else if f.expr is ast.IntegerLiteral {
					sub.value = (f.expr as ast.IntegerLiteral).val
					sub.const_type = 'int'
				} else if f.expr is ast.FloatLiteral {
					sub.value = (f.expr as ast.FloatLiteral).val
					sub.const_type = 'f64'
				} else if f.expr is ast.BoolLiteral {
					sub.value = if (f.expr as ast.BoolLiteral).val { '1' } else { '0' }
					sub.const_type = 'bool'
				}
				con.fields[f.name] = sub
			}
		} else {
			continue
		}
		return con
	}

	return none
}
