module vphp

#include <php.h>
#include "v_bridge.h"

@[typedef]
pub struct C.zval {}
@[typedef]
pub struct C.zend_execute_data {}

// 1. 定义枚举（如前所述）
pub enum PHPType {
	undef     = 0
	null      = 1
	false_    = 2
	true_     = 3
	long      = 4
	double    = 5
	string    = 6
	array     = 7
	object    = 8
	resource  = 9
	reference = 10
}

pub struct ExtensionConfig {
pub:
	name        string
	version     string
	description string
}

// 声明我们在 v_bridge.c 里写的代理函数
fn C.vphp_get_num_args(ex &C.zend_execute_data) u32
fn C.vphp_get_arg_ptr(ex &C.zend_execute_data, index u32) &C.zval
fn C.vphp_throw(msg &char, code int)
fn C.vphp_get_strval(z &C.zval) &char
fn C.vphp_get_strlen(z &C.zval) int
fn C.vphp_get_lval(z &C.zval) i64
fn C.zend_string_init(str &char, len usize, p int) voidptr
fn C.ZVAL_STR(z &C.zval, s voidptr)

fn C.vphp_error(int, &char)
fn C.vphp_is_null(z &C.zval) bool
fn C.vphp_object_init(z &C.zval)
fn C.vphp_update_property_string(obj &C.zval, name &char, name_len int, value &char)
fn C.vphp_update_property_long(obj &C.zval, name &char, name_len int, value i64)
fn C.vphp_call_php_func(name &char, len int, retval &C.zval, p_count int, params &&C.zval) int
fn C.vphp_get_type(z &C.zval) int
fn C.vphp_get_int(z &C.zval) i64  // 映射到 C 侧的 long
fn C.vphp_get_double(z &C.zval) f64
fn C.vphp_get_string_ptr(z &C.zval, len &int) &char

// Resource
fn C.vphp_make_res(ret &C.zval, ptr voidptr, label &char)
fn C.vphp_fetch_res(z &C.zval) voidptr
fn C.vphp_init_resource_system(module_number int)

// Array
fn C.vphp_array_count(z &C.zval) int
fn C.vphp_array_get_index(z &C.zval, index u32) &C.zval
fn C.vphp_array_init(z &C.zval)
fn C.vphp_array_add_assoc_string(z &C.zval, key &char, val &char)
fn C.vphp_array_push_string(z &C.zval, val &char)
fn C.vphp_array_push_double(z &C.zval, val f64)
fn C.vphp_array_push_long(z &C.zval, val long)
fn C.vphp_array_each(z &C.zval, ctx voidptr, cb voidptr)
fn C.vphp_array_get_key(z &C.zval, key &char, len int) &C.zval
fn C.vphp_array_foreach(z &C.zval, ctx voidptr, cb voidptr)
fn C.vphp_array_get_index(z &C.zval, index u32) &C.zval
fn C.vphp_return_array_start(res &C.zval)
fn C.vphp_array_add_assoc_double(res &C.zval, key &char, val f64)
fn C.vphp_array_add_assoc_long(res &C.zval, key &char, val i64)
fn C.vphp_array_add_assoc_bool(res &C.zval, key &char, val int)
fn C.vphp_array_add_next_zval(main_array &C.zval, sub_item &C.zval)
fn C.vphp_has_exception() bool
fn C.vphp_get_bool(z &C.zval) bool
fn C.vphp_read_property(obj &C.zval, name &char, len int) &C.zval
fn C.vphp_call_method(obj &C.zval, method &char, len int, retval &C.zval, p_count int, params &&C.zval) int
fn C.vphp_new_zval() &C.zval
fn C.vphp_call_callable(callable &C.zval, retval &C.zval, p_count int, params &&C.zval) int


// 错误级别常量映射
pub const e_error = 1     // E_ERROR (会导致 PHP 脚本中止)
pub const e_warning = 2   // E_WARNING
pub const e_notice = 8    // E_NOTICE

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
// pub fn (v Val) is_null() bool {
// 	return C.vphp_is_null(v.raw)
// }

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

// 框架初始化
pub fn init_framework(module_number int) {
  unsafe {
    C.vphp_init_resource_system(module_number)
  }
}

@[export: 'vphp_framework_init']
fn vphp_framework_init(module_number int) {
    // 自动初始化资源系统
    init_framework(module_number)

    // 这里的并发任务注册逻辑也可以放在这里
    println('VPHP Framework initialized.')
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

// 主动向 PHP 报告错误
pub fn report_error(level int, msg string) {
  unsafe {
    C.vphp_error(level, &char(msg.str))
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

pub fn get_args(ex &C.zend_execute_data) []Val {
    num := int(C.vphp_get_num_args(ex))
    mut res := []Val{}
    for i in 1 .. (num + 1) { // PHP 参数从 1 开始
        res << Val{ raw: C.vphp_get_arg_ptr(ex, u32(i)) }
    }
    return res
}

pub fn throw_exception(msg string, code int) {
    unsafe { C.vphp_throw(&char(msg.str), code) }
}


// 声明 C 代理函数
fn C.vphp_set_lval(z &C.zval, val i64)

pub fn (v Val) set_int(val i64) {
	unsafe {
		C.vphp_set_lval(v.raw, val)
	}
}

// --- 原生包装器 ---

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

pub fn new_context(ex &C.zend_execute_data, ret &C.zval) Context {
	return unsafe {
		Context{
			ex: ex
			ret: ret
		}
	}
}

struct MapContext {
mut:
	m map[string]string
}

// 2. 修改 map_callback 的定义，让它的第一个参数是 voidptr
fn map_callback(p_ctx voidptr, key &char, val &C.zval) {
    // 手动转回 MapContext 指针
    mut ctx := unsafe { &MapContext(p_ctx) }

    v_key := unsafe { key.vstring() }
    v_val := unsafe { Val{ raw: val }.to_string() }

    // 直接操作
    ctx.m[v_key] = v_val
}

pub fn call_php(name string, args []Val) Val {
	unsafe {
		mut retval := C.zval{}
		// 修正：V 不允许 &&C.zval(0)，我们改用这种方式
		mut p_args := &&C.zval( nil )
		if args.len > 0 {
			p_args = &args[0].raw
		}

		C.vphp_call_php_func(&char(name.str), name.len, &retval, args.len, p_args)
		return Val{ raw: &retval }
	}
}


// 因为 C 不懂泛型，我们通过 voidptr 传递 V 数组的地址
fn array_push_handler[T](mut res []T, val &C.zval) {
    $if T is f64 {
        res << C.vphp_get_double(val)
    } $else $if T is int || T is i64 {
        res << i64(C.vphp_get_int(val))
    } $else $if T is string {
        res << C.vphp_get_string(val).v_str() // 假设你已有 zval 转 string 的封装
    }
}

pub fn (ctx Context) has_exception() bool {
    // 检查 Zend 引擎当前是否有待处理的异常
    return C.vphp_has_exception()
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

// Spawn 支持
// 1. 定义通用任务接口
pub interface ITask {
	run() []f64 // 目前以 []f64 为通用返回类型，后续可扩展
}

// 2. 异步结果包装器（已存在）
pub struct AsyncResult {
pub mut:
	handle thread []f64
}

// 3. 框架级导出：v_spawn
// 这里的挑战是：PHP 层调用 v_spawn 时，如何指定运行哪个 Task？
// 我们可以通过一个简单的“任务注册表”来实现。
type TaskCreator = fn () ITask

// 使用 __global (需要编译时加 -enable-globals) 或者使用单例指针
// 这里我们用一个更符合 V 规范的方式：定义一个结构体来持有 map
struct TaskRegistry {
pub mut:
	tasks map[string]TaskCreator
}

// 获取单例注册表
// 修复：定义一个全局指针 (需要 build.v 开启 -enable-globals)
__global (
	g_registry &TaskRegistry
)

fn get_registry() &TaskRegistry {
	unsafe {
		// 如果指针为空，则初始化
		if g_registry == 0 {
			g_registry = &TaskRegistry{
				tasks: map[string]TaskCreator{}
			}
		}
		return g_registry
	}
}

pub fn ITask.register(name string, creator TaskCreator) {
	mut r := get_registry()
	r.tasks[name] = creator
}

pub fn ITask.get_creator(name string) ?TaskCreator {
	r := get_registry()
	if name in r.tasks {
		return r.tasks[name]
	}
	return none
}


@[export: 'v_spawn']
fn framework_v_spawn(ex &C.zend_execute_data, retval &C.zval) {
	ctx := new_context(ex, retval)
	task_name := ctx.arg[string](0)

	// 使用新的 get_creator 逻辑
	creator := ITask.get_creator(task_name) or {
		throw_exception('Task $task_name not registered', 0)
		return
	}

	task_inst := creator()
	// 注意：spawn 接口方法时，V 有时需要明确返回值类型
	t := spawn task_inst.run()

	unsafe {
		mut res := &AsyncResult(malloc(int(sizeof(AsyncResult))))
		res.handle = t
		ctx.return_res(res, 'v_task')
	}
}

@[export: 'v_wait']
fn framework_v_wait(ex &C.zend_execute_data, retval &C.zval) {
	ctx := new_context(ex, retval)
	res_val := ctx.arg_raw(0)

	unsafe {
		ptr := res_val.to_res()
		if ptr == nil { return }

		mut task := &AsyncResult(ptr)
		results := task.handle.wait()

		C.vphp_return_array_start(retval)
		for r in results {
			// 显式转换 f64 -> f64 (解决 double 报错)
			C.vphp_array_push_double(retval, f64(r))
		}
	}
}
