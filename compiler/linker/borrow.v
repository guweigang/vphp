module linker

import v.ast
import compiler.parser as cparser
import compiler.repr

pub fn resolve_and_apply_borrow_returns(mut elements []repr.PhpRepr, stmts []ast.Stmt, table &ast.Table, field_types map[string]string) {
	method_profiles := collect_method_borrow_profiles(stmts, table, field_types)
	resolved_borrowed := resolve_method_borrowed_returns(method_profiles)
	apply_resolved_borrowed_returns(mut elements, resolved_borrowed)
}

pub fn resolve_borrowed_methods(stmts []ast.Stmt, table &ast.Table, field_types map[string]string) map[string]bool {
	profiles := collect_method_borrow_profiles(stmts, table, field_types)
	return resolve_method_borrowed_returns(profiles)
}

fn collect_method_borrow_profiles(stmts []ast.Stmt, table &ast.Table, field_types map[string]string) []cparser.MethodBorrowProfile {
	mut profiles := []cparser.MethodBorrowProfile{}
	for stmt in stmts {
		if stmt is ast.FnDecl {
			if profile := cparser.build_method_borrow_profile(stmt, table, field_types) {
				profiles << profile
			}
		}
	}
	return profiles
}

pub fn collect_method_return_types(stmts []ast.Stmt, table &ast.Table, field_types map[string]string) map[string]string {
	method_profiles := collect_method_borrow_profiles(stmts, table, field_types)
	mut out := map[string]string{}
	for profile in method_profiles {
		key := '${profile.receiver_type}::${profile.method_name}'
		out[key] = profile.return_type
	}
	return out
}

fn resolve_method_borrowed_returns(profiles []cparser.MethodBorrowProfile) map[string]bool {
	mut borrowed_methods := map[string]bool{}
	mut delegated_targets := map[string]string{}
	for profile in profiles {
		key := '${profile.receiver_type}::${profile.method_name}'
		borrowed_methods[key] = profile.direct_borrowed
		if profile.delegated_target_type != '' && profile.delegated_target_method != '' {
			delegated_targets[key] = '${profile.delegated_target_type}::${profile.delegated_target_method}'
		}
	}
	for {
		mut changed := false
		for method_key, target_key in delegated_targets {
			if borrowed_methods[method_key] or { false } {
				continue
			}
			if borrowed_methods[target_key] or { false } {
				borrowed_methods[method_key] = true
				changed = true
			}
		}
		if !changed {
			break
		}
	}
	return borrowed_methods
}

fn apply_resolved_borrowed_returns(mut elements []repr.PhpRepr, resolved_borrowed map[string]bool) {
	for i in 0 .. elements.len {
		mut el := elements[i]
		if mut el is repr.PhpClassRepr {
			for mi, method in el.methods {
				if method.v_name == '' {
					continue
				}
				key := '${el.name}::${method.v_name}'
				if resolved_borrowed[key] or { false } {
					el.methods[mi].borrowed_return = true
				}
			}
			elements[i] = el
		}
	}
}
