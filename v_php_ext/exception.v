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
