module main

import vphp

#include "php_bridge.h"

@[export: 'VSlimRouteGroup_new_raw']
pub fn vslimroutegroup_new_raw() voidptr {
    return vphp.generic_new_raw[VSlimRouteGroup]()
}
@[export: 'VSlimRouteGroup_get_prop']
pub fn vslimroutegroup_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &VSlimRouteGroup(ptr)
    }
}
@[export: 'VSlimRouteGroup_set_prop']
pub fn vslimroutegroup_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &VSlimRouteGroup(ptr)
        arg := vphp.ZVal{ raw: value }
    }
}
@[export: 'VSlimRouteGroup_sync_props']
pub fn vslimroutegroup_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &VSlimRouteGroup(ptr)
        out := vphp.ZVal{ raw: zv }
        out.add_property_string('prefix', obj.prefix)
    }
}
@[export: 'vphp_wrap_VSlimRouteGroup_group']
pub fn vphp_wrap_vslimroutegroup_group(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRouteGroup(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.group(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRouteGroup_middleware']
pub fn vphp_wrap_vslimroutegroup_middleware(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRouteGroup(ptr) }
    arg_0 := ctx.arg_val(0)
    res := recv.middleware(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRouteGroup_get']
pub fn vphp_wrap_vslimroutegroup_get(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRouteGroup(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.get(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRouteGroup_post']
pub fn vphp_wrap_vslimroutegroup_post(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRouteGroup(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.post(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRouteGroup_put']
pub fn vphp_wrap_vslimroutegroup_put(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRouteGroup(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.put(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRouteGroup_patch']
pub fn vphp_wrap_vslimroutegroup_patch(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRouteGroup(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.patch(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRouteGroup_delete']
pub fn vphp_wrap_vslimroutegroup_delete(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRouteGroup(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.delete(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRouteGroup_any']
pub fn vphp_wrap_vslimroutegroup_any(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRouteGroup(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.any(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRouteGroup_get_named']
pub fn vphp_wrap_vslimroutegroup_get_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRouteGroup(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.get_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRouteGroup_post_named']
pub fn vphp_wrap_vslimroutegroup_post_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRouteGroup(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.post_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRouteGroup_put_named']
pub fn vphp_wrap_vslimroutegroup_put_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRouteGroup(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.put_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRouteGroup_patch_named']
pub fn vphp_wrap_vslimroutegroup_patch_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRouteGroup(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.patch_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRouteGroup_delete_named']
pub fn vphp_wrap_vslimroutegroup_delete_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRouteGroup(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.delete_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRouteGroup_any_named']
pub fn vphp_wrap_vslimroutegroup_any_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRouteGroup(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.any_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'VSlimRouteGroup_handlers']
pub fn vslimroutegroup_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(vslimroutegroup_get_prop)
        write_handler: voidptr(vslimroutegroup_set_prop)
        sync_handler:  voidptr(vslimroutegroup_sync_props)
        new_raw:       voidptr(vslimroutegroup_new_raw)
    } }
}

@[export: 'VSlimRequest_new_raw']
pub fn vslimrequest_new_raw() voidptr {
    return vphp.generic_new_raw[VSlimRequest]()
}
@[export: 'VSlimRequest_get_prop']
pub fn vslimrequest_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &VSlimRequest(ptr)
        if name == 'method' {
            vphp.return_val_raw(rv, obj.method)
            return
        }
        if name == 'raw_path' {
            vphp.return_val_raw(rv, obj.raw_path)
            return
        }
        if name == 'path' {
            vphp.return_val_raw(rv, obj.path)
            return
        }
        if name == 'body' {
            vphp.return_val_raw(rv, obj.body)
            return
        }
        if name == 'query_string' {
            vphp.return_val_raw(rv, obj.query_string)
            return
        }
        if name == 'scheme' {
            vphp.return_val_raw(rv, obj.scheme)
            return
        }
        if name == 'host' {
            vphp.return_val_raw(rv, obj.host)
            return
        }
        if name == 'port' {
            vphp.return_val_raw(rv, obj.port)
            return
        }
        if name == 'protocol_version' {
            vphp.return_val_raw(rv, obj.protocol_version)
            return
        }
        if name == 'remote_addr' {
            vphp.return_val_raw(rv, obj.remote_addr)
            return
        }
    }
}
@[export: 'VSlimRequest_set_prop']
pub fn vslimrequest_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &VSlimRequest(ptr)
        arg := vphp.ZVal{ raw: value }
        if name == 'method' {
            obj.method = arg.get_string()
            return
        }
        if name == 'raw_path' {
            obj.raw_path = arg.get_string()
            return
        }
        if name == 'path' {
            obj.path = arg.get_string()
            return
        }
        if name == 'body' {
            obj.body = arg.get_string()
            return
        }
        if name == 'query_string' {
            obj.query_string = arg.get_string()
            return
        }
        if name == 'scheme' {
            obj.scheme = arg.get_string()
            return
        }
        if name == 'host' {
            obj.host = arg.get_string()
            return
        }
        if name == 'port' {
            obj.port = arg.get_string()
            return
        }
        if name == 'protocol_version' {
            obj.protocol_version = arg.get_string()
            return
        }
        if name == 'remote_addr' {
            obj.remote_addr = arg.get_string()
            return
        }
    }
}
@[export: 'VSlimRequest_sync_props']
pub fn vslimrequest_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &VSlimRequest(ptr)
        out := vphp.ZVal{ raw: zv }
        out.add_property_string('method', obj.method)
        out.add_property_string('raw_path', obj.raw_path)
        out.add_property_string('path', obj.path)
        out.add_property_string('body', obj.body)
        out.add_property_string('query_string', obj.query_string)
        out.add_property_string('scheme', obj.scheme)
        out.add_property_string('host', obj.host)
        out.add_property_string('port', obj.port)
        out.add_property_string('protocol_version', obj.protocol_version)
        out.add_property_string('remote_addr', obj.remote_addr)
    }
}
@[export: 'vphp_wrap_VSlimRequest_construct']
pub fn vphp_wrap_vslimrequest_construct(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg[string](2)
    res := recv.construct(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_str']
pub fn vphp_wrap_vslimrequest_str(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    res := recv.str()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_set_query']
pub fn vphp_wrap_vslimrequest_set_query(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg_val(0)
    res := recv.set_query(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_headers']
pub fn vphp_wrap_vslimrequest_set_headers(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg_val(0)
    res := recv.set_headers(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_cookies']
pub fn vphp_wrap_vslimrequest_set_cookies(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg_val(0)
    res := recv.set_cookies(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_attributes']
pub fn vphp_wrap_vslimrequest_set_attributes(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg_val(0)
    res := recv.set_attributes(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_server']
pub fn vphp_wrap_vslimrequest_set_server(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg_val(0)
    res := recv.set_server(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_uploaded_files']
pub fn vphp_wrap_vslimrequest_set_uploaded_files(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg_val(0)
    res := recv.set_uploaded_files(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_params']
pub fn vphp_wrap_vslimrequest_set_params(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg_val(0)
    res := recv.set_params(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_query']
pub fn vphp_wrap_vslimrequest_query(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.query(arg_0)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_has_query']
pub fn vphp_wrap_vslimrequest_has_query(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.has_query(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_header']
pub fn vphp_wrap_vslimrequest_header(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.header(arg_0)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_has_header']
pub fn vphp_wrap_vslimrequest_has_header(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.has_header(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_content_type']
pub fn vphp_wrap_vslimrequest_content_type(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    res := recv.content_type()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_cookie']
pub fn vphp_wrap_vslimrequest_cookie(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.cookie(arg_0)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_has_cookie']
pub fn vphp_wrap_vslimrequest_has_cookie(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.has_cookie(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_param']
pub fn vphp_wrap_vslimrequest_param(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.param(arg_0)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_has_param']
pub fn vphp_wrap_vslimrequest_has_param(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.has_param(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_attribute']
pub fn vphp_wrap_vslimrequest_attribute(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.attribute(arg_0)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_has_attribute']
pub fn vphp_wrap_vslimrequest_has_attribute(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.has_attribute(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_server_value']
pub fn vphp_wrap_vslimrequest_server_value(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.server_value(arg_0)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_has_server']
pub fn vphp_wrap_vslimrequest_has_server(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.has_server(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_uploaded_file_count']
pub fn vphp_wrap_vslimrequest_uploaded_file_count(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    res := recv.uploaded_file_count()
    ctx.return_val[int](res)
}
@[export: 'vphp_wrap_VSlimRequest_is_secure']
pub fn vphp_wrap_vslimrequest_is_secure(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    res := recv.is_secure()
    ctx.return_val[bool](res)
}
@[export: 'VSlimRequest_handlers']
pub fn vslimrequest_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(vslimrequest_get_prop)
        write_handler: voidptr(vslimrequest_set_prop)
        sync_handler:  voidptr(vslimrequest_sync_props)
        new_raw:       voidptr(vslimrequest_new_raw)
    } }
}

@[export: 'VSlimResponse_new_raw']
pub fn vslimresponse_new_raw() voidptr {
    return vphp.generic_new_raw[VSlimResponse]()
}
@[export: 'VSlimResponse_get_prop']
pub fn vslimresponse_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &VSlimResponse(ptr)
        if name == 'status' {
            vphp.return_val_raw(rv, i64(obj.status))
            return
        }
        if name == 'body' {
            vphp.return_val_raw(rv, obj.body)
            return
        }
        if name == 'content_type' {
            vphp.return_val_raw(rv, obj.content_type)
            return
        }
    }
}
@[export: 'VSlimResponse_set_prop']
pub fn vslimresponse_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &VSlimResponse(ptr)
        arg := vphp.ZVal{ raw: value }
        if name == 'status' {
            obj.status = int(arg.get_int())
            return
        }
        if name == 'body' {
            obj.body = arg.get_string()
            return
        }
        if name == 'content_type' {
            obj.content_type = arg.get_string()
            return
        }
    }
}
@[export: 'VSlimResponse_sync_props']
pub fn vslimresponse_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &VSlimResponse(ptr)
        out := vphp.ZVal{ raw: zv }
        out.add_property_long('status', i64(obj.status))
        out.add_property_string('body', obj.body)
        out.add_property_string('content_type', obj.content_type)
    }
}
@[export: 'vphp_wrap_VSlimResponse_construct']
pub fn vphp_wrap_vslimresponse_construct(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    arg_0 := ctx.arg[int](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg[string](2)
    res := recv.construct(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_header']
pub fn vphp_wrap_vslimresponse_header(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimResponse(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.header(arg_0)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimResponse_has_header']
pub fn vphp_wrap_vslimresponse_has_header(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimResponse(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.has_header(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimResponse_set_header']
pub fn vphp_wrap_vslimresponse_set_header(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    res := recv.set_header(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_set_content_type']
pub fn vphp_wrap_vslimresponse_set_content_type(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.set_content_type(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_cookie_header']
pub fn vphp_wrap_vslimresponse_cookie_header(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimResponse(ptr) }
    res := recv.cookie_header()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimResponse_set_cookie']
pub fn vphp_wrap_vslimresponse_set_cookie(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    res := recv.set_cookie(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_set_cookie_opts']
pub fn vphp_wrap_vslimresponse_set_cookie_opts(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg[string](2)
    res := recv.set_cookie_opts(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_set_cookie_full']
pub fn vphp_wrap_vslimresponse_set_cookie_full(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg[string](2)
    arg_3 := ctx.arg[string](3)
    arg_4 := ctx.arg[int](4)
    arg_5 := ctx.arg[bool](5)
    arg_6 := ctx.arg[bool](6)
    arg_7 := ctx.arg[string](7)
    res := recv.set_cookie_full(arg_0, arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_delete_cookie']
pub fn vphp_wrap_vslimresponse_delete_cookie(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.delete_cookie(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_with_status']
pub fn vphp_wrap_vslimresponse_with_status(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    arg_0 := ctx.arg[int](0)
    res := recv.with_status(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_text']
pub fn vphp_wrap_vslimresponse_text(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.text(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_json']
pub fn vphp_wrap_vslimresponse_json(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.json(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_html']
pub fn vphp_wrap_vslimresponse_html(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.html(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_redirect']
pub fn vphp_wrap_vslimresponse_redirect(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.redirect(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_redirect_with_status']
pub fn vphp_wrap_vslimresponse_redirect_with_status(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[int](1)
    res := recv.redirect_with_status(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_str']
pub fn vphp_wrap_vslimresponse_str(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimResponse(ptr) }
    res := recv.str()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimResponse_content_length']
pub fn vphp_wrap_vslimresponse_content_length(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimResponse(ptr) }
    res := recv.content_length()
    ctx.return_val[int](res)
}
@[export: 'VSlimResponse_handlers']
pub fn vslimresponse_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(vslimresponse_get_prop)
        write_handler: voidptr(vslimresponse_set_prop)
        sync_handler:  voidptr(vslimresponse_sync_props)
        new_raw:       voidptr(vslimresponse_new_raw)
    } }
}

@[export: 'VSlimApp_new_raw']
pub fn vslimapp_new_raw() voidptr {
    return vphp.generic_new_raw[VSlimApp]()
}
@[export: 'VSlimApp_get_prop']
pub fn vslimapp_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &VSlimApp(ptr)
    }
}
@[export: 'VSlimApp_set_prop']
pub fn vslimapp_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &VSlimApp(ptr)
        arg := vphp.ZVal{ raw: value }
    }
}
@[export: 'VSlimApp_sync_props']
pub fn vslimapp_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &VSlimApp(ptr)
        out := vphp.ZVal{ raw: zv }
        out.add_property_string('base_path', obj.base_path)
        out.add_property_bool('use_demo', obj.use_demo)
    }
}
@[export: 'vphp_wrap_VSlimApp_demo']
pub fn vphp_wrap_vslimapp_demo(ctx vphp.Context) voidptr {
    res := VSlimApp.demo()
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_set_base_path']
pub fn vphp_wrap_vslimapp_set_base_path(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.set_base_path(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_group']
pub fn vphp_wrap_vslimapp_group(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.group(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_dispatch']
pub fn vphp_wrap_vslimapp_dispatch(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    res := recv.dispatch(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_dispatch_request']
pub fn vphp_wrap_vslimapp_dispatch_request(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := unsafe { &VSlimRequest(ctx.arg_raw_obj(0)) }
    res := recv.dispatch_request(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_get']
pub fn vphp_wrap_vslimapp_get(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.get(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_post']
pub fn vphp_wrap_vslimapp_post(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.post(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_put']
pub fn vphp_wrap_vslimapp_put(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.put(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_patch']
pub fn vphp_wrap_vslimapp_patch(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.patch(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_delete']
pub fn vphp_wrap_vslimapp_delete(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.delete(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_any']
pub fn vphp_wrap_vslimapp_any(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.any(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_get_named']
pub fn vphp_wrap_vslimapp_get_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.get_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_post_named']
pub fn vphp_wrap_vslimapp_post_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.post_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_put_named']
pub fn vphp_wrap_vslimapp_put_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.put_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_patch_named']
pub fn vphp_wrap_vslimapp_patch_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.patch_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_delete_named']
pub fn vphp_wrap_vslimapp_delete_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.delete_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_any_named']
pub fn vphp_wrap_vslimapp_any_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.any_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_middleware']
pub fn vphp_wrap_vslimapp_middleware(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg_val(0)
    res := recv.middleware(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_url_for']
pub fn vphp_wrap_vslimapp_url_for(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.url_for(arg_0, arg_1)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimApp_url_for_query']
pub fn vphp_wrap_vslimapp_url_for_query(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    arg_2 := ctx.arg_val(2)
    res := recv.url_for_query(arg_0, arg_1, arg_2)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimApp_url_for_abs']
pub fn vphp_wrap_vslimapp_url_for_abs(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    arg_2 := ctx.arg[string](2)
    arg_3 := ctx.arg[string](3)
    res := recv.url_for_abs(arg_0, arg_1, arg_2, arg_3)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimApp_url_for_query_abs']
pub fn vphp_wrap_vslimapp_url_for_query_abs(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    arg_2 := ctx.arg_val(2)
    arg_3 := ctx.arg[string](3)
    arg_4 := ctx.arg[string](4)
    res := recv.url_for_query_abs(arg_0, arg_1, arg_2, arg_3, arg_4)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimApp_redirect_to']
pub fn vphp_wrap_vslimapp_redirect_to(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.redirect_to(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_redirect_to_query']
pub fn vphp_wrap_vslimapp_redirect_to_query(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    arg_2 := ctx.arg_val(2)
    res := recv.redirect_to_query(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'VSlimApp_handlers']
pub fn vslimapp_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(vslimapp_get_prop)
        write_handler: voidptr(vslimapp_set_prop)
        sync_handler:  voidptr(vslimapp_sync_props)
        new_raw:       voidptr(vslimapp_new_raw)
    } }
}

@[export: 'vphp_wrap_vslim_handle_request']
fn vphp_wrap_vslim_handle_request(ctx vphp.Context) {
    arg_0 := ctx
    vslim_handle_request(arg_0)
}

@[export: 'vphp_wrap_vslim_demo_dispatch']
fn vphp_wrap_vslim_demo_dispatch(ctx vphp.Context) {
    arg_0 := ctx
    vslim_demo_dispatch(arg_0)
}

@[export: 'vphp_wrap_vslim_response_headers']
fn vphp_wrap_vslim_response_headers(ctx vphp.Context) {
    arg_0 := ctx
    vslim_response_headers(arg_0)
}

