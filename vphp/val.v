module vphp
import vphp.zend

pub struct Val {
pub mut:
    raw &C.zval
}

// 给 Val 增加一个 type_id 方法
pub fn (v Val) type_id() int {
    return C.vphp_get_type(v.raw)
}
pub fn (v Val) is_array() bool  { return v.type_id() == int(PHPType.array) }
pub fn (v Val) is_string() bool { return v.type_id() == int(PHPType.string) }
pub fn (v Val) is_long() bool   { return v.type_id() == int(PHPType.long) }
pub fn (v Val) is_double() bool { return v.type_id() == int(PHPType.double) }
pub fn (v Val) is_bool() bool   {
	tid := v.type_id()
	return tid == int(PHPType.false_) || tid == int(PHPType.true_)
}
pub fn (v Val) is_null() bool   { return v.type_id() == int(PHPType.null) }
// 判定是否为对象
pub fn (v Val) is_object() bool { return v.type_id() == int(PHPType.object) }

pub fn (v Val) invoke(args []Val) Val {
	if v.raw == 0 { return unsafe { Val{ raw: 0 } } }

	unsafe {
		// 堆分配保证稳定性
		mut retval := &C.zval(malloc(int(sizeof(C.zval))))
		mut p_args := &&C.zval(nil)
		if args.len > 0 {
			p_args = &args[0].raw
		}

		res := C.vphp_call_callable(v.raw, retval, args.len, p_args)
		if res == -1 {
			return Val{ raw: 0 }
		}
		return Val{ raw: retval }
	}
}

// 给业务层使用的数据提取方法
pub fn (v Val) to_res() voidptr {
    return C.vphp_fetch_res(v.raw)
}

// 获取布尔值的真实值
pub fn (v Val) to_bool() bool {
	return v.type_id() == int(PHPType.true_)
}

pub fn (v Val) type_name() string {
	tid := v.type_id()
	return match tid {
		int(PHPType.undef) { 'undefined' }
		int(PHPType.null) { 'null' }
		int(PHPType.false_) { 'boolean' }
		int(PHPType.true_) { 'boolean' }
		int(PHPType.long) { 'integer' }
		int(PHPType.double) { 'float' }
		int(PHPType.string) { 'string' }
		int(PHPType.array) { 'array' }
		int(PHPType.object) { 'object' }
		else { 'unknown' }
	}
}

// 在 Val 结构体上增加方法调用
pub fn (v Val) call(method string, args []Val) Val {
	if v.raw == 0 || !v.is_object() {
		return unsafe { Val{ raw: 0 } }
	}

	unsafe {
		// 在堆上分配一个 zval 容器，防止栈溢出或总线错误
		mut retval := &C.zval(malloc(int(sizeof(C.zval))))

		// 处理参数指针数组
		mut p_args := &&C.zval(nil)
		if args.len > 0 {
			// 获取 V slice 的首个元素地址（即 &&C.zval）
			p_args = &args[0].raw
		}

		res := C.vphp_call_method(v.raw, &char(method.str), method.len, retval, args.len, p_args)

		if res == -1 { // FAILURE
			return Val{ raw: 0 }
		}

		// 返回包装好的 Val
		return Val{ raw: retval }
	}
}

// 必须加 ! 表示返回 Result，否则 or 块会报错
pub fn (v Val) get(key string) !Val {
    if v.raw == 0 || C.vphp_is_null(v.raw) {
        return error('invalid zval or not an array')
    }
    unsafe {
        res := C.vphp_array_get_key(v.raw, &char(key.str), key.len)
        if res == 0 || C.vphp_is_null(res) {
            return error('key "$key" not found')
        }
        return Val{ raw: res }
    }
}

pub fn (v Val) to_string() string {
    unsafe {
        p := C.vphp_get_strval(v.raw)
        l := C.vphp_get_strlen(v.raw)
        return p.vstring_with_len(l)
    }
}

pub fn (v Val) set_string(s string) {
    unsafe {
        // 使用我们之前在 v_bridge.c 里可能用到的 zend_string_init
        // 或者直接在 vphp.v 声明并调用
        zs := C.zend_string_init(&char(s.str), usize(s.len), 0)
        C.ZVAL_STR(v.raw, zs)
    }
}

pub fn (v Val) as_int() i64 {
    return C.vphp_get_lval(v.raw)
}

// 通用属性获取：返回一个新的 Val
pub fn (v Val) get_prop(name string) Val {
    if !v.is_object() {
        return unsafe { Val{ raw: 0 } }
    }
    res := C.vphp_read_property(v.raw, &char(name.str), name.len)
    return Val{ raw: res }
}

// 快捷方式：直接读取对象属性并转为 string
pub fn (v Val) get_prop_string(name string) string {
    prop := v.get_prop(name)
    if prop.raw == 0 || prop.is_null() { return '' }
    return prop.to_string()
}

// 快捷方式：直接读取对象属性并转为 int
pub fn (v Val) get_prop_int(name string) int {
    prop := v.get_prop(name)
    if prop.raw == 0 { return 0 }
    return int(C.vphp_get_int(prop.raw))
}

pub fn (v Val) set_int(val i64) {
	unsafe {
		C.vphp_set_lval(v.raw, val)
	}
}
