module compiler

import v.ast

pub struct PhpEnumRepr {
pub mut:
	name      string
	php_name  string
	cases     []PhpEnumCase
	parse_err string
}

pub struct PhpEnumCase {
pub:
	name  string
	value string
}

pub fn (r PhpEnumRepr) c_name() string {
	return r.php_name.replace('\\', '_')
}

fn new_enum_repr() &PhpEnumRepr {
	return &PhpEnumRepr{}
}

fn (mut r PhpEnumRepr) parse(stmt ast.Stmt, _ &ast.Table) bool {
	if stmt is ast.EnumDecl {
		if !stmt.attrs.any(it.name == 'php_enum') {
			return false
		}

		r.name = stmt.name.all_after('.')
		if attr := stmt.attrs.find_first('php_enum') {
			r.php_name = if attr.arg != '' { attr.arg } else { r.name }
		} else {
			r.php_name = r.name
		}

		mut next_value := 0
		for field in stmt.fields {
			if field.has_expr {
				explicit := parse_enum_case_value(field.expr) or {
					r.parse_err = 'php enum ${r.php_name} only supports integer literal cases right now; field `${field.name}` is unsupported'
					return true
				}
				next_value = explicit
			}

			r.cases << PhpEnumCase{
				name: field.name
				value: next_value.str()
			}
			next_value++
		}
		return true
	}
	return false
}

fn parse_enum_case_value(expr ast.Expr) !int {
	if expr is ast.IntegerLiteral {
		return expr.val.int()
	}
	if expr is ast.PrefixExpr {
		if expr.op == .minus && expr.right is ast.IntegerLiteral {
			return -(expr.right as ast.IntegerLiteral).val.int()
		}
	}
	return error('unsupported enum literal expression')
}
