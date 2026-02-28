module compiler

import v.ast

pub struct PhpFuncRepr {
pub mut:
	name        string
	return_type string // V 返回类型：'void', 'int', 'i64', 'bool', 'string', 'f64'
	is_internal bool   // 标记如 v_spawn, v_wait 这种内置函数
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

				r.name = exp_name

				// 3. 解析返回类型
				ret_type := table.get_type_name(stmt.return_type)
				clean := if ret_type.contains('.') { ret_type.all_after('.') } else { ret_type }
				// 只有纯 C 标量类型支持直接 return
				// string 等复合类型仍需 ctx.return_xxx()，因为跨 C ABI 传递结构体不安全
				if clean in ['int', 'i64', 'bool', 'f64'] {
					r.return_type = clean
				} else {
					r.return_type = 'void'
				}

				return true
			}
		}
	}
	return false
}

fn (r PhpFuncRepr) gen_h() []string {
    return [
        'PHP_FUNCTION(${r.name});'
    ]
}

fn (f PhpFuncRepr) gen_c() []string {
    mut r := []string{}
    // 生成 ArgInfo
    r << 'ZEND_BEGIN_ARG_INFO_EX(arginfo_${f.name}, 0, 0, 0)'
    r << 'ZEND_END_ARG_INFO()'

    tm := TypeMap.get_type(f.return_type)

    if tm.v_type == 'void' {
        // void 函数：用户通过 ctx.return_xxx() 手动设置返回值
        r << 'extern void ${f.name}(vphp_context_internal ctx);'
        r << 'PHP_FUNCTION(${f.name}) {'
        r << '    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };'
        r << '    ${f.name}(ctx);'
        r << '}'
    } else {
        // 有返回值的函数：C 包装器接收 V 返回值并自动转换
        r << 'extern ${tm.c_type} ${f.name}(vphp_context_internal ctx);'
        r << 'PHP_FUNCTION(${f.name}) {'
        r << '    vphp_context_internal ctx = { .ex = (void*)execute_data, .ret = (void*)return_value };'
        r << '    ${tm.c_type} res = ${f.name}(ctx);'
        r << '    ${tm.php_return}(res);'
        r << '}'
    }
    return r
}

fn (r PhpFuncRepr) gen_minit() []string {
	return []string{}
}
