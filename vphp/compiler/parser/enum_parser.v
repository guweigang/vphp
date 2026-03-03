module parser

import v.ast
import compiler.repr

pub fn parse_enum_decl(stmt ast.Stmt, table &ast.Table) ?&repr.PhpEnumRepr {
	if stmt !is ast.EnumDecl {
		return none
	}
	enum_decl := stmt as ast.EnumDecl
	mut enum_repr := repr.new_enum_repr()
	if !enum_decl.attrs.any(it.name == 'php_enum') {
		return none
	}

	enum_repr.name = enum_decl.name.all_after('.')
	if attr := enum_decl.attrs.find_first('php_enum') {
		enum_repr.php_name = if attr.arg != '' { attr.arg } else { enum_repr.name }
	} else {
		enum_repr.php_name = enum_repr.name
	}

	mut next_value := 0
	for field in enum_decl.fields {
		if field.has_expr {
			explicit := parse_enum_case_value(field.expr) or {
				enum_repr.parse_err = 'php enum ${enum_repr.php_name} only supports integer literal cases right now; field `${field.name}` is unsupported'
				return enum_repr
			}
			next_value = explicit
		}
		enum_repr.cases << repr.PhpEnumCase{
			name: field.name
			value: next_value.str()
		}
		next_value++
	}

	return enum_repr
}
