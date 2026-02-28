module compiler

import v.ast

pub struct PhpConstRepr {
pub mut:
	name       string // 导出到 PHP 的常量名（自动大写）
	value      string // 常量值的字符串形式
	const_type string // 'int', 'f64', 'string', 'bool'
}

fn new_const_repr() &PhpConstRepr { return &PhpConstRepr{} }

fn (mut r PhpConstRepr) parse(stmt ast.Stmt, table &ast.Table) bool {
	if stmt is ast.ConstDecl {
		// 检查是否有 @[php_const] 标注
		if !stmt.attrs.any(it.name == 'php_const') {
			return false
		}

		for field in stmt.fields {
			// 跳过 ext_config 等框架内部常量
			if field.name.ends_with('ext_config') {
				continue
			}

			// 常量名：取模块后部分，转大写，符合 PHP 惯例
			raw_name := field.name.all_after('.')
			r.name = raw_name.to_upper()

			// 识别常量值和类型
			if field.expr is ast.StringLiteral {
				r.value = (field.expr as ast.StringLiteral).val
				r.const_type = 'string'
			} else if field.expr is ast.IntegerLiteral {
				r.value = (field.expr as ast.IntegerLiteral).val
				r.const_type = 'int'
			} else if field.expr is ast.FloatLiteral {
				r.value = (field.expr as ast.FloatLiteral).val
				r.const_type = 'f64'
			} else if field.expr is ast.BoolLiteral {
				r.value = if (field.expr as ast.BoolLiteral).val { '1' } else { '0' }
				r.const_type = 'bool'
			} else {
				// 不支持的类型，跳过
				continue
			}
			return true
		}
	}
	return false
}
