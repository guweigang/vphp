module main
import vphp


@[export: "vphp_task_auto_startup"]
fn vphp_task_auto_startup() {

    vphp.ITask.register('AnalyzeTask', fn(s string) vphp.ITask { return AnalyzeTask{ json_data: s } })

}

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

    vphp.return_val[bool](ctx, res)

}

@[export: 'vphp_wrap_Article_save']

pub fn vphp_wrap_article_save(ptr voidptr, ctx vphp.Context)  {

    mut recv := unsafe { &Article(ptr) }

    res := recv.save()

    vphp.return_val[bool](ctx, res)

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

@[export: "vphp_wrap_v_add"]

fn vphp_wrap_v_add(ctx vphp.Context) {

    arg_0 := ctx.arg[i64](0)

    arg_1 := ctx.arg[i64](1)

    res := v_add(arg_0, arg_1)

    vphp.return_val[i64](ctx, res)

}

@[export: "vphp_wrap_v_greet"]

fn vphp_wrap_v_greet(ctx vphp.Context) {

    arg_0 := ctx.arg[string](0)

    res := v_greet(arg_0)

    vphp.return_val[string](ctx, res)

}

@[export: "vphp_wrap_v_pure_map_test"]

fn vphp_wrap_v_pure_map_test(ctx vphp.Context) {

    arg_0 := ctx.arg[string](0)

    arg_1 := ctx.arg[string](1)

    res := v_pure_map_test(arg_0, arg_1)

    vphp.return_val[map[string]string](ctx, res)

}