module compiler

import v.ast

pub struct PhpConstRepr {
pub mut:
	name          string // 导出到 PHP 的常量名（自动大写）
	value         string // 常量值的字符串形式
	const_type    string // 'int', 'f64', 'string', 'bool', 'struct'
	v_type        string // 该常量在 V 侧的类型名，如 "ArticleConsts"
	has_php_const bool   // 是否显式导出为 PHP 全局常量
	fields        map[string]PhpConstRepr // 如果是结构体，存储其子字段
}

fn new_const_repr() &PhpConstRepr { return &PhpConstRepr{} }

fn (mut r PhpConstRepr) parse(stmt ast.Stmt, table &ast.Table) bool {
	if stmt is ast.ConstDecl {
		// 所有的常量都尝试解析，以便影子常量系统能够找到它们
		r.has_php_const = stmt.attrs.any(it.name == 'php_const')
		
		for field in stmt.fields {
			// 跳过 ext_config 等框架内部常量
			if field.name.ends_with('ext_config') {
				continue
			}

			// 常量名：取模块后部分，符合 PHP 惯例
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
			} else if field.expr is ast.StructInit {
				expr := field.expr as ast.StructInit
				r.const_type = 'struct'
				r.name = raw_name 
				// 提取 V 侧类型名
				mut v_type := table.get_type_name(expr.typ)
				if v_type.contains('.') {
					v_type = v_type.all_after('.')
				}
				r.v_type = v_type

				// 从显式初始化代码中提取 (显式赋值)
				for f in expr.init_fields {
					mut sub := PhpConstRepr{
						name: f.name.to_upper()
					}
					if f.expr is ast.StringLiteral {
						sub.value = (f.expr as ast.StringLiteral).val
						sub.const_type = 'string'
					} else if f.expr is ast.IntegerLiteral {
						sub.value = (f.expr as ast.IntegerLiteral).val
						sub.const_type = 'int'
					} else if f.expr is ast.FloatLiteral {
						sub.value = (f.expr as ast.FloatLiteral).val
						sub.const_type = 'f64'
					} else if f.expr is ast.BoolLiteral {
						sub.value = if (f.expr as ast.BoolLiteral).val { '1' } else { '0' }
						sub.const_type = 'bool'
					}
					r.fields[f.name] = sub
				}
			} else {
				// 不支持的类型，跳过
				continue
			}
			return true
		}
	}
	return false
}
