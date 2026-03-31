module parser

import v.ast

fn strip_module(mut_typ_name string) string {
	return mut_typ_name.replace('main.', '')
}

fn is_context_type(type_name string) bool {
	return type_name == 'Context' || type_name == 'vphp.Context'
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
