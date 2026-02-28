module main

import vphp

@[export: 'v_reverse_string']
fn v_reverse_string(ctx vphp.Context) {
    unsafe {
        raw_in := C.vphp_get_arg_ptr(ctx.ex, 1)
        if raw_in == 0 { return }

        in_val := vphp.Val{ raw: raw_in }

        if !in_val.is_string() {
            vphp.throw_exception('Expected string input', 401)
            return
        }

        s := in_val.to_string()

        if s == '' {
            vphp.throw_exception('String is empty!', 400)
            return
        }

        mut out := vphp.Val{ raw: ctx.ret }
        out.set_string(s.reverse())
    }
}

@[export: 'v_logic_main']
fn v_logic_main(ctx vphp.Context) {
	unsafe {
		args := vphp.get_args(ctx.ex)

		if args.len < 1 {
			vphp.throw_exception('至少需要一个参数', 400)
			return
		}

		main_str := args[0].to_string()

		mut repeat_count := 1
		if args.len >= 2 {
			repeat_count = int(args[1].as_int())
		}

		res := main_str.repeat(repeat_count).reverse()

		out := vphp.Val{ raw: ctx.ret }
		out.set_string(res)
	}
}

@[php_function]
fn v_add(a i64, b i64) i64 {
	return a + b
}

@[php_function]
fn v_greet(name string) string {
	return 'Hello, $name from V pure wrapper!'
}

@[php_function]
fn v_pure_map_test(k string, v string) map[string]string {
	return { k: v }
}


@[export: 'v_process_list']
fn v_process_list(ctx vphp.Context) {
    input_list := ctx.arg[[]string](0)

    unsafe {
        C.vphp_array_init(ctx.ret)

        for i := input_list.len - 1; i >= 0; i-- {
            val := input_list[i]
            C.vphp_array_push_string(ctx.ret, &char(val.str))
        }
    }
}

@[export: 'v_test_map']
fn v_test_map(ctx vphp.Context) {
    config := ctx.arg[map[string]string](0)

    if 'name' in config {
        println('Received name: ' + config['name'])
    }

    ctx.return_string('Map processed, keys: $config.keys()')
}

@[export: 'v_get_config']
fn v_get_config(ctx vphp.Context) {
	input := ctx.arg_raw(0)

	db_val := input.get('db_name') or {
		vphp.report_error(vphp.e_warning, 'db_name is missing, using default')
		ctx.return_string('bullsoft_db')
		return
	}

	ctx.return_string(db_val.to_string())
}

@[export: 'v_get_user']
fn v_get_user(ctx vphp.Context) {
  	raw_id := ctx.arg_raw(0)
  	println('DEBUG: PHP ID Type: ${raw_id.type_id()}')

  	user_id := ctx.arg[i64](0)

    mut user_data := map[string]string{}
    user_data['id'] = user_id.str()
    user_data['name'] = 'Gu Weigang'
    user_data['role'] = 'Developer'
    user_data['company'] = 'Bullsoft'

    ctx.return_object(user_data)
}


@[export: 'v_call_back']
fn v_call_back(ctx vphp.Context) {
    php_version := vphp.call_php('phpversion', [])

    ctx.return_string('V knows PHP version is: ' + php_version.to_string())
}

@[export: 'v_complex_test']
fn v_complex_test(ctx vphp.Context) {
	s    := ctx.arg[string](0)
	i    := ctx.arg[int](1)
	b    := ctx.arg[bool](2)
	list := ctx.arg[[]f64](3)

	if ctx.has_exception() { return }

	mut res := map[string]string{}
	res['str_val']  = s
	res['int_val']  = i.str()
	res['bool_val'] = b.str()
	res['list_len'] = list.len.str()

	ctx.return_map(res)
}

@[export: 'v_analyze_user_object']
fn v_analyze_user_object(ctx vphp.Context) {
    user_obj := ctx.arg_raw(0)

    if !user_obj.is_object() {
        vphp.throw_exception('Expected object, got ${user_obj.type_name()}', 0)
        return
    }

    name := user_obj.get_prop_string('name')
    age  := user_obj.get_prop_int('age')

    if ctx.has_exception() { return }

    res_msg := 'V 侧收到对象数据：姓名=$name, 年龄=$age'
    ctx.return_string(res_msg)
}

@[export: 'v_trigger_user_action']
fn v_trigger_user_action(ctx vphp.Context) {
	user_obj := ctx.arg_raw(0)
	if !user_obj.is_object() {
		vphp.throw_exception('需要 User 对象', 0)
		return
	}

	mut score_val := vphp.Val{ raw: C.vphp_new_zval() }
	score_val.set_int(100)

	res := user_obj.call('updateScore', [score_val])

	if ctx.has_exception() { return }

	ctx.return_string('Action triggered, PHP returned: ' + res.to_string())
}

@[export: 'v_call_php_closure']
fn v_call_php_closure(ctx vphp.Context) {
	cb := ctx.arg_raw(0)

	mut msg := vphp.Val{ raw: C.vphp_new_zval() }
	msg.set_string('Message from V Engine')

	res := cb.invoke([msg])

	if ctx.has_exception() { return }

	ctx.return_string('Closure executed, PHP said: ' + res.to_string())
}
