module main

import vphp

// 只有这一行，因为我们要用 C.zval 这个类型定义
#include <php.h>
#include "../vphp/v_bridge.h"

@[export: 'v_reverse_string']
fn v_reverse_string(z_in &C.zval, z_out &C.zval) {
	unsafe {
		in_val := vphp.Val{ raw: z_in }
		out_val := vphp.Val{ raw: z_out }

		s := in_val.to_string()

		if s == '' {
			vphp.throw_exception('String is empty!', 400)
			return
		}

		out_val.set_string(s.reverse())
	}
}

@[export: 'v_logic_main']
fn v_logic_main(ex &C.zend_execute_data, retval &C.zval) {
	unsafe {
		// 1. 像 ext-php-rs 一样优雅地获取参数
		args := vphp.get_args(ex)

		if args.len < 1 {
			vphp.throw_exception('至少需要一个参数', 400)
			return
		}

		// 2. 业务逻辑
		main_str := args[0].to_string()

		mut repeat_count := 1
		if args.len >= 2 {
			repeat_count = int(args[1].as_int())
		}

		res := main_str.repeat(repeat_count).reverse()

		// 3. 设置返回值
		out := vphp.Val{ raw: retval }
		out.set_string(res)
	}
}

@[export: 'v_add']
fn v_add(ex &C.zend_execute_data, retval &C.zval) {
	ctx := vphp.new_context(ex, retval)

	// 这里的业务逻辑依然保持清爽的原生感
	a := ctx.arg[i64](0)
	b := ctx.arg[i64](1)

	vphp.return_val[i64](ctx, a + b)
}

@[export: 'v_greet']
fn v_greet(ex &C.zend_execute_data, retval &C.zval) {
	ctx := vphp.new_context(ex, retval)
	name := ctx.arg[string](0)

	vphp.return_val[string](ctx, 'Hello, $name from V!')
}


@[export: 'v_process_list']
fn v_process_list(ex &C.zend_execute_data, retval &C.zval) {
    ctx := vphp.new_context(ex, retval)

    // 1. 从 PHP 拿到原生 V 数组
    input_list := ctx.arg[[]string](0)

    // 调试：打印输入长度
    // println('Input size: $input_list.len')

    unsafe {
        C.vphp_array_init(retval)

        // 2. 显式倒序遍历
        // 如果 input_list 是 ["a", "b", "c"]
        // i 将会是 2, 1, 0
        for i := input_list.len - 1; i >= 0; i-- {
            val := input_list[i]
            // println('Adding to PHP: $val')
            C.vphp_array_push_string(retval, &char(val.str))
        }
    }
}

@[export: 'v_test_map']
fn v_test_map(ex &C.zend_execute_data, retval &C.zval) {
    ctx := vphp.new_context(ex, retval)

    // 自动转换！
    config := ctx.arg[map[string]string](0)

    if 'name' in config {
        println('Received name: ' + config['name'])
    }

    // 返回一个简单的确认字符串
    ctx.return_string('Map processed, keys: $config.keys()')
}

@[export: 'v_get_config']
fn v_get_config(ex &C.zend_execute_data, retval &C.zval) {
	ctx := vphp.new_context(ex, retval)

	input := ctx.arg_raw(0)

	// get 现在返回 !Val，可以用 or 处理
	db_val := input.get('db_name') or {
		vphp.report_error(vphp.e_warning, 'db_name is missing, using default')
		ctx.return_string('bullsoft_db')
		return // 必须退出函数，否则 db_val 没赋值
	}

	ctx.return_string(db_val.to_string())
}

@[export: 'v_get_user']
fn v_get_user(ex &C.zend_execute_data, retval &C.zval) {
  	ctx := vphp.new_context(ex, retval)

  	raw_id := ctx.arg_raw(0)
  	// 修正：调用我们封装好的 type_id()
  	println('DEBUG: PHP ID Type: ${raw_id.type_id()}')

  	user_id := ctx.arg[i64](0)

    mut user_data := map[string]string{}
    user_data['id'] = user_id.str() // 确保这里不是 0
    user_data['name'] = 'Gu Weigang'
    user_data['role'] = 'Developer'
    user_data['company'] = 'Bullsoft'

    // 返回对象
    ctx.return_object(user_data)
}


@[export: 'v_call_back']
fn v_call_back(ex &C.zend_execute_data, retval &C.zval) {
    ctx := vphp.new_context(ex, retval)

    // 让 V 告诉 PHP：帮我算个哈希
    // 注意：这里需要更复杂的参数包装逻辑，我们先演示无参调用
    php_version := vphp.call_php('phpversion', [])

    ctx.return_string('V knows PHP version is: ' + php_version.to_string())
}


struct Coach { mut: name string }
struct Database { mut: connected bool }

// 创建“教练”资源
@[export: 'v_new_coach']
fn v_new_coach(ex &C.zend_execute_data, retval &C.zval) {
    ctx := vphp.new_context(ex, retval)
    unsafe {
        p := malloc(sizeof(Coach))
        mut c := &Coach(p)
        c.name = 'Bullsoft_Master'
        ctx.return_res(p, 'coach') // 贴上标签 'coach'
    }
}

// 创建“数据库”资源
@[export: 'v_new_db']
fn v_new_db(ex &C.zend_execute_data, retval &C.zval) {
    ctx := vphp.new_context(ex, retval)
    unsafe {
        p := malloc(sizeof(Database))
        mut db := &Database(p)
        db.connected = true
        ctx.return_res(p, 'db') // 贴上标签 'db'
    }
}

// 使用资源
@[export: 'v_check_res']
fn v_check_res(ex &C.zend_execute_data, retval &C.zval) {
    ctx := vphp.new_context(ex, retval)
    res_val := ctx.arg_raw(0)

    unsafe {
        ptr := res_val.to_res()
        if ptr == nil {
            ctx.return_string('Invalid Resource')
            return
        }
        // 这里你依然可以根据业务逻辑来决定如何转换
        // 比如如果你的业务知道这里该传 Coach
        mut coach := &Coach(ptr)
        ctx.return_string('Hello, ' + coach.name)
    }
}

// 定义一个分析结果结构体，方便返回
struct MotionReport {
	user_name   string
	max_hr      f64
	min_hr      f64
	avg_hr      f64
	risk_level  string
	device_mode string
}

@[export: 'v_analyze_fitness_data']
fn v_analyze_fitness_data(ex &C.zend_execute_data, retval &C.zval) {
	ctx := vphp.new_context(ex, retval)

	// 获取数据
	name    := ctx.arg[string](0)
	hr_data := ctx.arg[[]f64](1) // 现在这里会返回真实的 []f64
	config  := ctx.arg[map[string]string](2)
	// 重点：如果 arg[T] 内部抛了异常，立刻退出，不执行后续逻辑
  if ctx.has_exception() { return }

	// 数据校验
	if hr_data.len == 0 {
		ctx.return_string('Error: No heart rate data provided')
		return
	}

	mut total := 0.0
	mut max := 0.0
	mut min := hr_data[0]

	for hr in hr_data {
		total += hr
		if hr > max { max = hr }
		if hr < min { min = hr }
	}

	avg := total / f64(hr_data.len)
	mode := config['mode'] or { 'standard' }

	mut risk := 'Low'
	if max > 170 {
		risk = 'High Risk'
	}

	// 封装结果
	report := MotionReport{
		user_name:   name
		max_hr:      max
		min_hr:      min
		avg_hr:      avg
		risk_level:  risk
		device_mode: mode
	}
	ctx.return_struct(report)
	// 格式化输出
	// res_str := 'User ${report.user_name} (${report.device_mode}): Avg HR is ${report.avg_hr:.2f}. Risk: ${report.risk_level}'
	// ctx.return_string(res_str)
}

struct HeartPoint {
	timestamp int
	hr        f64
}

struct FinalReport {
	user_name string
	alerts    []HeartPoint
}

@[export: 'v_get_alerts']
fn v_get_alerts(ex &C.zend_execute_data, retval &C.zval) {
	ctx := vphp.new_context(ex, retval)

	mut alerts := []HeartPoint{}
	alerts << HeartPoint{ 1677481200, 155.0 }
	alerts << HeartPoint{ 1677481260, 162.5 }

	// 如果 PHP 侧想要数组，用 return_list
	ctx.return_list(alerts)
}

@[export: 'v_complex_test']
fn v_complex_test(ex &C.zend_execute_data, retval &C.zval) {
	ctx := vphp.new_context(ex, retval)

	s    := ctx.arg[string](0)
	i    := ctx.arg[int](1)
	b    := ctx.arg[bool](2)
	list := ctx.arg[[]f64](3)

	if ctx.has_exception() { return }

	// 返回一个格式化的 Map 展示 V 接收到的真实数据
	mut res := map[string]string{}
	res['str_val']  = s
	res['int_val']  = i.str()
	res['bool_val'] = b.str()
	res['list_len'] = list.len.str()

	ctx.return_map(res)
}

@[export: 'v_analyze_user_object']
fn v_analyze_user_object(ex &C.zend_execute_data, retval &C.zval) {
    ctx := vphp.new_context(ex, retval)

    // 获取第一个参数（预期是一个 PHP 对象）
    user_obj := ctx.arg_raw(0)

    // 类型安全检查
    if !user_obj.is_object() {
        vphp.throw_exception('Expected object, got ${user_obj.type_name()}', 0)
        return
    }

    // 像在 PHP 里写 $user->name 和 $user->age 一样简单
    name := user_obj.get_prop_string('name')
    age  := user_obj.get_prop_int('age')

    if ctx.has_exception() { return }

    res_msg := 'V 侧收到对象数据：姓名=$name, 年龄=$age'
    ctx.return_string(res_msg)
}

@[export: 'v_trigger_user_action']
fn v_trigger_user_action(ex &C.zend_execute_data, retval &C.zval) {
	ctx := vphp.new_context(ex, retval)

	// 1. 获取 PHP 传来的对象
	user_obj := ctx.arg_raw(0)
	if !user_obj.is_object() {
		vphp.throw_exception('需要 User 对象', 0)
		return
	}

	// 2. 准备参数（将 V 的 i64 转为 PHP zval）
	// 我们需要一个临时创建 zval 的工具，或者直接用 ctx 里的逻辑
	mut score_val := vphp.Val{ raw: C.vphp_new_zval() }
	score_val.set_int(100)

	// 3. 调用 $user->updateScore(100)
	res := user_obj.call('updateScore', [score_val])

	if ctx.has_exception() { return }

	ctx.return_string('Action triggered, PHP returned: ' + res.to_string())
}
