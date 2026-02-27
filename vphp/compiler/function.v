module compiler

import v.ast

pub struct PhpFuncRepr {
pub mut:
	name        string
	is_internal bool // 标记如 v_spawn, v_wait 这种内置函数
}

pub fn new_func_repr() &PhpFuncRepr {
	return &PhpFuncRepr{}
}

// 实现接口
fn (mut r PhpFuncRepr) parse(stmt ast.Stmt, table &ast.Table) bool {
	if stmt is ast.FnDecl {
		// 1. 严格排除类方法
		if stmt.is_method {
			return false
		}
		// 2. 检查是否有 @[export: 'xxx']
		for attr in stmt.attrs {
			if attr.name == 'export' && attr.arg != '' {
				exp_name := attr.arg

				// 排除框架内部函数
				if exp_name.starts_with('vphp_') || exp_name.starts_with('zm_') {
					return false
				}

				// 3. 这里的关键：r.name 必须是 PHP 侧看到的函数名
				r.name = exp_name
				return true
			}
		}
	}
	return false
}

fn (r PhpFuncRepr) gen_h() []string {
    // 生成标准 PHP 函数声明宏
    return [
        'PHP_FUNCTION(${r.name});'
    ]
}

fn (f PhpFuncRepr) gen_c() []string {
    mut r := []string{}
    // 生成 ArgInfo
    r << 'ZEND_BEGIN_ARG_INFO_EX(arginfo_${f.name}, 0, 0, 0)'
    r << 'ZEND_END_ARG_INFO()'
    // 生成包装器
    // 注意：这里假设业务逻辑编译后的 C 函数名就是 f.name
    r << 'extern void ${f.name}(zend_execute_data *execute_data, zval *return_value);'
    r << 'PHP_FUNCTION(${f.name}) {'
    r << '    ${f.name}(execute_data, return_value);'
    r << '}'
    return r
}
fn (r PhpFuncRepr) gen_minit() []string {
	// 全局函数不在 MINIT 注册，而是在模块的函数表里。
	// 但为了保持接口一致性，这里返回空，生成逻辑在 bridge_gen.v 遍历函数表时处理。
	return []string{}
}
