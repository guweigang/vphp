module vphp

import vphp.zend

pub struct Context {
pub:
	ex  &C.zend_execute_data
	ret &C.zval
}

// 原生返回封装
pub fn (ctx Context) return_int(val i64) {
	unsafe {
		out := Val{ raw: ctx.ret }
		out.set_int(val)
	}
}

pub fn (ctx Context) return_string(val string) {
	unsafe {
		out := Val{ raw: ctx.ret }
		out.set_string(val)
	}
}

// 返回 map[string]f64 (例如配置参数)
pub fn (ctx Context) return_map_f64(m map[string]f64) {
    C.vphp_return_array_start(ctx.ret)
    for k, v in m {
        // 使用我们之前定义的 vphp_array_add_assoc_double
        C.vphp_array_add_assoc_double(ctx.ret, &char(k.str), v)
    }
}

// 返回 map[string]int
pub fn (ctx Context) return_map_int(m map[string]int) {
    C.vphp_return_array_start(ctx.ret)
    for k, v in m {
        C.vphp_array_add_assoc_long(ctx.ret, &char(k.str), i64(v))
    }
}

// 辅助方法：获取参数个数
pub fn (ctx Context) num_args() int {
    return int(C.vphp_get_num_args(ctx.ex))
}

pub fn (ctx Context) arg[T](index int) T {
	args := get_args(ctx.ex)
	if index >= args.len {
		return T{}
	}
	val := args[index]
	raw_zval := val.raw

	// --- 1. 处理数组/切片 (保姆级手动匹配) ---
	$if T is $array {
      if !val.is_array() {
				C.vphp_throw(&char('Expected array at index $index'.str), 0)
				return T{}
			}
      count := C.vphp_array_count(raw_zval)
      mut res := T{cap: count}
      for i in 0 .. count {
          item_zval := C.vphp_array_get_index(raw_zval, u32(i))
          if item_zval != 0 {
              // 根据切片元素类型显式转换
              $if T is []string {
                  len := 0
                  ptr := voidptr(C.vphp_get_string_ptr(item_zval, &len))
         					if ptr != 0 {
          						res << unsafe { (&char(ptr)).vstring_with_len(len) }
         					} else {
          						res << ''
         					}
              } $else $if T is []f64 {
                  res << C.vphp_get_double(item_zval)
              } $else $if T is []int {
                  res << int(C.vphp_get_int(item_zval))
              } $else $if T is []i64 {
                  res << i64(C.vphp_get_int(item_zval))
              }
          }
      }
      return res
  }

  $if T is bool {
		if !val.is_bool() {
			C.vphp_throw(&char('Argument $index must be a boolean'.str), 0)
			return false
		}
		return val.to_bool()
	}

	// --- 3. 补全数字类型兼容 ---
	$if T is f64 {
		if !val.is_double() && !val.is_long() {
			C.vphp_throw(&char('Argument $index must be a number'.str))
			return 0.0
		}
		return C.vphp_get_double(val.raw)
	}

	// --- 修正后的数字处理逻辑 ---
    $if T is int {
        if !val.is_long() && !val.is_double() {
            C.vphp_throw(&char('Argument $index: expected integer, got ${val.type_name()}'.str), 0)
            return 0
        }
        // 关键点：如果是 int 分支，必须转为 int
        return int(C.vphp_get_int(val.raw))
    }

    $if T is i64 {
        if !val.is_long() && !val.is_double() {
            C.vphp_throw(&char('Argument $index: expected integer, got ${val.type_name()}'.str), 0)
            return 0
        }
        // 关键点：如果是 i64 分支，必须转为 i64
        return i64(C.vphp_get_int(val.raw))
    }

	// --- 2. 处理 Map (保持你之前的逻辑) ---
	$if T is map[string]string {
		mut m_ctx := MapContext{ m: map[string]string{} }
		unsafe {
			C.vphp_array_each(raw_zval, &m_ctx, voidptr(map_callback))
		}
		return m_ctx.m.clone()
	}

	// --- 3. 处理基础类型 ---
	$if T is string {
	  len := 0
		ptr := voidptr(C.vphp_get_string_ptr(val.raw, &len))
		return if ptr != 0 { unsafe { (&char(ptr)).vstring_with_len(len) } } else { '' }
	}

	return T{}
}

// 1. 确保 parse1 后面紧跟 <T>，不要有任何多余的符号
pub fn (ctx Context) parse1[T]() T {
	args := get_args(ctx.ex)
	if args.len < 1 {
		return T{}
	}

	$if T is i64 {
		return args[0].as_int()
	} $else $if T is string {
		return args[0].to_string()
	}
	return T{}
}

// 泛型解析：支持 2 个参数 (使用 T 和 U)
pub fn parse2[T, U](ctx Context) (T, U) {
    args := get_args(ctx.ex)
    if args.len < 2 {
        return T{}, U{}
    }

    mut r1 := T{}
    mut r2 := U{}

    $if T is i64 { r1 = args[0].as_int() }
    $else $if T is string { r1 = args[0].to_string() }

    $if U is i64 { r2 = args[1].as_int() }
    $else $if U is string { r2 = args[1].to_string() }

    return r1, r2
}

// 泛型返回
pub fn return_val[T](ctx Context, val T) {
    unsafe {
        out := Val{ raw: ctx.ret }
        $if T is i64 {
            out.set_int(val)
        } $else $if T is string {
            out.set_string(val)
        }
    }
}

pub fn (ctx Context) has_exception() bool {
    // 检查 Zend 引擎当前是否有待处理的异常
    return C.vphp_has_exception()
}


// 给业务层使用的 Context 方法
pub fn (ctx Context) return_res(ptr voidptr, label string) {
    C.vphp_make_res(ctx.ret, ptr, &char(label.str))
}

// --- 实现 ctx.return_map ---
pub fn (ctx Context) return_map(m map[string]string) {
    C.vphp_return_array_start(ctx.ret)
    for k, v in m {
        C.vphp_array_add_assoc_string(ctx.ret, &char(k.str), &char(v.str))
    }
}

// --- 实现 ctx.return_struct (保姆级全类型版) ---
pub fn (ctx Context) return_struct[T](s T) {
    C.vphp_return_array_start(ctx.ret)

    $for field in T.fields {
        key := field.name
        // 获取字段的值
        val := s.$(field.name)

        $if field.typ is string {
            C.vphp_array_add_assoc_string(ctx.ret, &char(key.str), &char(val.str))
        } $else $if field.typ is f64 {
            C.vphp_array_add_assoc_double(ctx.ret, &char(key.str), val)
        } $else $if field.typ is int || field.typ is i64 {
            C.vphp_array_add_assoc_long(ctx.ret, &char(key.str), i64(val))
        } $else $if field.typ is bool {
            b_val := if val { 1 } else { 0 }
            C.vphp_array_add_assoc_bool(ctx.ret, &char(key.str), b_val)
        }
    }
}

pub fn (ctx Context) return_list[T](list []T) {
	C.vphp_return_array_start(ctx.ret)
	if list.len == 0 {
        return
  }

	for item in list {
		sub_zv := C.zval{}
		C.vphp_return_array_start(&sub_zv)

		// 补全：不仅支持 string 和 f64，还要支持 int 和 bool
		$for field in T.fields {
			key := field.name
			val := item.$(field.name)

			$if field.typ is string {
				C.vphp_array_add_assoc_string(&sub_zv, &char(key.str), &char(val.str))
			} $else $if field.typ is f64 {
				C.vphp_array_add_assoc_double(&sub_zv, &char(key.str), val)
			} $else $if field.typ is int || field.typ is i64 {
				C.vphp_array_add_assoc_long(&sub_zv, &char(key.str), i64(val))
			} $else $if field.typ is bool {
				b_val := if val { 1 } else { 0 }
				C.vphp_array_add_assoc_bool(&sub_zv, &char(key.str), b_val)
			}
		}

		// 塞进主返回数组
		C.vphp_array_add_next_zval(ctx.ret, &sub_zv)
	}
}


// 获取原始 zval 包装对象
pub fn (ctx Context) arg_raw(index int) Val {
    args := get_args(ctx.ex)
    if index >= args.len || index < 0 {
        return unsafe { Val{ raw: 0 } }
    }
    return args[index]
}

// 为 Context 增加一个创建对象的方法
pub fn (ctx Context) return_object(props map[string]string) {
    unsafe {
        C.vphp_object_init(ctx.ret)
        for k, v in props {
            C.vphp_update_property_string(ctx.ret, &char(k.str), k.len, &char(v.str))
        }
    }
}
