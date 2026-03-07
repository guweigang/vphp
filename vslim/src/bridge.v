module main

import vphp

#include "php_bridge.h"

@[export: 'RouteGroup_new_raw']
pub fn routegroup_new_raw() voidptr {
    return vphp.generic_new_raw[RouteGroup]()
}
@[export: 'RouteGroup_free_raw']
pub fn routegroup_free_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
    vphp.generic_free_raw[RouteGroup](ptr)
}
@[export: 'RouteGroup_cleanup_raw']
pub fn routegroup_cleanup_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
}
@[export: 'RouteGroup_get_prop']
pub fn routegroup_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &RouteGroup(ptr)
    }
}
@[export: 'RouteGroup_set_prop']
pub fn routegroup_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &RouteGroup(ptr)
        arg := vphp.ZVal{ raw: value }
    }
}
@[export: 'RouteGroup_sync_props']
pub fn routegroup_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &RouteGroup(ptr)
        out := vphp.ZVal{ raw: zv }
    }
}
@[export: 'vphp_wrap_RouteGroup_group']
pub fn vphp_wrap_routegroup_group(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.group(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_middleware']
pub fn vphp_wrap_routegroup_middleware(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.middleware(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_before']
pub fn vphp_wrap_routegroup_before(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.before(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_after']
pub fn vphp_wrap_routegroup_after(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.after(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_get']
pub fn vphp_wrap_routegroup_get(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.get(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_post']
pub fn vphp_wrap_routegroup_post(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.post(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_put']
pub fn vphp_wrap_routegroup_put(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.put(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_head']
pub fn vphp_wrap_routegroup_head(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.head(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_options']
pub fn vphp_wrap_routegroup_options(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.options(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_patch']
pub fn vphp_wrap_routegroup_patch(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.patch(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_delete']
pub fn vphp_wrap_routegroup_delete(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.delete(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_any']
pub fn vphp_wrap_routegroup_any(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.any(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_map']
pub fn vphp_wrap_routegroup_map(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.map(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_resource']
pub fn vphp_wrap_routegroup_resource(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    res := recv.resource(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_api_resource']
pub fn vphp_wrap_routegroup_api_resource(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    res := recv.api_resource(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_get_named']
pub fn vphp_wrap_routegroup_get_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.get_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_post_named']
pub fn vphp_wrap_routegroup_post_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.post_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_put_named']
pub fn vphp_wrap_routegroup_put_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.put_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_head_named']
pub fn vphp_wrap_routegroup_head_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.head_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_options_named']
pub fn vphp_wrap_routegroup_options_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.options_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_patch_named']
pub fn vphp_wrap_routegroup_patch_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.patch_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_delete_named']
pub fn vphp_wrap_routegroup_delete_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.delete_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_any_named']
pub fn vphp_wrap_routegroup_any_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.any_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_RouteGroup_map_named']
pub fn vphp_wrap_routegroup_map_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &RouteGroup(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg[string](2)
    arg_3 := ctx.arg_val(3)
    res := recv.map_named(arg_0, arg_1, arg_2, arg_3)
    return voidptr(res)
}
@[export: 'RouteGroup_handlers']
pub fn routegroup_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(routegroup_get_prop)
        write_handler: voidptr(routegroup_set_prop)
        sync_handler:  voidptr(routegroup_sync_props)
        new_raw:       voidptr(routegroup_new_raw)
        cleanup_raw:   voidptr(routegroup_cleanup_raw)
        free_raw:      voidptr(routegroup_free_raw)
    } }
}

@[export: 'VSlimRequest_new_raw']
pub fn vslimrequest_new_raw() voidptr {
    return vphp.generic_new_raw[VSlimRequest]()
}
@[export: 'VSlimRequest_free_raw']
pub fn vslimrequest_free_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
    vphp.generic_free_raw[VSlimRequest](ptr)
}
@[export: 'VSlimRequest_cleanup_raw']
pub fn vslimrequest_cleanup_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
    unsafe {
        mut obj := &VSlimRequest(ptr)
        obj.free()
    }
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
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg[string](2)
    res := recv.construct(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_str']
pub fn vphp_wrap_vslimrequest_str(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.str()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_set_query']
pub fn vphp_wrap_vslimrequest_set_query(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.set_query(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_method']
pub fn vphp_wrap_vslimrequest_set_method(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.set_method(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_target']
pub fn vphp_wrap_vslimrequest_set_target(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.set_target(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_body']
pub fn vphp_wrap_vslimrequest_set_body(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.set_body(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_scheme']
pub fn vphp_wrap_vslimrequest_set_scheme(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.set_scheme(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_host']
pub fn vphp_wrap_vslimrequest_set_host(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.set_host(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_port']
pub fn vphp_wrap_vslimrequest_set_port(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.set_port(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_protocol_version']
pub fn vphp_wrap_vslimrequest_set_protocol_version(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.set_protocol_version(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_remote_addr']
pub fn vphp_wrap_vslimrequest_set_remote_addr(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.set_remote_addr(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_headers']
pub fn vphp_wrap_vslimrequest_set_headers(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.set_headers(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_cookies']
pub fn vphp_wrap_vslimrequest_set_cookies(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.set_cookies(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_attributes']
pub fn vphp_wrap_vslimrequest_set_attributes(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.set_attributes(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_server']
pub fn vphp_wrap_vslimrequest_set_server(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.set_server(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_uploaded_files']
pub fn vphp_wrap_vslimrequest_set_uploaded_files(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.set_uploaded_files(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_set_params']
pub fn vphp_wrap_vslimrequest_set_params(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.set_params(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimRequest_query']
pub fn vphp_wrap_vslimrequest_query(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.query(arg_0)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_query_params']
pub fn vphp_wrap_vslimrequest_query_params(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.query_params()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_has_query']
pub fn vphp_wrap_vslimrequest_has_query(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.has_query(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_input']
pub fn vphp_wrap_vslimrequest_input(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.input(arg_0)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_input_or']
pub fn vphp_wrap_vslimrequest_input_or(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    res := recv.input_or(arg_0, arg_1)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_has_input']
pub fn vphp_wrap_vslimrequest_has_input(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.has_input(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_all_inputs']
pub fn vphp_wrap_vslimrequest_all_inputs(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.all_inputs()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_parsed_body']
pub fn vphp_wrap_vslimrequest_parsed_body(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.parsed_body()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_body_format']
pub fn vphp_wrap_vslimrequest_body_format(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.body_format()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_is_json_body']
pub fn vphp_wrap_vslimrequest_is_json_body(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.is_json_body()
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_is_form_body']
pub fn vphp_wrap_vslimrequest_is_form_body(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.is_form_body()
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_is_multipart_body']
pub fn vphp_wrap_vslimrequest_is_multipart_body(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.is_multipart_body()
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_json_body']
pub fn vphp_wrap_vslimrequest_json_body(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.json_body()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_form_body']
pub fn vphp_wrap_vslimrequest_form_body(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.form_body()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_multipart_body']
pub fn vphp_wrap_vslimrequest_multipart_body(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.multipart_body()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_parse_error']
pub fn vphp_wrap_vslimrequest_parse_error(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.parse_error()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_query_all']
pub fn vphp_wrap_vslimrequest_query_all(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.query_all()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_header']
pub fn vphp_wrap_vslimrequest_header(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.header(arg_0)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_headers']
pub fn vphp_wrap_vslimrequest_headers(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.headers()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_has_header']
pub fn vphp_wrap_vslimrequest_has_header(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.has_header(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_content_type']
pub fn vphp_wrap_vslimrequest_content_type(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.content_type()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_request_id']
pub fn vphp_wrap_vslimrequest_request_id(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.request_id()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_trace_id']
pub fn vphp_wrap_vslimrequest_trace_id(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.trace_id()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_cookie']
pub fn vphp_wrap_vslimrequest_cookie(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.cookie(arg_0)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_cookies']
pub fn vphp_wrap_vslimrequest_cookies(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.cookies()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_has_cookie']
pub fn vphp_wrap_vslimrequest_has_cookie(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.has_cookie(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_param']
pub fn vphp_wrap_vslimrequest_param(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.param(arg_0)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_route_params']
pub fn vphp_wrap_vslimrequest_route_params(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.route_params()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_has_param']
pub fn vphp_wrap_vslimrequest_has_param(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.has_param(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_attribute']
pub fn vphp_wrap_vslimrequest_attribute(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.attribute(arg_0)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_attributes']
pub fn vphp_wrap_vslimrequest_attributes(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.attributes()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_has_attribute']
pub fn vphp_wrap_vslimrequest_has_attribute(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.has_attribute(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_server_value']
pub fn vphp_wrap_vslimrequest_server_value(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.server_value(arg_0)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimRequest_server_params']
pub fn vphp_wrap_vslimrequest_server_params(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.server_params()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_has_server']
pub fn vphp_wrap_vslimrequest_has_server(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.has_server(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_uploaded_file_count']
pub fn vphp_wrap_vslimrequest_uploaded_file_count(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.uploaded_file_count()
    ctx.return_val[int](res)
}
@[export: 'vphp_wrap_VSlimRequest_uploaded_files']
pub fn vphp_wrap_vslimrequest_uploaded_files(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.uploaded_files()
    ctx.return_val[[]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_has_uploaded_files']
pub fn vphp_wrap_vslimrequest_has_uploaded_files(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.has_uploaded_files()
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_is_secure']
pub fn vphp_wrap_vslimrequest_is_secure(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.is_secure()
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimRequest_headers_all']
pub fn vphp_wrap_vslimrequest_headers_all(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.headers_all()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_cookies_all']
pub fn vphp_wrap_vslimrequest_cookies_all(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.cookies_all()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_params_all']
pub fn vphp_wrap_vslimrequest_params_all(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.params_all()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_attributes_all']
pub fn vphp_wrap_vslimrequest_attributes_all(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.attributes_all()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_server_all']
pub fn vphp_wrap_vslimrequest_server_all(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.server_all()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimRequest_uploaded_files_all']
pub fn vphp_wrap_vslimrequest_uploaded_files_all(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimRequest(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.uploaded_files_all()
    ctx.return_val[[]string](res)
}
@[export: 'VSlimRequest_handlers']
pub fn vslimrequest_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(vslimrequest_get_prop)
        write_handler: voidptr(vslimrequest_set_prop)
        sync_handler:  voidptr(vslimrequest_sync_props)
        new_raw:       voidptr(vslimrequest_new_raw)
        cleanup_raw:   voidptr(vslimrequest_cleanup_raw)
        free_raw:      voidptr(vslimrequest_free_raw)
    } }
}

@[export: 'VSlimResponse_new_raw']
pub fn vslimresponse_new_raw() voidptr {
    return vphp.generic_new_raw[VSlimResponse]()
}
@[export: 'VSlimResponse_free_raw']
pub fn vslimresponse_free_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
    vphp.generic_free_raw[VSlimResponse](ptr)
}
@[export: 'VSlimResponse_cleanup_raw']
pub fn vslimresponse_cleanup_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
    unsafe {
        mut obj := &VSlimResponse(ptr)
        obj.free()
    }
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
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[int](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg[string](2)
    res := recv.construct(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_header']
pub fn vphp_wrap_vslimresponse_header(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.header(arg_0)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimResponse_headers']
pub fn vphp_wrap_vslimresponse_headers(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.headers()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimResponse_has_header']
pub fn vphp_wrap_vslimresponse_has_header(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.has_header(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimResponse_set_header']
pub fn vphp_wrap_vslimresponse_set_header(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    res := recv.set_header(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_with_request_id']
pub fn vphp_wrap_vslimresponse_with_request_id(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.with_request_id(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_with_trace_id']
pub fn vphp_wrap_vslimresponse_with_trace_id(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.with_trace_id(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_set_content_type']
pub fn vphp_wrap_vslimresponse_set_content_type(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.set_content_type(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_cookie_header']
pub fn vphp_wrap_vslimresponse_cookie_header(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.cookie_header()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimResponse_set_cookie']
pub fn vphp_wrap_vslimresponse_set_cookie(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    res := recv.set_cookie(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_set_cookie_opts']
pub fn vphp_wrap_vslimresponse_set_cookie_opts(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg[string](2)
    res := recv.set_cookie_opts(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_set_cookie_full']
pub fn vphp_wrap_vslimresponse_set_cookie_full(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
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
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.delete_cookie(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_set_status']
pub fn vphp_wrap_vslimresponse_set_status(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[int](0)
    res := recv.set_status(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_with_status']
pub fn vphp_wrap_vslimresponse_with_status(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[int](0)
    res := recv.with_status(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_text']
pub fn vphp_wrap_vslimresponse_text(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.text(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_json']
pub fn vphp_wrap_vslimresponse_json(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.json(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_html']
pub fn vphp_wrap_vslimresponse_html(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.html(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_redirect']
pub fn vphp_wrap_vslimresponse_redirect(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.redirect(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_redirect_with_status']
pub fn vphp_wrap_vslimresponse_redirect_with_status(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[int](1)
    res := recv.redirect_with_status(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimResponse_headers_all']
pub fn vphp_wrap_vslimresponse_headers_all(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.headers_all()
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimResponse_str']
pub fn vphp_wrap_vslimresponse_str(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.str()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimResponse_content_length']
pub fn vphp_wrap_vslimresponse_content_length(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimResponse(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
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
        cleanup_raw:   voidptr(vslimresponse_cleanup_raw)
        free_raw:      voidptr(vslimresponse_free_raw)
    } }
}

@[export: 'VSlimApp_new_raw']
pub fn vslimapp_new_raw() voidptr {
    return vphp.generic_new_raw[VSlimApp]()
}
@[export: 'VSlimApp_free_raw']
pub fn vslimapp_free_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
    vphp.generic_free_raw[VSlimApp](ptr)
}
@[export: 'VSlimApp_cleanup_raw']
pub fn vslimapp_cleanup_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
    unsafe {
        mut obj := &VSlimApp(ptr)
        obj.free()
    }
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
    }
}
@[export: 'vphp_wrap_VSlimApp_set_view_base_path']
pub fn vphp_wrap_vslimapp_set_view_base_path(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.set_view_base_path(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_view_base_path']
pub fn vphp_wrap_vslimapp_view_base_path(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.view_base_path()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimApp_set_assets_prefix']
pub fn vphp_wrap_vslimapp_set_assets_prefix(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.set_assets_prefix(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_assets_prefix']
pub fn vphp_wrap_vslimapp_assets_prefix(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.assets_prefix()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimApp_make_view']
pub fn vphp_wrap_vslimapp_make_view(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.make_view()
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_view']
pub fn vphp_wrap_vslimapp_view(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.view(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_demo']
pub fn vphp_wrap_vslimapp_demo(ctx vphp.Context) voidptr {
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := VSlimApp.demo()
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_set_base_path']
pub fn vphp_wrap_vslimapp_set_base_path(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.set_base_path(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_has_container']
pub fn vphp_wrap_vslimapp_has_container(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.has_container()
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimApp_set_container']
pub fn vphp_wrap_vslimapp_set_container(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := unsafe { &VSlimContainer(ctx.arg_raw_obj(0)) }
    res := recv.set_container(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_container']
pub fn vphp_wrap_vslimapp_container(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.container()
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_group']
pub fn vphp_wrap_vslimapp_group(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.group(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_dispatch']
pub fn vphp_wrap_vslimapp_dispatch(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    res := recv.dispatch(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_dispatch_body']
pub fn vphp_wrap_vslimapp_dispatch_body(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg[string](2)
    res := recv.dispatch_body(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_dispatch_request']
pub fn vphp_wrap_vslimapp_dispatch_request(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := unsafe { &VSlimRequest(ctx.arg_raw_obj(0)) }
    res := recv.dispatch_request(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_dispatch_envelope']
pub fn vphp_wrap_vslimapp_dispatch_envelope(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.dispatch_envelope(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_dispatch_envelope_map']
pub fn vphp_wrap_vslimapp_dispatch_envelope_map(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.dispatch_envelope_map(arg_0)
    ctx.return_val[map[string]string](res)
}
@[export: 'vphp_wrap_VSlimApp_get']
pub fn vphp_wrap_vslimapp_get(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.get(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_post']
pub fn vphp_wrap_vslimapp_post(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.post(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_put']
pub fn vphp_wrap_vslimapp_put(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.put(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_head']
pub fn vphp_wrap_vslimapp_head(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.head(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_options']
pub fn vphp_wrap_vslimapp_options(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.options(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_patch']
pub fn vphp_wrap_vslimapp_patch(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.patch(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_delete']
pub fn vphp_wrap_vslimapp_delete(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.delete(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_any']
pub fn vphp_wrap_vslimapp_any(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.any(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_map']
pub fn vphp_wrap_vslimapp_map(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.map(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_resource']
pub fn vphp_wrap_vslimapp_resource(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    res := recv.resource(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_api_resource']
pub fn vphp_wrap_vslimapp_api_resource(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    res := recv.api_resource(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_get_named']
pub fn vphp_wrap_vslimapp_get_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.get_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_post_named']
pub fn vphp_wrap_vslimapp_post_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.post_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_put_named']
pub fn vphp_wrap_vslimapp_put_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.put_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_head_named']
pub fn vphp_wrap_vslimapp_head_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.head_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_options_named']
pub fn vphp_wrap_vslimapp_options_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.options_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_patch_named']
pub fn vphp_wrap_vslimapp_patch_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.patch_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_delete_named']
pub fn vphp_wrap_vslimapp_delete_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.delete_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_any_named']
pub fn vphp_wrap_vslimapp_any_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg_val(2)
    res := recv.any_named(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_map_named']
pub fn vphp_wrap_vslimapp_map_named(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    arg_1 := ctx.arg[string](1)
    arg_2 := ctx.arg[string](2)
    arg_3 := ctx.arg_val(3)
    res := recv.map_named(arg_0, arg_1, arg_2, arg_3)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_middleware']
pub fn vphp_wrap_vslimapp_middleware(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.middleware(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_before']
pub fn vphp_wrap_vslimapp_before(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.before(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_after']
pub fn vphp_wrap_vslimapp_after(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.after(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_set_not_found_handler']
pub fn vphp_wrap_vslimapp_set_not_found_handler(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.set_not_found_handler(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_not_found']
pub fn vphp_wrap_vslimapp_not_found(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.not_found(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_set_error_handler']
pub fn vphp_wrap_vslimapp_set_error_handler(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.set_error_handler(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_error']
pub fn vphp_wrap_vslimapp_error(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg_val(0)
    res := recv.error(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_set_error_response_json']
pub fn vphp_wrap_vslimapp_set_error_response_json(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[bool](0)
    res := recv.set_error_response_json(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_error_response_json_enabled']
pub fn vphp_wrap_vslimapp_error_response_json_enabled(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.error_response_json_enabled()
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimApp_url_for']
pub fn vphp_wrap_vslimapp_url_for(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.url_for(arg_0, arg_1)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimApp_url_for_query']
pub fn vphp_wrap_vslimapp_url_for_query(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    arg_2 := ctx.arg_val(2)
    res := recv.url_for_query(arg_0, arg_1, arg_2)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimApp_url_for_abs']
pub fn vphp_wrap_vslimapp_url_for_abs(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
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
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
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
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.redirect_to(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_redirect_to_query']
pub fn vphp_wrap_vslimapp_redirect_to_query(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    arg_2 := ctx.arg_val(2)
    res := recv.redirect_to_query(arg_0, arg_1, arg_2)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimApp_route_count']
pub fn vphp_wrap_vslimapp_route_count(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.route_count()
    ctx.return_val[int](res)
}
@[export: 'vphp_wrap_VSlimApp_route_names']
pub fn vphp_wrap_vslimapp_route_names(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.route_names()
    ctx.return_val[[]string](res)
}
@[export: 'vphp_wrap_VSlimApp_has_route_name']
pub fn vphp_wrap_vslimapp_has_route_name(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.has_route_name(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_VSlimApp_route_manifest_lines']
pub fn vphp_wrap_vslimapp_route_manifest_lines(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.route_manifest_lines()
    ctx.return_val[[]string](res)
}
@[export: 'vphp_wrap_VSlimApp_route_conflict_keys']
pub fn vphp_wrap_vslimapp_route_conflict_keys(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.route_conflict_keys()
    ctx.return_val[[]string](res)
}
@[export: 'vphp_wrap_VSlimApp_route_manifest']
pub fn vphp_wrap_vslimapp_route_manifest(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.route_manifest()
    ctx.return_val[[]map[string]string](res)
}
@[export: 'vphp_wrap_VSlimApp_route_conflicts']
pub fn vphp_wrap_vslimapp_route_conflicts(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.route_conflicts()
    ctx.return_val[[]map[string]string](res)
}
@[export: 'vphp_wrap_VSlimApp_allowed_methods_for']
pub fn vphp_wrap_vslimapp_allowed_methods_for(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimApp(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.allowed_methods_for(arg_0)
    ctx.return_val[[]string](res)
}
@[export: 'VSlimApp_handlers']
pub fn vslimapp_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(vslimapp_get_prop)
        write_handler: voidptr(vslimapp_set_prop)
        sync_handler:  voidptr(vslimapp_sync_props)
        new_raw:       voidptr(vslimapp_new_raw)
        cleanup_raw:   voidptr(vslimapp_cleanup_raw)
        free_raw:      voidptr(vslimapp_free_raw)
    } }
}

@[export: 'VSlimView_new_raw']
pub fn vslimview_new_raw() voidptr {
    return vphp.generic_new_raw[VSlimView]()
}
@[export: 'VSlimView_free_raw']
pub fn vslimview_free_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
    vphp.generic_free_raw[VSlimView](ptr)
}
@[export: 'VSlimView_cleanup_raw']
pub fn vslimview_cleanup_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
}
@[export: 'VSlimView_get_prop']
pub fn vslimview_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &VSlimView(ptr)
    }
}
@[export: 'VSlimView_set_prop']
pub fn vslimview_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &VSlimView(ptr)
        arg := vphp.ZVal{ raw: value }
    }
}
@[export: 'VSlimView_sync_props']
pub fn vslimview_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &VSlimView(ptr)
        out := vphp.ZVal{ raw: zv }
    }
}
@[export: 'vphp_wrap_VSlimView_construct']
pub fn vphp_wrap_vslimview_construct(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimView(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    res := recv.construct(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimView_set_base_path']
pub fn vphp_wrap_vslimview_set_base_path(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimView(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.set_base_path(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimView_base_path']
pub fn vphp_wrap_vslimview_base_path(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimView(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.base_path()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimView_set_assets_prefix']
pub fn vphp_wrap_vslimview_set_assets_prefix(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimView(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.set_assets_prefix(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimView_assets_prefix']
pub fn vphp_wrap_vslimview_assets_prefix(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimView(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.assets_prefix()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimView_asset']
pub fn vphp_wrap_vslimview_asset(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimView(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.asset(arg_0)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimView_render']
pub fn vphp_wrap_vslimview_render(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimView(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.render(arg_0, arg_1)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_VSlimView_render_response']
pub fn vphp_wrap_vslimview_render_response(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimView(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.render_response(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'VSlimView_handlers']
pub fn vslimview_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(vslimview_get_prop)
        write_handler: voidptr(vslimview_set_prop)
        sync_handler:  voidptr(vslimview_sync_props)
        new_raw:       voidptr(vslimview_new_raw)
        cleanup_raw:   voidptr(vslimview_cleanup_raw)
        free_raw:      voidptr(vslimview_free_raw)
    } }
}

@[export: 'VSlimController_new_raw']
pub fn vslimcontroller_new_raw() voidptr {
    return vphp.generic_new_raw[VSlimController]()
}
@[export: 'VSlimController_free_raw']
pub fn vslimcontroller_free_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
    vphp.generic_free_raw[VSlimController](ptr)
}
@[export: 'VSlimController_cleanup_raw']
pub fn vslimcontroller_cleanup_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
}
@[export: 'VSlimController_get_prop']
pub fn vslimcontroller_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &VSlimController(ptr)
    }
}
@[export: 'VSlimController_set_prop']
pub fn vslimcontroller_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &VSlimController(ptr)
        arg := vphp.ZVal{ raw: value }
    }
}
@[export: 'VSlimController_sync_props']
pub fn vslimcontroller_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &VSlimController(ptr)
        out := vphp.ZVal{ raw: zv }
    }
}
@[export: 'vphp_wrap_VSlimController_construct']
pub fn vphp_wrap_vslimcontroller_construct(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimController(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := unsafe { &VSlimApp(ctx.arg_raw_obj(0)) }
    res := recv.construct(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimController_set_app']
pub fn vphp_wrap_vslimcontroller_set_app(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimController(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := unsafe { &VSlimApp(ctx.arg_raw_obj(0)) }
    res := recv.set_app(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimController_set_view']
pub fn vphp_wrap_vslimcontroller_set_view(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimController(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := unsafe { &VSlimView(ctx.arg_raw_obj(0)) }
    res := recv.set_view(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimController_view']
pub fn vphp_wrap_vslimcontroller_view(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimController(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.view()
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimController_render']
pub fn vphp_wrap_vslimcontroller_render(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimController(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.render(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimController_text']
pub fn vphp_wrap_vslimcontroller_text(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimController(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[int](1)
    res := recv.text(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimController_json']
pub fn vphp_wrap_vslimcontroller_json(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimController(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[int](1)
    res := recv.json(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimController_redirect']
pub fn vphp_wrap_vslimcontroller_redirect(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimController(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[int](1)
    res := recv.redirect(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'VSlimController_handlers']
pub fn vslimcontroller_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(vslimcontroller_get_prop)
        write_handler: voidptr(vslimcontroller_set_prop)
        sync_handler:  voidptr(vslimcontroller_sync_props)
        new_raw:       voidptr(vslimcontroller_new_raw)
        cleanup_raw:   voidptr(vslimcontroller_cleanup_raw)
        free_raw:      voidptr(vslimcontroller_free_raw)
    } }
}

@[export: 'VSlimContainerException_new_raw']
pub fn vslimcontainerexception_new_raw() voidptr {
    return vphp.generic_new_raw[VSlimContainerException]()
}
@[export: 'VSlimContainerException_free_raw']
pub fn vslimcontainerexception_free_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
    vphp.generic_free_raw[VSlimContainerException](ptr)
}
@[export: 'VSlimContainerException_cleanup_raw']
pub fn vslimcontainerexception_cleanup_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
}
@[export: 'VSlimContainerException_get_prop']
pub fn vslimcontainerexception_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &VSlimContainerException(ptr)
    }
}
@[export: 'VSlimContainerException_set_prop']
pub fn vslimcontainerexception_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &VSlimContainerException(ptr)
        arg := vphp.ZVal{ raw: value }
    }
}
@[export: 'VSlimContainerException_sync_props']
pub fn vslimcontainerexception_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &VSlimContainerException(ptr)
        out := vphp.ZVal{ raw: zv }
    }
}
@[export: 'VSlimContainerException_handlers']
pub fn vslimcontainerexception_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(vslimcontainerexception_get_prop)
        write_handler: voidptr(vslimcontainerexception_set_prop)
        sync_handler:  voidptr(vslimcontainerexception_sync_props)
        new_raw:       voidptr(vslimcontainerexception_new_raw)
        cleanup_raw:   voidptr(vslimcontainerexception_cleanup_raw)
        free_raw:      voidptr(vslimcontainerexception_free_raw)
    } }
}

@[export: 'VSlimContainerNotFoundException_new_raw']
pub fn vslimcontainernotfoundexception_new_raw() voidptr {
    return vphp.generic_new_raw[VSlimContainerNotFoundException]()
}
@[export: 'VSlimContainerNotFoundException_free_raw']
pub fn vslimcontainernotfoundexception_free_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
    vphp.generic_free_raw[VSlimContainerNotFoundException](ptr)
}
@[export: 'VSlimContainerNotFoundException_cleanup_raw']
pub fn vslimcontainernotfoundexception_cleanup_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
}
@[export: 'VSlimContainerNotFoundException_get_prop']
pub fn vslimcontainernotfoundexception_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &VSlimContainerNotFoundException(ptr)
    }
}
@[export: 'VSlimContainerNotFoundException_set_prop']
pub fn vslimcontainernotfoundexception_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &VSlimContainerNotFoundException(ptr)
        arg := vphp.ZVal{ raw: value }
    }
}
@[export: 'VSlimContainerNotFoundException_sync_props']
pub fn vslimcontainernotfoundexception_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &VSlimContainerNotFoundException(ptr)
        out := vphp.ZVal{ raw: zv }
    }
}
@[export: 'VSlimContainerNotFoundException_handlers']
pub fn vslimcontainernotfoundexception_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(vslimcontainernotfoundexception_get_prop)
        write_handler: voidptr(vslimcontainernotfoundexception_set_prop)
        sync_handler:  voidptr(vslimcontainernotfoundexception_sync_props)
        new_raw:       voidptr(vslimcontainernotfoundexception_new_raw)
        cleanup_raw:   voidptr(vslimcontainernotfoundexception_cleanup_raw)
        free_raw:      voidptr(vslimcontainernotfoundexception_free_raw)
    } }
}

@[export: 'VSlimContainer_new_raw']
pub fn vslimcontainer_new_raw() voidptr {
    return vphp.generic_new_raw[VSlimContainer]()
}
@[export: 'VSlimContainer_free_raw']
pub fn vslimcontainer_free_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
    vphp.generic_free_raw[VSlimContainer](ptr)
}
@[export: 'VSlimContainer_cleanup_raw']
pub fn vslimcontainer_cleanup_raw(ptr voidptr) {
    if ptr == 0 {
        return
    }
    unsafe {
        mut obj := &VSlimContainer(ptr)
        obj.free()
    }
}
@[export: 'VSlimContainer_get_prop']
pub fn vslimcontainer_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &VSlimContainer(ptr)
    }
}
@[export: 'VSlimContainer_set_prop']
pub fn vslimcontainer_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &VSlimContainer(ptr)
        arg := vphp.ZVal{ raw: value }
    }
}
@[export: 'VSlimContainer_sync_props']
pub fn vslimcontainer_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &VSlimContainer(ptr)
        out := vphp.ZVal{ raw: zv }
    }
}
@[export: 'vphp_wrap_VSlimContainer_construct']
pub fn vphp_wrap_vslimcontainer_construct(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimContainer(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    res := recv.construct()
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimContainer_set']
pub fn vphp_wrap_vslimcontainer_set(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimContainer(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.set(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimContainer_factory']
pub fn vphp_wrap_vslimcontainer_factory(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &VSlimContainer(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg_val(1)
    res := recv.factory(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_VSlimContainer_has']
pub fn vphp_wrap_vslimcontainer_has(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimContainer(ptr) }
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx.arg[string](0)
    res := recv.has(arg_0)
    ctx.return_val[bool](res)
}
@[export: 'VSlimContainer_handlers']
pub fn vslimcontainer_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(vslimcontainer_get_prop)
        write_handler: voidptr(vslimcontainer_set_prop)
        sync_handler:  voidptr(vslimcontainer_sync_props)
        new_raw:       voidptr(vslimcontainer_new_raw)
        cleanup_raw:   voidptr(vslimcontainer_cleanup_raw)
        free_raw:      voidptr(vslimcontainer_free_raw)
    } }
}

@[export: 'vphp_wrap_vslim_handle_request']
fn vphp_wrap_vslim_handle_request(ctx vphp.Context) {
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx
    vslim_handle_request(arg_0)
}

@[export: 'vphp_wrap_vslim_demo_dispatch']
fn vphp_wrap_vslim_demo_dispatch(ctx vphp.Context) {
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx
    vslim_demo_dispatch(arg_0)
}

@[export: 'vphp_wrap_vslim_response_headers']
fn vphp_wrap_vslim_response_headers(ctx vphp.Context) {
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx
    vslim_response_headers(arg_0)
}

@[export: 'vphp_wrap_vslim_middleware_next']
fn vphp_wrap_vslim_middleware_next(ctx vphp.Context) {
    vphp_ar_mark := vphp.autorelease_mark()
    defer { vphp.autorelease_drain(vphp_ar_mark) }
    arg_0 := ctx
    vslim_middleware_next(arg_0)
}

