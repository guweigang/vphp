module compiler

import v.ast

pub struct PhpClassRepr {
pub mut:
	name       string      // V struct 名 (如 VPhpTask)
	php_name   string      // PHP 侧类名 (如 VPhp\Task)，可含命名空间
	parent     string      // 继承关系
	is_final   bool
	constants  []PhpClassConst
	properties []PhpClassProp
	methods    []PhpMethodRepr
}

// C 宏安全名称：将 \ 替换为 _
pub fn (r PhpClassRepr) c_name() string {
	return r.php_name.replace('\\', '_')
}

pub struct PhpClassConst {
	name  string
	value string
}

pub struct PhpClassProp {
pub:
	name       string
	v_type     string // V 端的原始类型，如 'int', 'string', 'bool'
	visibility string // 'public', 'protected', 'private'
	is_static  bool
}

pub struct PhpMethodRepr {
pub mut:
    name          string   // PHP 侧方法名，如 "create"
    v_name        string   // V 侧原始方法名，如 "spawn"
    v_c_func      string   // V 导出的 C 符号名，如 "Article_create"
    is_static     bool     // 是否为静态方法
    return_type   string   // 返回类型，如 "bool" 或 "&Article"
    args          []PhpArg
    has_export    bool
    visibility    string
}

pub struct PhpArg {
pub mut:
    name   string
    v_type string
}

fn new_class_repr() &PhpClassRepr { return &PhpClassRepr{} }

// ============================================
// AST 解析 — 保持不变
// ============================================

fn (mut r PhpClassRepr) parse(stmt ast.Stmt, table &ast.Table) bool {
	if stmt is ast.StructDecl {
		if stmt.attrs.any(it.name == 'php_class') {
			r.name = stmt.name.all_after('.')
			// 检查是否有自定义 PHP 类名（含命名空间）
			if attr := stmt.attrs.find_first('php_class') {
				if attr.arg != '' {
					r.php_name = attr.arg
				} else {
					r.php_name = r.name
				}
			}
			if attr := stmt.attrs.find_first('php_parent') {
				r.parent = attr.arg
			}
			for field in stmt.fields {
			  type_name := table.get_type_name(field.typ)
				r.properties << PhpClassProp{
					name: field.name
					v_type: type_name
					visibility: if field.is_pub { 'public' } else { 'protected' }
					is_static: field.attrs.any(it.name == 'static')
				}
			}
			return true
		}
	}
	return false
}

pub fn (mut r PhpClassRepr) add_method(stmt ast.FnDecl, table &ast.Table) {
	if !stmt.attrs.any(it.name == 'php_method') {
		return
	}
	
	mut has_export := false
	mut php_name := stmt.name
	for attr in stmt.attrs {
		if attr.name == 'export' && attr.arg != '' {
			has_export = true
		}
		if attr.name == 'php_method' && attr.arg != '' {
			php_name = attr.arg
		}
	}

	mut args := []PhpArg{}
	start_idx := if stmt.is_method { 1 } else { 0 }
	
	for i := start_idx; i < stmt.params.len; i++ {
	    param := stmt.params[i]
		mut typ_name := table.get_type_name(param.typ)
		if typ_name.contains('.') { typ_name = typ_name.all_after('.') }
		args << PhpArg{
			name: param.name
			v_type: typ_name
		}
	}

	ret_type := table.type_to_str(stmt.return_type)
	r.methods << PhpMethodRepr{
		name: php_name
		v_name: stmt.name
		v_c_func: '${r.name}_${stmt.name}'
		is_static: false
		return_type: ret_type
		visibility: if stmt.is_pub { 'public' } else { 'protected' }
		args: args
		has_export: has_export
	}
}

pub fn (mut r PhpClassRepr) add_static_method(stmt ast.FnDecl, table &ast.Table, method_name string) {
	if !stmt.attrs.any(it.name == 'php_method') {
		return
	}

	mut has_export := false
	mut php_name := method_name
	for attr in stmt.attrs {
		if attr.name == 'export' && attr.arg != '' {
			has_export = true
		}
		if attr.name == 'php_method' && attr.arg != '' {
			php_name = attr.arg
		}
	}

	mut args := []PhpArg{}
	for param in stmt.params {
		mut typ_name := table.get_type_name(param.typ)
		if typ_name.contains('.') { typ_name = typ_name.all_after('.') }
		args << PhpArg{
			name: param.name
			v_type: typ_name
		}
	}

	ret_type := table.type_to_str(stmt.return_type)
	r.methods << PhpMethodRepr{
		name: php_name
		v_name: method_name
		v_c_func: '${r.name}_${method_name}'
		is_static: true
		return_type: ret_type
		visibility: if stmt.is_pub { 'public' } else { 'protected' }
		args: args
		has_export: has_export
	}
}
