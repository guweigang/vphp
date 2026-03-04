module main

import vphp

#include "php_bridge.h"

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
@[export: 'vphp_wrap_VSlimResponse_str']
pub fn vphp_wrap_vslimresponse_str(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &VSlimResponse(ptr) }
    res := recv.str()
    ctx.return_val[string](res)
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
    }
}
@[export: 'vphp_wrap_VSlimApp_demo']
pub fn vphp_wrap_vslimapp_demo(ctx vphp.Context) voidptr {
    res := VSlimApp.demo()
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

