module repr

import v.ast

pub struct PhpInterfaceRepr {
pub mut:
	name     string
	php_name string
	methods  []PhpMethodRepr
}

pub fn (r PhpInterfaceRepr) c_name() string {
	return r.php_name.replace('\\', '_')
}

pub fn new_interface_repr() &PhpInterfaceRepr {
	return &PhpInterfaceRepr{}
}

pub fn (mut r PhpInterfaceRepr) parse(stmt ast.Stmt, table &ast.Table) bool {
	if stmt is ast.InterfaceDecl {
		if !stmt.attrs.any(it.name == 'php_interface') {
			return false
		}

		r.name = stmt.name.all_after('.')
		if attr := stmt.attrs.find_first('php_interface') {
			r.php_name = if attr.arg != '' { attr.arg } else { r.name }
		} else {
			r.php_name = r.name
		}

		for method in stmt.methods {
			mut args := []PhpArg{}
			for param in method.params {
				args << PhpArg{
					name: param.name
					v_type: strip_module(table.get_type_name(param.typ))
				}
			}
			r.methods << PhpMethodRepr{
				name: method.name
				v_name: method.name
				v_c_func: ''
				is_static: false
				return_type: strip_module(table.type_to_str(method.return_type))
				args: args
				has_export: false
				visibility: 'public'
				is_abstract: true
			}
		}
		return true
	}
	return false
}
