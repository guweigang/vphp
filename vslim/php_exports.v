module main

import vphp

@[php_function]
fn vslim_handle_request(ctx vphp.Context) {
	mut res := VSlimResponse{}
	if ctx.num_args() == 1 {
		envelope := ctx.arg_raw(0)
		res = dispatch_demo_request(request_from_envelope(envelope))
	} else {
		method := ctx.arg[string](0)
		raw_path := ctx.arg[string](1)
		body := if ctx.num_args() > 2 { ctx.arg[string](2) } else { '' }
		res = dispatch_demo_request(new_vslim_request(method, raw_path, body).to_vslim_request())
	}

	ctx.return_map({
		'status': '${res.status}'
		'body': res.body
		'content_type': res.content_type
	})
}

@[php_function]
fn vslim_demo_dispatch(ctx vphp.Context) {
	vslim_handle_request(ctx)
}

@[php_function]
fn vslim_response_headers(ctx vphp.Context) {
	raw := ctx.arg_raw(0)
	if !raw.is_valid() || !raw.is_object() {
		ctx.return_map(map[string]string{})
		return
	}
	if resp := raw.to_object[VSlimResponse]() {
		ctx.return_val(resp.headers())
		return
	}
	ctx.return_map(map[string]string{})
}
