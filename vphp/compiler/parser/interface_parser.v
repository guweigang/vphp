module parser

import v.ast
import compiler.repr

pub fn parse_interface_decl(stmt ast.Stmt, table &ast.Table) ?&repr.PhpInterfaceRepr {
	if stmt !is ast.InterfaceDecl {
		return none
	}
	interface_decl := stmt as ast.InterfaceDecl
	mut iface := repr.new_interface_repr()
	if !interface_decl.attrs.any(it.name == 'php_interface') {
		return none
	}

	iface.name = interface_decl.name.all_after('.')
	if attr := interface_decl.attrs.find_first('php_interface') {
		iface.php_name = if attr.arg != '' { attr.arg } else { iface.name }
	} else {
		iface.php_name = iface.name
	}

	for method in interface_decl.methods {
		mut args := []repr.PhpArg{}
		for i, param in method.params {
			param_type := strip_module(table.get_type_name(param.typ))
			// V interface AST includes an implicit receiver-like first param (`x`).
			// It must not leak into PHP interface arginfo, otherwise signatures become save($x).
			if i == 0 && param.name == 'x' && (param_type == '' || param_type == iface.name) {
				continue
			}
			args << repr.PhpArg{
				name: param.name
				v_type: param_type
			}
		}
		iface.methods << repr.PhpMethodRepr{
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
	return iface
}
