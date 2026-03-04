module main

import vphp

@[php_function]
fn vslim_handle_request(ctx vphp.Context) {
	mut res := SlimResponse{}
	if ctx.num_args() == 1 {
		envelope := ctx.arg[map[string]string](0)
		res = dispatch_demo_request(request_from_envelope(envelope))
	} else {
		method := ctx.arg[string](0)
		raw_path := ctx.arg[string](1)
		body := if ctx.num_args() > 2 { ctx.arg[string](2) } else { '' }
		res = dispatch_demo_request(new_vslim_request(method, raw_path, body).to_slim_request())
	}

	ctx.return_map({
		'status': '${res.status}'
		'body': res.body
		'content_type': res.headers['content-type'] or { '' }
	})
}

@[php_function]
fn vslim_demo_dispatch(ctx vphp.Context) {
	vslim_handle_request(ctx)
}
