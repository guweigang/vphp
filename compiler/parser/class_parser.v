module parser

import v.ast
import compiler.repr

pub struct MethodBorrowProfile {
pub:
	receiver_type           string
	method_name             string
	return_type             string
	direct_borrowed         bool
	delegated_target_type   string
	delegated_target_method string
}

fn normalize_attr_value(raw string) string {
	return raw.trim_space().trim('\'"')
}

fn parse_attr_list(raw string) []string {
	mut out := []string{}
	for part in raw.split(',') {
		name := normalize_attr_value(part)
		if name != '' {
			out << name
		}
	}
	return out
}

fn parse_php_arg_types(raw string) map[string]string {
	mut out := map[string]string{}
	for part in raw.split(',') {
		entry := part.trim_space()
		if entry == '' {
			continue
		}
		if idx := entry.index('=') {
			arg_name := entry[..idx].trim_space()
			arg_type := entry[idx + 1..].trim_space()
			if arg_name != '' && arg_type != '' {
				out[arg_name] = arg_type
			}
		}
	}
	return out
}

fn parse_php_prop_attr(raw string) ?repr.PhpClassProp {
	value := normalize_attr_value(raw)
	if value == '' {
		return none
	}
	mut name := value
	mut v_type := 'mixed'
	if value.contains(':') {
		name = value.all_before(':').trim_space()
		v_type = value.all_after(':').trim_space()
	}
	if name == '' {
		return none
	}
	return repr.PhpClassProp{
		name:             name
		v_type:           if v_type == '' { 'mixed' } else { v_type }
		visibility:       'public'
		is_static:        false
		is_mut:           true
		is_property_only: true
	}
}

fn parse_attr_args(raw string) []repr.PhpAttributeArg {
	mut out := []repr.PhpAttributeArg{}
	mut current := []rune{}
	mut quote := rune(0)
	mut escaped := false
	for ch in raw.runes() {
		if escaped {
			current << ch
			escaped = false
			continue
		}
		if quote != rune(0) {
			if ch == `\\` {
				escaped = true
				current << ch
				continue
			}
			current << ch
			if ch == quote {
				quote = rune(0)
			}
			continue
		}
		if ch == `"` || ch == `'` {
			quote = ch
			current << ch
			continue
		}
		if ch == `,` {
			token := current.string().trim_space()
			if token != '' {
				out << parse_attr_arg(token)
			}
			current = []rune{}
			continue
		}
		current << ch
	}
	token := current.string().trim_space()
	if token != '' {
		out << parse_attr_arg(token)
	}
	return out
}

fn decode_attr_string(raw string) string {
	if raw.len < 2 {
		return raw
	}
	quote := raw[0]
	if (quote != `'` && quote != `"`) || raw[raw.len - 1] != quote {
		return raw
	}
	mut out := []rune{}
	mut escaped := false
	for ch in raw[1..raw.len - 1].runes() {
		if escaped {
			out << match ch {
				`n` { `\n` }
				`t` { `\t` }
				`r` { `\r` }
				`\\` { `\\` }
				`'` { `'` }
				`"` { `"` }
				else { ch }
			}
			escaped = false
			continue
		}
		if ch == `\\` {
			escaped = true
			continue
		}
		out << ch
	}
	return out.string()
}

fn parse_attr_arg(token string) repr.PhpAttributeArg {
	value := token.trim_space()
	lower := value.to_lower()
	if (value.starts_with("'") && value.ends_with("'"))
		|| (value.starts_with('"') && value.ends_with('"')) {
		return repr.PhpAttributeArg{
			kind:  'string'
			value: decode_attr_string(value)
		}
	}
	if lower == 'true' || lower == 'false' {
		return repr.PhpAttributeArg{
			kind:  'bool'
			value: lower
		}
	}
	if lower == 'null' {
		return repr.PhpAttributeArg{
			kind:  'null'
			value: ''
		}
	}
	if value.contains('.') && (value.f64() != 0.0 || value == '0.0' || value == '-0.0') {
		return repr.PhpAttributeArg{
			kind:  'float'
			value: value
		}
	}
	if value.i64() != 0 || value == '0' || value == '-0' {
		return repr.PhpAttributeArg{
			kind:  'int'
			value: value
		}
	}
	return repr.PhpAttributeArg{
		kind:  'string'
		value: value
	}
}

fn parse_php_attr(raw string) ?repr.PhpAttributeRepr {
	normalized := normalize_attr_value(raw)
	if normalized == '' {
		return none
	}
	if !normalized.contains('(') {
		return repr.PhpAttributeRepr{
			name: normalized
			args: []repr.PhpAttributeArg{}
		}
	}
	open := normalized.index_after('(', 0) or { return none }
	if !normalized.ends_with(')') || open <= 0 {
		return none
	}
	name := normalized[..open].trim_space()
	if name == '' {
		return none
	}
	args_raw := normalized[open + 1..normalized.len - 1]
	return repr.PhpAttributeRepr{
		name: name
		args: parse_attr_args(args_raw)
	}
}

pub fn parse_class_decl(stmt ast.Stmt, table &ast.Table) ?&repr.PhpClassRepr {
	if stmt !is ast.StructDecl {
		return none
	}
	struct_decl := stmt as ast.StructDecl
	mut cls := repr.new_class_repr()
	if !struct_decl.attrs.any(it.name == 'php_class' || it.name == 'php_trait') {
		return none
	}
	cls.is_trait = struct_decl.attrs.any(it.name == 'php_trait')

	cls.name = struct_decl.name.all_after('.')
	if attr := struct_decl.attrs.find_first(if cls.is_trait { 'php_trait' } else { 'php_class' }) {
		cls.php_name = if attr.arg != '' { attr.arg } else { cls.name }
	} else {
		cls.php_name = cls.name
	}
	if attr := struct_decl.attrs.find_first('php_extends') {
		cls.parent = normalize_attr_value(attr.arg)
	}
	for attr in struct_decl.attrs {
		if attr.name == 'php_const' {
			cls.shadow_const_name = attr.arg
		} else if attr.name == 'php_static' {
			cls.shadow_static_name = attr.arg
		} else if attr.name == 'php_abstract' {
			cls.is_abstract = true
		} else if attr.name == 'php_implements' {
			cls.implements_attr << parse_attr_list(attr.arg)
		} else if attr.name == 'php_prop' {
			if php_prop := parse_php_prop_attr(attr.arg) {
				cls.properties << php_prop
			}
		} else if attr.name == 'php_attr' {
			if php_attr := parse_php_attr(attr.arg) {
				cls.attributes << php_attr
			}
		}
	}
	if struct_decl.is_implements {
		for iface in struct_decl.implements_types {
			name := strip_module(table.get_type_name(iface.typ))
			if name != '' {
				cls.implements_v << name
			}
		}
	}
	for embed in struct_decl.embeds {
		embed_name := strip_module(table.get_type_name(embed.typ))
		if embed_name != '' {
			cls.embeds_v << embed_name
		}
	}
	for field in struct_decl.fields {
		type_name := table.get_type_name(field.typ)
		mut is_static := field.attrs.any(it.name == 'php_static')
		if !is_static {
			for comment in field.comments {
				if comment.text.contains('@[php_static]') {
					is_static = true
					break
				}
			}
		}

		cls.properties << repr.PhpClassProp{
			name:             field.name
			v_type:           type_name
			visibility:       if field.is_pub { 'public' } else { 'protected' }
			is_static:        is_static
			is_mut:           field.is_mut
			is_property_only: false
		}
	}
	return cls
}

pub fn add_class_method(mut cls repr.PhpClassRepr, stmt ast.FnDecl, table &ast.Table, field_types map[string]string, borrowed_methods map[string]bool, method_return_types map[string]string) {
	if stmt.name == 'free' && stmt.is_method {
		cls.has_free_method = true
	}
	attrs := parse_callable_attrs(stmt.attrs, 'php_method', stmt.name)
	if !attrs.has_php_callable {
		return
	}
	start_idx := if stmt.is_method { 1 } else { 0 }
	args := build_php_args(stmt.params, table, start_idx, attrs.php_arg_types, attrs.php_optional_args)

	ret_type := strip_module(table.type_to_str(stmt.return_type))
	cls.methods << repr.PhpMethodRepr{
		name:            attrs.php_name
		v_name:          stmt.name
		v_c_func:        '${cls.name}_${stmt.name}'
		is_static:       false
		return_spec:     repr.new_return_spec(ret_type, attrs.php_return_type)
		borrowed_return: attrs.borrowed_return
			|| infer_borrowed_object_return(stmt, table, field_types, borrowed_methods, method_return_types)
		visibility:      if stmt.is_pub { 'public' } else { 'protected' }
		args:            args
		has_export:      attrs.has_export
		is_abstract:     attrs.is_abstract
	}
	delegated_type, delegated_method := infer_delegated_method_ref(stmt, table, field_types)
	cls.methods[cls.methods.len - 1].delegated_target_type = delegated_type
	cls.methods[cls.methods.len - 1].delegated_target_method = delegated_method
}

pub fn add_class_static_method(mut cls repr.PhpClassRepr, stmt ast.FnDecl, table &ast.Table, method_name string) {
	attrs := parse_callable_attrs(stmt.attrs, 'php_method', method_name)
	if !attrs.has_php_callable {
		return
	}
	args := build_php_args(stmt.params, table, 0, attrs.php_arg_types, attrs.php_optional_args)

	ret_type := strip_module(table.type_to_str(stmt.return_type))
	cls.methods << repr.PhpMethodRepr{
		name:            attrs.php_name
		v_name:          method_name
		v_c_func:        '${cls.name}_${method_name}'
		is_static:       true
		return_spec:     repr.new_return_spec(ret_type, attrs.php_return_type)
		borrowed_return: attrs.borrowed_return
		visibility:      if stmt.is_pub { 'public' } else { 'protected' }
		args:            args
		has_export:      attrs.has_export
		is_abstract:     attrs.is_abstract
	}
}

pub fn build_method_borrow_profile(stmt ast.FnDecl, table &ast.Table, field_types map[string]string) ?MethodBorrowProfile {
	if !stmt.is_method || stmt.is_static_type_method {
		return none
	}
	receiver_type := normalize_delegated_target_type(table.get_type_name(stmt.receiver.typ))
	if receiver_type == '' {
		return none
	}
	delegated_type, delegated_method := infer_delegated_method_ref(stmt, table, field_types)
	return MethodBorrowProfile{
		receiver_type:           receiver_type
		method_name:             stmt.name
		return_type:             normalize_delegated_target_type(table.type_to_str(stmt.return_type))
		direct_borrowed:         infer_borrowed_object_return(stmt, table, field_types, map[string]bool{}, map[string]string{})
		delegated_target_type:   delegated_type
		delegated_target_method: delegated_method
	}
}

enum InferredObjectReturnOwnership {
	unknown
	fresh
	borrowed
}

fn infer_borrowed_object_return(stmt ast.FnDecl, table &ast.Table, field_types map[string]string, borrowed_methods map[string]bool, method_return_types map[string]string) bool {
	if !stmt.is_method || stmt.is_static_type_method || stmt.stmts.len == 0 {
		return false
	}
	mut borrow_roots := initial_borrow_roots(stmt, table)
	if borrow_roots.len == 0 {
		return false
	}
	mut state := BorrowedReturnInferenceState{}
	collect_borrowed_return_hints(stmt.stmts, table, field_types, borrowed_methods, method_return_types, mut borrow_roots, mut state)
	return state.saw_borrowed && !state.saw_conflict && !state.saw_unknown
}

struct BorrowedReturnInferenceState {
mut:
	saw_borrowed bool
	saw_conflict bool
	saw_unknown  bool
}

fn collect_borrowed_return_hints(stmts []ast.Stmt, table &ast.Table, field_types map[string]string, borrowed_methods map[string]bool, method_return_types map[string]string, mut borrow_roots map[string]string, mut state BorrowedReturnInferenceState) {
	for stmt in stmts {
		match stmt {
			ast.Return {
				if stmt.exprs.len != 1 {
					continue
				}
				match infer_object_return_expr(stmt.exprs[0], table, borrow_roots, field_types, borrowed_methods, method_return_types) {
					.borrowed { state.saw_borrowed = true }
					.fresh { state.saw_conflict = true }
					.unknown { state.saw_unknown = true }
				}
			}
			ast.AssignStmt {
				update_borrow_roots_from_assign(stmt, table, field_types, borrowed_methods, method_return_types, mut borrow_roots)
			}
			ast.ExprStmt {
				if stmt.expr is ast.IfExpr {
					if_expr := stmt.expr as ast.IfExpr
					for branch in if_expr.branches {
						mut branch_roots := borrow_roots.clone()
						apply_if_guard_borrow_root(branch.cond, table, field_types, borrowed_methods, method_return_types, mut branch_roots)
						collect_borrowed_return_hints(branch.stmts, table, field_types, borrowed_methods, method_return_types, mut branch_roots, mut
							state)
					}
				}
			}
			ast.Block {
				mut block_roots := borrow_roots.clone()
				collect_borrowed_return_hints(stmt.stmts, table, field_types, borrowed_methods, method_return_types, mut block_roots, mut state)
			}
			else {}
		}
	}
}

fn infer_object_return_expr(expr ast.Expr, table &ast.Table, borrow_roots map[string]string, field_types map[string]string, borrowed_methods map[string]bool, method_return_types map[string]string) InferredObjectReturnOwnership {
	match expr {
		ast.SelectorExpr {
			if expr_root_is_borrowed(expr, borrow_roots) {
				return .borrowed
			}
			return .unknown
		}
		ast.Ident {
			if expr.name in borrow_roots {
				return .borrowed
			}
			return .unknown
		}
		ast.StructInit {
			return .fresh
		}
		ast.IfExpr {
			return infer_if_expr_return_ownership(expr, table, borrow_roots, field_types, borrowed_methods, method_return_types)
		}
		ast.MatchExpr {
			return infer_match_expr_return_ownership(expr, table, borrow_roots, field_types, borrowed_methods, method_return_types)
		}
		ast.ParExpr {
			return infer_object_return_expr(expr.expr, table, borrow_roots, field_types, borrowed_methods, method_return_types)
		}
		ast.UnsafeExpr {
			return infer_object_return_expr(expr.expr, table, borrow_roots, field_types, borrowed_methods, method_return_types)
		}
		ast.CastExpr {
			return infer_object_return_expr(expr.expr, table, borrow_roots, field_types, borrowed_methods, method_return_types)
		}
		ast.PrefixExpr {
			return infer_object_return_expr(expr.right, table, borrow_roots, field_types, borrowed_methods, method_return_types)
		}
		ast.CallExpr {
			if expr_root_is_borrowed(expr.left, borrow_roots)
				&& normalize_local_return_like_method_name(expr.name) in ['clone', 'copy', 'dup', 'duplicate', 'new', 'make'] {
				return .fresh
			}
			if expr.or_block.stmts.len > 0 {
				mut primary := InferredObjectReturnOwnership.unknown
				if infer_borrowed_call_return_type(expr, table, borrow_roots, field_types, borrowed_methods, method_return_types) != none {
					primary = .borrowed
				}
				mut fallback_roots := borrow_roots.clone()
				fallback := infer_expr_block_result_ownership(expr.or_block.stmts, table, field_types, borrowed_methods, method_return_types, mut fallback_roots)
				if primary == .borrowed && fallback == .borrowed {
					return .borrowed
				}
				if primary == .fresh || fallback == .fresh {
					return .fresh
				}
				return .unknown
			}
			if infer_borrowed_call_return_type(expr, table, borrow_roots, field_types, borrowed_methods, method_return_types) != none {
				return .borrowed
			}
			return .unknown
		}
		else {
			return .unknown
		}
	}
}

fn infer_if_expr_return_ownership(if_expr ast.IfExpr, table &ast.Table, borrow_roots map[string]string, field_types map[string]string, borrowed_methods map[string]bool, method_return_types map[string]string) InferredObjectReturnOwnership {
	if !if_expr.has_else || if_expr.branches.len == 0 {
		return .unknown
	}
	mut saw_borrowed := false
	mut saw_unknown := false
	for branch in if_expr.branches {
		mut branch_roots := borrow_roots.clone()
		apply_if_guard_borrow_root(branch.cond, table, field_types, borrowed_methods, method_return_types, mut branch_roots)
		match infer_expr_block_result_ownership(branch.stmts, table, field_types, borrowed_methods, method_return_types, mut branch_roots) {
			.borrowed { saw_borrowed = true }
			.fresh { return .fresh }
			.unknown { saw_unknown = true }
		}
	}
	if saw_borrowed && !saw_unknown {
		return .borrowed
	}
	return .unknown
}

fn infer_match_expr_return_ownership(match_expr ast.MatchExpr, table &ast.Table, borrow_roots map[string]string, field_types map[string]string, borrowed_methods map[string]bool, method_return_types map[string]string) InferredObjectReturnOwnership {
	if match_expr.branches.len == 0 {
		return .unknown
	}
	mut saw_borrowed := false
	mut saw_unknown := false
	for branch in match_expr.branches {
		mut branch_roots := borrow_roots.clone()
		match infer_expr_block_result_ownership(branch.stmts, table, field_types, borrowed_methods, method_return_types, mut branch_roots) {
			.borrowed { saw_borrowed = true }
			.fresh { return .fresh }
			.unknown { saw_unknown = true }
		}
	}
	if saw_borrowed && !saw_unknown {
		return .borrowed
	}
	return .unknown
}

fn infer_expr_block_result_ownership(stmts []ast.Stmt, table &ast.Table, field_types map[string]string, borrowed_methods map[string]bool, method_return_types map[string]string, mut borrow_roots map[string]string) InferredObjectReturnOwnership {
	if stmts.len == 0 {
		return .unknown
	}
	for idx, stmt in stmts {
		is_last := idx == stmts.len - 1
		match stmt {
			ast.AssignStmt {
				update_borrow_roots_from_assign(stmt, table, field_types, borrowed_methods, method_return_types, mut borrow_roots)
			}
			ast.ExprStmt {
				if is_last {
					return infer_object_return_expr(stmt.expr, table, borrow_roots, field_types, borrowed_methods, method_return_types)
				}
			}
			else {}
		}
	}
	return .unknown
}

fn initial_borrow_roots(stmt ast.FnDecl, table &ast.Table) map[string]string {
	mut roots := map[string]string{}
	if stmt.receiver.name != '' {
		receiver_type := normalize_delegated_target_type(table.get_type_name(stmt.receiver.typ))
		if receiver_type != '' {
			roots[stmt.receiver.name] = receiver_type
		}
	}
	start_idx := if stmt.is_method { 1 } else { 0 }
	for i := start_idx; i < stmt.params.len; i++ {
		param := stmt.params[i]
		param_type := normalize_delegated_target_type(table.type_to_str(param.typ))
		if param_type != '' {
			roots[param.name] = param_type
		}
	}
	return roots
}

fn update_borrow_roots_from_assign(stmt ast.AssignStmt, table &ast.Table, field_types map[string]string, borrowed_methods map[string]bool, method_return_types map[string]string, mut borrow_roots map[string]string) {
	if stmt.left.len != 1 || stmt.right.len != 1 {
		return
	}
	if stmt.left[0] !is ast.Ident {
		return
	}
	left := stmt.left[0] as ast.Ident
	root_type := infer_borrow_root_type(stmt.right[0], table, borrow_roots, field_types, borrowed_methods, method_return_types)
	if root_type == '' {
		borrow_roots.delete(left.name)
		return
	}
	borrow_roots[left.name] = root_type
}

fn infer_borrow_root_type(expr ast.Expr, table &ast.Table, borrow_roots map[string]string, field_types map[string]string, borrowed_methods map[string]bool, method_return_types map[string]string) string {
	match expr {
		ast.Ident {
			return borrow_roots[expr.name] or { '' }
		}
		ast.SelectorExpr {
			base_type := infer_borrow_root_type(expr.expr, table, borrow_roots, field_types, borrowed_methods, method_return_types)
			if base_type == '' {
				return ''
			}
			return field_types['${base_type}::${expr.field_name}'] or { '' }
		}
		ast.IfExpr {
			return infer_if_expr_borrow_root_type(expr, table, borrow_roots, field_types, borrowed_methods, method_return_types)
		}
		ast.MatchExpr {
			return infer_match_expr_borrow_root_type(expr, table, borrow_roots, field_types, borrowed_methods, method_return_types)
		}
		ast.ParExpr {
			return infer_borrow_root_type(expr.expr, table, borrow_roots, field_types, borrowed_methods, method_return_types)
		}
		ast.UnsafeExpr {
			return infer_borrow_root_type(expr.expr, table, borrow_roots, field_types, borrowed_methods, method_return_types)
		}
		ast.CastExpr {
			return infer_borrow_root_type(expr.expr, table, borrow_roots, field_types, borrowed_methods, method_return_types)
		}
		ast.PrefixExpr {
			return infer_borrow_root_type(expr.right, table, borrow_roots, field_types, borrowed_methods, method_return_types)
		}
		ast.CallExpr {
			if call_borrowed_type := infer_borrowed_call_return_type(expr, table, borrow_roots, field_types, borrowed_methods, method_return_types) {
				if expr.or_block.stmts.len > 0 {
					mut fallback_roots := borrow_roots.clone()
					fallback_type := infer_expr_block_result_root_type(expr.or_block.stmts, table, field_types, borrowed_methods, method_return_types, mut fallback_roots)
					if fallback_type == call_borrowed_type {
						return call_borrowed_type
					}
					return ''
				}
				return call_borrowed_type
			}
			if expr.args.len == 1 {
				return infer_borrow_root_type(expr.args[0].expr, table, borrow_roots, field_types, borrowed_methods, method_return_types)
			}
			return ''
		}
		else {
			return ''
		}
	}
}

fn infer_if_expr_borrow_root_type(if_expr ast.IfExpr, table &ast.Table, borrow_roots map[string]string, field_types map[string]string, borrowed_methods map[string]bool, method_return_types map[string]string) string {
	if !if_expr.has_else || if_expr.branches.len == 0 {
		return ''
	}
	mut inferred_type := ''
	for branch in if_expr.branches {
		mut branch_roots := borrow_roots.clone()
		apply_if_guard_borrow_root(branch.cond, table, field_types, borrowed_methods, method_return_types, mut branch_roots)
		branch_type := infer_expr_block_result_root_type(branch.stmts, table, field_types, borrowed_methods, method_return_types, mut branch_roots)
		if branch_type == '' {
			return ''
		}
		if inferred_type == '' {
			inferred_type = branch_type
			continue
		}
		if inferred_type != branch_type {
			return ''
		}
	}
	return inferred_type
}

fn infer_match_expr_borrow_root_type(match_expr ast.MatchExpr, table &ast.Table, borrow_roots map[string]string, field_types map[string]string, borrowed_methods map[string]bool, method_return_types map[string]string) string {
	if match_expr.branches.len == 0 {
		return ''
	}
	mut inferred_type := ''
	for branch in match_expr.branches {
		mut branch_roots := borrow_roots.clone()
		branch_type := infer_expr_block_result_root_type(branch.stmts, table, field_types, borrowed_methods, method_return_types, mut branch_roots)
		if branch_type == '' {
			return ''
		}
		if inferred_type == '' {
			inferred_type = branch_type
			continue
		}
		if inferred_type != branch_type {
			return ''
		}
	}
	return inferred_type
}

fn infer_expr_block_result_root_type(stmts []ast.Stmt, table &ast.Table, field_types map[string]string, borrowed_methods map[string]bool, method_return_types map[string]string, mut borrow_roots map[string]string) string {
	if stmts.len == 0 {
		return ''
	}
	for idx, stmt in stmts {
		is_last := idx == stmts.len - 1
		match stmt {
			ast.AssignStmt {
				update_borrow_roots_from_assign(stmt, table, field_types, borrowed_methods, method_return_types, mut borrow_roots)
			}
			ast.ExprStmt {
				if is_last {
					return infer_borrow_root_type(stmt.expr, table, borrow_roots, field_types, borrowed_methods, method_return_types)
				}
			}
			else {}
		}
	}
	return ''
}

fn infer_borrowed_call_return_type(expr ast.CallExpr, table &ast.Table, borrow_roots map[string]string, field_types map[string]string, borrowed_methods map[string]bool, method_return_types map[string]string) ?string {
	target_type := delegated_call_target_type(expr, '', '', table, field_types, borrow_roots)
	if target_type == '' {
		return none
	}
	method_key := '${target_type}::${expr.name}'
	if !(borrowed_methods[method_key] or { false }) {
		return none
	}
	if !expr.return_type.is_full() {
		return method_return_types[method_key] or { none }
	}
	return_type := normalize_delegated_target_type(table.type_to_str(expr.return_type))
	if return_type == '' {
		return method_return_types[method_key] or { none }
	}
	return return_type
}

fn apply_if_guard_borrow_root(cond ast.Expr, table &ast.Table, field_types map[string]string, borrowed_methods map[string]bool, method_return_types map[string]string, mut borrow_roots map[string]string) {
	if cond !is ast.IfGuardExpr {
		return
	}
	guard := cond as ast.IfGuardExpr
	if guard.vars.len == 0 {
		return
	}
	mut root_type := infer_borrow_root_type(guard.expr, table, borrow_roots, field_types, borrowed_methods, method_return_types)
	if root_type == '' && guard.expr_type.is_full() {
		root_type = normalize_delegated_target_type(table.type_to_str(guard.expr_type))
	}
	if root_type == '' {
		return
	}
	for variable in guard.vars {
		if variable.name != '' {
			borrow_roots[variable.name] = root_type
		}
	}
}

fn expr_root_is_borrowed(expr ast.Expr, borrow_roots map[string]string) bool {
	match expr {
		ast.Ident {
			return expr.name in borrow_roots
		}
		ast.SelectorExpr {
			if root := expr.root_ident() {
				return root.name in borrow_roots
			}
			return false
		}
		ast.ParExpr {
			return expr_root_is_borrowed(expr.expr, borrow_roots)
		}
		ast.UnsafeExpr {
			return expr_root_is_borrowed(expr.expr, borrow_roots)
		}
		ast.CastExpr {
			return expr_root_is_borrowed(expr.expr, borrow_roots)
		}
		ast.PrefixExpr {
			return expr_root_is_borrowed(expr.right, borrow_roots)
		}
		ast.CallExpr {
			return expr.args.len == 1 && expr_root_is_borrowed(expr.args[0].expr, borrow_roots)
		}
		else {
			return false
		}
	}
}

fn normalize_local_return_like_method_name(name string) string {
	mut base := name.to_lower()
	base = match base {
		'construct', 'init' { '__construct' }
		'str' { '__tostring' }
		else { base }
	}
	if base.contains('.') {
		return base.all_after_last('.')
	}
	return base
}

fn infer_delegated_method_ref(stmt ast.FnDecl, table &ast.Table, field_types map[string]string) (string, string) {
	if !stmt.is_method || stmt.is_static_type_method || stmt.stmts.len == 0 {
		return '', ''
	}
	receiver_name := stmt.receiver.name
	if receiver_name == '' {
		return '', ''
	}
	receiver_type := normalize_delegated_target_type(table.get_type_name(stmt.receiver.typ))
	mut borrow_roots := initial_borrow_roots(stmt, table)
	mut state := DelegatedReceiverMethodState{}
	collect_delegated_method_ref(stmt.stmts, receiver_name, receiver_type, table, field_types, mut borrow_roots, mut state)
	if state.invalid || !state.saw_delegate {
		return '', ''
	}
	return state.target_type, state.target_method
}

struct DelegatedReceiverMethodState {
mut:
	target_type   string
	target_method string
	saw_delegate  bool
	invalid       bool
}

fn collect_delegated_method_ref(stmts []ast.Stmt, receiver_name string, receiver_type string, table &ast.Table, field_types map[string]string, mut borrow_roots map[string]string, mut state DelegatedReceiverMethodState) {
	for stmt in stmts {
		match stmt {
			ast.Return {
				if stmt.exprs.len != 1 {
					continue
				}
				target_type, target_method := delegated_method_ref(stmt.exprs[0], receiver_name, receiver_type, table, field_types, borrow_roots)
				if target_type == '' || target_method == '' {
					state.invalid = true
					continue
				}
				if !state.saw_delegate {
					state.target_type = target_type
					state.target_method = target_method
					state.saw_delegate = true
					continue
				}
				if state.target_type != target_type || state.target_method != target_method {
					state.invalid = true
				}
			}
			ast.AssignStmt {
				update_borrow_roots_from_assign(stmt, table, field_types, map[string]bool{}, map[string]string{}, mut borrow_roots)
			}
			ast.ExprStmt {
				if stmt.expr is ast.IfExpr {
					if_expr := stmt.expr as ast.IfExpr
					for branch in if_expr.branches {
						mut branch_roots := borrow_roots.clone()
						apply_if_guard_borrow_root(branch.cond, table, field_types, map[string]bool{}, map[string]string{}, mut branch_roots)
						collect_delegated_method_ref(branch.stmts, receiver_name, receiver_type, table, field_types, mut branch_roots, mut
							state)
					}
				}
			}
			ast.Block {
				mut block_roots := borrow_roots.clone()
				collect_delegated_method_ref(stmt.stmts, receiver_name, receiver_type, table, field_types, mut block_roots, mut state)
			}
			else {}
		}
	}
}

fn delegated_method_ref(expr ast.Expr, receiver_name string, receiver_type string, table &ast.Table, field_types map[string]string, borrow_roots map[string]string) (string, string) {
	match expr {
		ast.CallExpr {
			if expr.or_block.stmts.len > 0 {
				return '', ''
			}
			if !expr_root_is_borrowed(expr.left, borrow_roots) {
				return '', ''
			}
			target_type := delegated_call_target_type(expr, receiver_name, receiver_type, table, field_types, borrow_roots)
			if target_type == '' {
				return '', ''
			}
			return target_type, expr.name
		}
		ast.ParExpr {
			return delegated_method_ref(expr.expr, receiver_name, receiver_type, table, field_types, borrow_roots)
		}
		ast.UnsafeExpr {
			return delegated_method_ref(expr.expr, receiver_name, receiver_type, table, field_types, borrow_roots)
		}
		ast.CastExpr {
			return delegated_method_ref(expr.expr, receiver_name, receiver_type, table, field_types, borrow_roots)
		}
		ast.PrefixExpr {
			return delegated_method_ref(expr.right, receiver_name, receiver_type, table, field_types, borrow_roots)
		}
		else {
			return '', ''
		}
	}
}

fn delegated_call_target_type(expr ast.CallExpr, receiver_name string, receiver_type string, table &ast.Table, field_types map[string]string, borrow_roots map[string]string) string {
	if expr.left_type.is_full() {
		return normalize_delegated_target_type(table.type_to_str(expr.left_type))
	}
	if expr.receiver_type.is_full() {
		return normalize_delegated_target_type(table.type_to_str(expr.receiver_type))
	}
	return infer_receiver_expr_type(expr.left, receiver_name, receiver_type, field_types, borrow_roots)
}

fn infer_receiver_expr_type(expr ast.Expr, receiver_name string, receiver_type string, field_types map[string]string, borrow_roots map[string]string) string {
	match expr {
		ast.Ident {
			if expr.name in borrow_roots {
				return borrow_roots[expr.name] or { '' }
			}
			return ''
		}
		ast.SelectorExpr {
			base_type := infer_receiver_expr_type(expr.expr, receiver_name, receiver_type, field_types, borrow_roots)
			if base_type == '' {
				return ''
			}
			return field_types['${base_type}::${expr.field_name}'] or { '' }
		}
		ast.ParExpr {
			return infer_receiver_expr_type(expr.expr, receiver_name, receiver_type, field_types, borrow_roots)
		}
		ast.UnsafeExpr {
			return infer_receiver_expr_type(expr.expr, receiver_name, receiver_type, field_types, borrow_roots)
		}
		ast.CastExpr {
			return infer_receiver_expr_type(expr.expr, receiver_name, receiver_type, field_types, borrow_roots)
		}
		ast.PrefixExpr {
			return infer_receiver_expr_type(expr.right, receiver_name, receiver_type, field_types, borrow_roots)
		}
		ast.CallExpr {
			if expr.args.len == 1 {
				return infer_receiver_expr_type(expr.args[0].expr, receiver_name, receiver_type, field_types, borrow_roots)
			}
			return ''
		}
		else {
			return ''
		}
	}
}

pub fn normalize_delegated_target_type(raw string) string {
	mut name := raw.trim_space()
	for name.starts_with('?') || name.starts_with('!') {
		name = name[1..].trim_space()
	}
	for name.starts_with('&') {
		name = name[1..].trim_space()
	}
	for {
		if name.starts_with('shared ') {
			name = name['shared '.len..].trim_space()
			continue
		}
		if name.starts_with('atomic ') {
			name = name['atomic '.len..].trim_space()
			continue
		}
		if name.starts_with('mut ') {
			name = name['mut '.len..].trim_space()
			continue
		}
		break
	}
	if name.contains('.') {
		return name.all_after_last('.')
	}
	return name
}
