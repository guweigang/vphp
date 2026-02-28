module main

import vphp
import time
import json

@[export: 'Article_new_raw']
pub fn article_new_raw() voidptr {
    return vphp.generic_new_raw[Article]()
}
@[export: 'Article_get_prop']
pub fn article_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    vphp.generic_get_prop[Article](ptr, name_ptr, name_len, rv)
}
@[export: 'Article_set_prop']
pub fn article_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    vphp.generic_set_prop[Article](ptr, name_ptr, name_len, value)
}
@[export: 'Article_sync_props']
pub fn article_sync_props(ptr voidptr, zv &C.zval) {
    vphp.generic_sync_props[Article](ptr, zv)
}
@[export: 'vphp_wrap_Article_init']
pub fn vphp_wrap_article_init(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &Article(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[int](1)
    res := recv.init(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_Article_create']
pub fn vphp_wrap_article_create(ctx vphp.Context) voidptr {
    arg_0 := ctx.arg[string](0)
    res := Article.create(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_Article_is_top']
pub fn vphp_wrap_article_is_top(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &Article(ptr) }
    res := recv.is_top()
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_Article_save']
pub fn vphp_wrap_article_save(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &Article(ptr) }
    res := recv.save()
    ctx.return_val[bool](res)
}
@[export: 'Article_handlers']
pub fn article_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(article_get_prop)
        write_handler: voidptr(article_set_prop)
        sync_handler:  voidptr(article_sync_props)
        new_raw:       voidptr(article_new_raw)
    } }
}

@[export: 'VPhpTask_new_raw']
pub fn vphptask_new_raw() voidptr {
    return vphp.generic_new_raw[VPhpTask]()
}
@[export: 'VPhpTask_get_prop']
pub fn vphptask_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    vphp.generic_get_prop[VPhpTask](ptr, name_ptr, name_len, rv)
}
@[export: 'VPhpTask_set_prop']
pub fn vphptask_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    vphp.generic_set_prop[VPhpTask](ptr, name_ptr, name_len, value)
}
@[export: 'VPhpTask_sync_props']
pub fn vphptask_sync_props(ptr voidptr, zv &C.zval) {
    vphp.generic_sync_props[VPhpTask](ptr, zv)
}
@[export: 'vphp_wrap_VPhpTask_spawn']
pub fn vphp_wrap_vphptask_spawn(ctx vphp.Context)  {
    arg_0 := ctx
    VPhpTask.@spawn(arg_0)
}
@[export: 'vphp_wrap_VPhpTask_wait']
pub fn vphp_wrap_vphptask_wait(ctx vphp.Context)  {
    arg_0 := ctx
    VPhpTask.wait(arg_0)
}
@[export: 'vphp_wrap_VPhpTask_list']
pub fn vphp_wrap_vphptask_list(ctx vphp.Context)  {
    arg_0 := ctx
    VPhpTask.list(arg_0)
}
@[export: 'VPhpTask_handlers']
pub fn vphptask_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(vphptask_get_prop)
        write_handler: voidptr(vphptask_set_prop)
        sync_handler:  voidptr(vphptask_sync_props)
        new_raw:       voidptr(vphptask_new_raw)
    } }
}

@[export: 'vphp_wrap_v_reverse_string']
fn vphp_wrap_v_reverse_string(ctx vphp.Context) {
    arg_0 := ctx
    v_reverse_string(arg_0)
}

@[export: 'vphp_wrap_v_logic_main']
fn vphp_wrap_v_logic_main(ctx vphp.Context) {
    arg_0 := ctx
    v_logic_main(arg_0)
}

@[export: 'vphp_wrap_v_add']
fn vphp_wrap_v_add(ctx vphp.Context) {
    arg_0 := ctx.arg[i64](0)
    arg_1 := ctx.arg[i64](1)
    res := v_add(arg_0, arg_1)
    ctx.return_val[i64](res)
}

@[export: 'vphp_wrap_v_greet']
fn vphp_wrap_v_greet(ctx vphp.Context) {
    arg_0 := ctx.arg[string](0)
    res := v_greet(arg_0)
    ctx.return_val[string](res)
}

@[export: 'vphp_wrap_v_pure_map_test']
fn vphp_wrap_v_pure_map_test(ctx vphp.Context) {
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    res := v_pure_map_test(arg_0, arg_1)
    ctx.return_val[map[string]string](res)
}

@[export: 'vphp_wrap_v_process_list']
fn vphp_wrap_v_process_list(ctx vphp.Context) {
    arg_0 := ctx
    v_process_list(arg_0)
}

@[export: 'vphp_wrap_v_test_map']
fn vphp_wrap_v_test_map(ctx vphp.Context) {
    arg_0 := ctx
    v_test_map(arg_0)
}

@[export: 'vphp_wrap_v_get_config']
fn vphp_wrap_v_get_config(ctx vphp.Context) {
    arg_0 := ctx
    v_get_config(arg_0)
}

@[export: 'vphp_wrap_v_get_user']
fn vphp_wrap_v_get_user(ctx vphp.Context) {
    arg_0 := ctx
    v_get_user(arg_0)
}

@[export: 'vphp_wrap_v_call_back']
fn vphp_wrap_v_call_back(ctx vphp.Context) {
    arg_0 := ctx
    v_call_back(arg_0)
}

@[export: 'vphp_wrap_v_new_coach']
fn vphp_wrap_v_new_coach(ctx vphp.Context) {
    arg_0 := ctx
    v_new_coach(arg_0)
}

@[export: 'vphp_wrap_v_new_db']
fn vphp_wrap_v_new_db(ctx vphp.Context) {
    arg_0 := ctx
    v_new_db(arg_0)
}

@[export: 'vphp_wrap_v_check_res']
fn vphp_wrap_v_check_res(ctx vphp.Context) {
    arg_0 := ctx
    v_check_res(arg_0)
}

@[export: 'vphp_wrap_v_analyze_fitness_data']
fn vphp_wrap_v_analyze_fitness_data(ctx vphp.Context) {
    arg_0 := ctx
    v_analyze_fitness_data(arg_0)
}

@[export: 'vphp_wrap_v_get_alerts']
fn vphp_wrap_v_get_alerts(ctx vphp.Context) {
    arg_0 := ctx
    v_get_alerts(arg_0)
}

@[export: 'vphp_wrap_v_complex_test']
fn vphp_wrap_v_complex_test(ctx vphp.Context) {
    arg_0 := ctx
    v_complex_test(arg_0)
}

@[export: 'vphp_wrap_v_analyze_user_object']
fn vphp_wrap_v_analyze_user_object(ctx vphp.Context) {
    arg_0 := ctx
    v_analyze_user_object(arg_0)
}

@[export: 'vphp_wrap_v_trigger_user_action']
fn vphp_wrap_v_trigger_user_action(ctx vphp.Context) {
    arg_0 := ctx
    v_trigger_user_action(arg_0)
}

@[export: 'vphp_wrap_v_call_php_closure']
fn vphp_wrap_v_call_php_closure(ctx vphp.Context) {
    arg_0 := ctx
    v_call_php_closure(arg_0)
}

@[export: 'vphp_ext_startup']
fn vphp_ext_startup() {
    vphp.ITask.register('AnalyzeTask', fn (ctx vphp.Context) vphp.ITask {
        return AnalyzeTask{
            symbol: ctx.arg[string](1)
            count: ctx.arg[int](2)
        }
    })
}
