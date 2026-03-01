module compiler

import v.ast

pub struct PhpClassRepr {
pub mut:
	name       string      // V struct 名 (如 VPhpTask)
	php_name   string      // PHP 侧类名 (如 VPhp\Task)，可含命名空间
	parent     string      // 继承关系
	is_final   bool
	shadow_const_name string  // 绑定的影子常量名，如 "article_consts"
	shadow_static_name string // 新增：绑定的影子静态属性名，如 "article_statics"
	shadow_const_type string  // 绑定的影子常量的 V 侧类型
	shadow_static_type string // 新增：绑定的影子静态属性的 V 侧类型
	constants  []PhpClassConst
	properties []PhpClassProp
	methods    []PhpMethodRepr
}

// C 宏安全名称：将 \ 替换为 _
pub fn (r PhpClassRepr) c_name() string {
	return r.php_name.replace('\\', '_')
}

pub struct PhpClassConst {
	name         string // PHP 侧大写名，如 "MAX_TITLE_LEN"
	v_field_name string // V 侧原始名，如 "max_title_len"
	value        string
	const_type   string
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
			if attr := stmt.attrs.find_first('php_extends') {
				r.parent = attr.arg
			}
			for attr in stmt.attrs {
				if attr.name == 'php_const' {
					r.shadow_const_name = attr.arg
				} else if attr.name == 'php_static' {
					r.shadow_static_name = attr.arg
				}
			}
			if stmt.embeds.len > 0 && r.parent == '' {
				// 如果没有明确指定 php_extends，自动从第一个嵌入结构体中提取
				parent_type_name := table.get_type_name(stmt.embeds[0].typ)
				r.parent = if parent_type_name.contains('.') {
					parent_type_name.all_after('.')
				} else {
					parent_type_name
				}
			}
			for field in stmt.fields {
			  type_name := table.get_type_name(field.typ)
			  
			  // Parse comments for @[php_static] marker since V attributes on fields are picky
			  mut is_static := false
			  for comment in field.comments {
				  if comment.text.contains('@[php_static]') {
					  is_static = true
					  break
				  }
			  }

				r.properties << PhpClassProp{
					name: field.name
					v_type: type_name
					visibility: if field.is_pub { 'public' } else { 'protected' }
					is_static: is_static
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
		args << PhpArg{
			name: param.name
			v_type: strip_module(table.get_type_name(param.typ))
		}
	}

	ret_type := strip_module(table.type_to_str(stmt.return_type))
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

// strip_module cleans "main.SomeType" to "SomeType" but preserves "&"
fn strip_module(mut_typ_name string) string {
    return mut_typ_name.replace('main.', '')
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
		args << PhpArg{
			name: param.name
			v_type: strip_module(table.get_type_name(param.typ))
		}
	}

	ret_type := strip_module(table.type_to_str(stmt.return_type))
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
