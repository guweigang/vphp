module main

import vphp

#include "php_bridge.h"

@[export: 'AbstractReport_new_raw']
pub fn abstractreport_new_raw() voidptr {
    return vphp.generic_new_raw[AbstractReport]()
}
@[export: 'AbstractReport_get_prop']
pub fn abstractreport_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &AbstractReport(ptr)
        if name == 'title' {
            vphp.return_val_raw(rv, obj.title)
            return
        }
    }
}
@[export: 'AbstractReport_set_prop']
pub fn abstractreport_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &AbstractReport(ptr)
        arg := vphp.ZVal{ raw: value }
        if name == 'title' {
            obj.title = arg.get_string()
            return
        }
    }
}
@[export: 'AbstractReport_sync_props']
pub fn abstractreport_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &AbstractReport(ptr)
        out := vphp.ZVal{ raw: zv }
        out.add_property_string('title', obj.title)
    }
}
@[export: 'vphp_wrap_AbstractReport_label']
pub fn vphp_wrap_abstractreport_label(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &AbstractReport(ptr) }
    res := recv.label()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_AbstractReport_summarize']
pub fn vphp_wrap_abstractreport_summarize(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &AbstractReport(ptr) }
    res := recv.summarize()
    ctx.return_val[string](res)
}
@[export: 'AbstractReport_handlers']
pub fn abstractreport_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(abstractreport_get_prop)
        write_handler: voidptr(abstractreport_set_prop)
        sync_handler:  voidptr(abstractreport_sync_props)
        new_raw:       voidptr(abstractreport_new_raw)
    } }
}

@[export: 'DailyReport_new_raw']
pub fn dailyreport_new_raw() voidptr {
    return vphp.generic_new_raw[DailyReport]()
}
@[export: 'DailyReport_get_prop']
pub fn dailyreport_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &DailyReport(ptr)
        if name == 'summary' {
            vphp.return_val_raw(rv, obj.summary)
            return
        }
    }
}
@[export: 'DailyReport_set_prop']
pub fn dailyreport_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &DailyReport(ptr)
        arg := vphp.ZVal{ raw: value }
        if name == 'summary' {
            obj.summary = arg.get_string()
            return
        }
    }
}
@[export: 'DailyReport_sync_props']
pub fn dailyreport_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &DailyReport(ptr)
        out := vphp.ZVal{ raw: zv }
        out.add_property_string('summary', obj.summary)
    }
}
@[export: 'vphp_wrap_DailyReport_construct']
pub fn vphp_wrap_dailyreport_construct(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &DailyReport(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[string](1)
    res := recv.construct(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_DailyReport_summarize']
pub fn vphp_wrap_dailyreport_summarize(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &DailyReport(ptr) }
    res := recv.summarize()
    ctx.return_val[string](res)
}
@[export: 'DailyReport_handlers']
pub fn dailyreport_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(dailyreport_get_prop)
        write_handler: voidptr(dailyreport_set_prop)
        sync_handler:  voidptr(dailyreport_sync_props)
        new_raw:       voidptr(dailyreport_new_raw)
    } }
}

@[export: 'Author_new_raw']
pub fn author_new_raw() voidptr {
    return vphp.generic_new_raw[Author]()
}
@[export: 'Author_get_prop']
pub fn author_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &Author(ptr)
        if name == 'name' {
            vphp.return_val_raw(rv, obj.name)
            return
        }
    }
}
@[export: 'Author_set_prop']
pub fn author_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &Author(ptr)
        arg := vphp.ZVal{ raw: value }
        if name == 'name' {
            obj.name = arg.get_string()
            return
        }
    }
}
@[export: 'Author_sync_props']
pub fn author_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &Author(ptr)
        out := vphp.ZVal{ raw: zv }
        out.add_property_string('name', obj.name)
    }
}
@[export: 'vphp_wrap_Author_create']
pub fn vphp_wrap_author_create(ctx vphp.Context) voidptr {
    arg_0 := ctx.arg[string](0)
    res := Author.create(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_Author_get_name']
pub fn vphp_wrap_author_get_name(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &Author(ptr) }
    res := recv.get_name()
    ctx.return_val[string](res)
}
@[export: 'Author_handlers']
pub fn author_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(author_get_prop)
        write_handler: voidptr(author_set_prop)
        sync_handler:  voidptr(author_sync_props)
        new_raw:       voidptr(author_new_raw)
    } }
}

@[export: 'Post_new_raw']
pub fn post_new_raw() voidptr {
    return vphp.generic_new_raw[Post]()
}
@[export: 'Post_get_prop']
pub fn post_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &Post(ptr)
        if name == 'post_id' {
            vphp.return_val_raw(rv, i64(obj.post_id))
            return
        }
    }
}
@[export: 'Post_set_prop']
pub fn post_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &Post(ptr)
        arg := vphp.ZVal{ raw: value }
        if name == 'post_id' {
            obj.post_id = int(arg.get_int())
            return
        }
    }
}
@[export: 'Post_sync_props']
pub fn post_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &Post(ptr)
        out := vphp.ZVal{ raw: zv }
        out.add_property_long('post_id', i64(obj.post_id))
    }
}
@[export: 'vphp_wrap_Post_set_author']
pub fn vphp_wrap_post_set_author(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &Post(ptr) }
    arg_0 := unsafe { &Author(ctx.arg_raw_obj(0)) }
    recv.set_author(arg_0)
}
@[export: 'vphp_wrap_Post_get_author']
pub fn vphp_wrap_post_get_author(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &Post(ptr) }
    res := recv.get_author()
    return voidptr(res)
}
@[export: 'Post_handlers']
pub fn post_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(post_get_prop)
        write_handler: voidptr(post_set_prop)
        sync_handler:  voidptr(post_sync_props)
        new_raw:       voidptr(post_new_raw)
    } }
}

@[export: 'Article_new_raw']
pub fn article_new_raw() voidptr {
    return vphp.generic_new_raw[Article]()
}
@[export: 'Article_get_prop']
pub fn article_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &Article(ptr)
        if name == 'created_at' {
            vphp.return_val_raw(rv, i64(obj.created_at))
            return
        }
        if name == 'id' {
            vphp.return_val_raw(rv, i64(obj.id))
            return
        }
        if name == 'title' {
            vphp.return_val_raw(rv, obj.title)
            return
        }
        if name == 'is_top' {
            vphp.return_val_raw(rv, obj.is_top)
            return
        }
    }
}
@[export: 'Article_set_prop']
pub fn article_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &Article(ptr)
        arg := vphp.ZVal{ raw: value }
        if name == 'id' {
            obj.id = int(arg.get_int())
            return
        }
        if name == 'title' {
            obj.title = arg.get_string()
            return
        }
        if name == 'is_top' {
            obj.is_top = arg.get_bool()
            return
        }
    }
}
@[export: 'Article_sync_props']
pub fn article_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &Article(ptr)
        out := vphp.ZVal{ raw: zv }
        out.add_property_long('created_at', i64(obj.created_at))
        out.add_property_long('id', i64(obj.id))
        out.add_property_string('title', obj.title)
        out.add_property_bool('is_top', obj.is_top)
        out.add_property_string('content', obj.content)
    }
}
pub fn Article.consts() ArticleConsts {
    return article_consts
}
pub fn Article.statics() &ArticleStatics {
    return &article_statics
}
pub fn Article.sync_statics_to_php(ctx vphp.Context) {
    ce := ctx.get_ce()
    if ce == voidptr(0) { return }
    vphp.set_static_prop(ce, "total_count", article_statics.total_count)
}
pub fn Article.sync_statics_from_php(ctx vphp.Context) {
    ce := ctx.get_ce()
    if ce == voidptr(0) { return }
    mut s := Article.statics()
    s.total_count = vphp.get_static_prop[int](ce, "total_count")
}
@[export: 'vphp_wrap_Article_construct']
pub fn vphp_wrap_article_construct(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &Article(ptr) }
    arg_0 := ctx.arg[string](0)
    arg_1 := ctx.arg[int](1)
    Article.sync_statics_from_php(ctx)
    res := recv.construct(arg_0, arg_1)
    Article.sync_statics_to_php(ctx)
    return voidptr(res)
}
@[export: 'vphp_wrap_Article_internal_format']
pub fn vphp_wrap_article_internal_format(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &Article(ptr) }
    Article.sync_statics_from_php(ctx)
    res := recv.internal_format()
    Article.sync_statics_to_php(ctx)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_Article_create']
pub fn vphp_wrap_article_create(ctx vphp.Context) voidptr {
    arg_0 := ctx.arg[string](0)
    Article.sync_statics_from_php(ctx)
    res := Article.create(arg_0)
    Article.sync_statics_to_php(ctx)
    return voidptr(res)
}
@[export: 'vphp_wrap_Article_get_formatted_title']
pub fn vphp_wrap_article_get_formatted_title(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &Article(ptr) }
    Article.sync_statics_from_php(ctx)
    res := recv.get_formatted_title()
    Article.sync_statics_to_php(ctx)
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_Article_save']
pub fn vphp_wrap_article_save(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &Article(ptr) }
    Article.sync_statics_from_php(ctx)
    res := recv.save()
    Article.sync_statics_to_php(ctx)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_Article_dump_properties']
pub fn vphp_wrap_article_dump_properties(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &Article(ptr) }
    arg_0 := ctx.arg_val(0)
    Article.sync_statics_from_php(ctx)
    recv.dump_properties(arg_0)
    Article.sync_statics_to_php(ctx)
}
@[export: 'vphp_wrap_Article_process_with_callback']
pub fn vphp_wrap_article_process_with_callback(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &Article(ptr) }
    arg_0 := ctx.arg_val(0)
    Article.sync_statics_from_php(ctx)
    res := recv.process_with_callback(arg_0)
    Article.sync_statics_to_php(ctx)
    ctx.return_val[bool](res)
}
@[export: 'vphp_wrap_Article_restore_author']
pub fn vphp_wrap_article_restore_author(ctx vphp.Context) voidptr {
    arg_0 := ctx.arg_val(0)
    Article.sync_statics_from_php(ctx)
    res := Article.restore_author(arg_0)
    Article.sync_statics_to_php(ctx)
    return voidptr(res)
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

@[export: 'Story_new_raw']
pub fn story_new_raw() voidptr {
    return vphp.generic_new_raw[Story]()
}
@[export: 'Story_get_prop']
pub fn story_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &Story(ptr)
        if name == 'chapter_count' {
            vphp.return_val_raw(rv, i64(obj.chapter_count))
            return
        }
    }
}
@[export: 'Story_set_prop']
pub fn story_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &Story(ptr)
        arg := vphp.ZVal{ raw: value }
        if name == 'chapter_count' {
            obj.chapter_count = int(arg.get_int())
            return
        }
    }
}
@[export: 'Story_sync_props']
pub fn story_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &Story(ptr)
        out := vphp.ZVal{ raw: zv }
        out.add_property_long('chapter_count', i64(obj.chapter_count))
    }
}
@[export: 'vphp_wrap_Story_create']
pub fn vphp_wrap_story_create(ctx vphp.Context) voidptr {
    arg_0 := unsafe { &Author(ctx.arg_raw_obj(0)) }
    arg_1 := ctx.arg[int](1)
    res := Story.create(arg_0, arg_1)
    return voidptr(res)
}
@[export: 'vphp_wrap_Story_tell']
pub fn vphp_wrap_story_tell(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &Story(ptr) }
    res := recv.tell()
    ctx.return_val[string](res)
}
@[export: 'Story_handlers']
pub fn story_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(story_get_prop)
        write_handler: voidptr(story_set_prop)
        sync_handler:  voidptr(story_sync_props)
        new_raw:       voidptr(story_new_raw)
    } }
}

@[export: 'ReadonlyRecord_new_raw']
pub fn readonlyrecord_new_raw() voidptr {
    return vphp.generic_new_raw[ReadonlyRecord]()
}
@[export: 'ReadonlyRecord_get_prop']
pub fn readonlyrecord_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &ReadonlyRecord(ptr)
        if name == 'created_at' {
            vphp.return_val_raw(rv, i64(obj.created_at))
            return
        }
        if name == 'title' {
            vphp.return_val_raw(rv, obj.title)
            return
        }
    }
}
@[export: 'ReadonlyRecord_set_prop']
pub fn readonlyrecord_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &ReadonlyRecord(ptr)
        arg := vphp.ZVal{ raw: value }
        if name == 'title' {
            obj.title = arg.get_string()
            return
        }
    }
}
@[export: 'ReadonlyRecord_sync_props']
pub fn readonlyrecord_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &ReadonlyRecord(ptr)
        out := vphp.ZVal{ raw: zv }
        out.add_property_long('created_at', i64(obj.created_at))
        out.add_property_string('title', obj.title)
        out.add_property_string('internal_note', obj.internal_note)
    }
}
@[export: 'vphp_wrap_ReadonlyRecord_construct']
pub fn vphp_wrap_readonlyrecord_construct(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &ReadonlyRecord(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.construct(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_ReadonlyRecord_reveal']
pub fn vphp_wrap_readonlyrecord_reveal(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &ReadonlyRecord(ptr) }
    res := recv.reveal()
    ctx.return_val[string](res)
}
@[export: 'ReadonlyRecord_handlers']
pub fn readonlyrecord_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(readonlyrecord_get_prop)
        write_handler: voidptr(readonlyrecord_set_prop)
        sync_handler:  voidptr(readonlyrecord_sync_props)
        new_raw:       voidptr(readonlyrecord_new_raw)
    } }
}

@[export: 'TraitPost_new_raw']
pub fn traitpost_new_raw() voidptr {
    return vphp.generic_new_raw[TraitPost]()
}
@[export: 'TraitPost_get_prop']
pub fn traitpost_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &TraitPost(ptr)
        if name == 'title' {
            vphp.return_val_raw(rv, obj.title)
            return
        }
        if name == 'slug' {
            vphp.return_val_raw(rv, obj.slug)
            return
        }
        if name == 'visits' {
            vphp.return_val_raw(rv, i64(obj.visits))
            return
        }
    }
}
@[export: 'TraitPost_set_prop']
pub fn traitpost_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &TraitPost(ptr)
        arg := vphp.ZVal{ raw: value }
        if name == 'title' {
            obj.title = arg.get_string()
            return
        }
        if name == 'slug' {
            obj.slug = arg.get_string()
            return
        }
        if name == 'visits' {
            obj.visits = int(arg.get_int())
            return
        }
    }
}
@[export: 'TraitPost_sync_props']
pub fn traitpost_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &TraitPost(ptr)
        out := vphp.ZVal{ raw: zv }
        out.add_property_string('title', obj.title)
        out.add_property_string('slug', obj.slug)
        out.add_property_long('visits', i64(obj.visits))
        out.add_property_string('internal_note', obj.internal_note)
    }
}
@[export: 'vphp_wrap_TraitPost_construct']
pub fn vphp_wrap_traitpost_construct(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &TraitPost(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.construct(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_TraitPost_summary']
pub fn vphp_wrap_traitpost_summary(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &TraitPost(ptr) }
    res := recv.summary()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_TraitPost_bump']
pub fn vphp_wrap_traitpost_bump(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &TraitPost(ptr) }
    res := recv.bump()
    ctx.return_val[int](res)
}
@[export: 'vphp_wrap_TraitPost_trait_only']
pub fn vphp_wrap_traitpost_trait_only(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &TraitPost(ptr) }
    res := recv.trait_only()
    ctx.return_val[string](res)
}
@[export: 'vphp_wrap_TraitPost_internal_trait']
pub fn vphp_wrap_traitpost_internal_trait(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &TraitPost(ptr) }
    res := recv.internal_trait()
    ctx.return_val[string](res)
}
@[export: 'TraitPost_handlers']
pub fn traitpost_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(traitpost_get_prop)
        write_handler: voidptr(traitpost_set_prop)
        sync_handler:  voidptr(traitpost_sync_props)
        new_raw:       voidptr(traitpost_new_raw)
    } }
}

@[export: 'VPhpTask_new_raw']
pub fn vphptask_new_raw() voidptr {
    return vphp.generic_new_raw[VPhpTask]()
}
@[export: 'VPhpTask_get_prop']
pub fn vphptask_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &VPhpTask(ptr)
    }
}
@[export: 'VPhpTask_set_prop']
pub fn vphptask_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &VPhpTask(ptr)
        arg := vphp.ZVal{ raw: value }
    }
}
@[export: 'VPhpTask_sync_props']
pub fn vphptask_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &VPhpTask(ptr)
        out := vphp.ZVal{ raw: zv }
    }
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

@[export: 'StringableBox_new_raw']
pub fn stringablebox_new_raw() voidptr {
    return vphp.generic_new_raw[StringableBox]()
}
@[export: 'StringableBox_get_prop']
pub fn stringablebox_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        obj := &StringableBox(ptr)
        if name == 'name' {
            vphp.return_val_raw(rv, obj.name)
            return
        }
    }
}
@[export: 'StringableBox_set_prop']
pub fn stringablebox_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len).clone()
        mut obj := &StringableBox(ptr)
        arg := vphp.ZVal{ raw: value }
        if name == 'name' {
            obj.name = arg.get_string()
            return
        }
    }
}
@[export: 'StringableBox_sync_props']
pub fn stringablebox_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        obj := &StringableBox(ptr)
        out := vphp.ZVal{ raw: zv }
        out.add_property_string('name', obj.name)
    }
}
@[export: 'vphp_wrap_StringableBox_construct']
pub fn vphp_wrap_stringablebox_construct(ptr voidptr, ctx vphp.Context) voidptr {
    mut recv := unsafe { &StringableBox(ptr) }
    arg_0 := ctx.arg[string](0)
    res := recv.construct(arg_0)
    return voidptr(res)
}
@[export: 'vphp_wrap_StringableBox_str']
pub fn vphp_wrap_stringablebox_str(ptr voidptr, ctx vphp.Context)  {
    mut recv := unsafe { &StringableBox(ptr) }
    res := recv.str()
    ctx.return_val[string](res)
}
@[export: 'StringableBox_handlers']
pub fn stringablebox_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(stringablebox_get_prop)
        write_handler: voidptr(stringablebox_set_prop)
        sync_handler:  voidptr(stringablebox_sync_props)
        new_raw:       voidptr(stringablebox_new_raw)
    } }
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

@[export: 'vphp_wrap_v_mutate_user_object']
fn vphp_wrap_v_mutate_user_object(ctx vphp.Context) {
    arg_0 := ctx
    v_mutate_user_object(arg_0)
}

@[export: 'vphp_wrap_v_check_user_object_props']
fn vphp_wrap_v_check_user_object_props(ctx vphp.Context) {
    arg_0 := ctx
    v_check_user_object_props(arg_0)
}

@[export: 'vphp_wrap_v_construct_php_object']
fn vphp_wrap_v_construct_php_object(ctx vphp.Context) {
    arg_0 := ctx
    v_construct_php_object(arg_0)
}

@[export: 'vphp_wrap_v_call_php_static_method']
fn vphp_wrap_v_call_php_static_method(ctx vphp.Context) {
    arg_0 := ctx
    v_call_php_static_method(arg_0)
}

@[export: 'vphp_wrap_v_mutate_php_static_prop']
fn vphp_wrap_v_mutate_php_static_prop(ctx vphp.Context) {
    arg_0 := ctx
    v_mutate_php_static_prop(arg_0)
}

@[export: 'vphp_wrap_v_read_php_class_constant']
fn vphp_wrap_v_read_php_class_constant(ctx vphp.Context) {
    arg_0 := ctx
    v_read_php_class_constant(arg_0)
}

@[export: 'vphp_wrap_v_typed_php_interop']
fn vphp_wrap_v_typed_php_interop(ctx vphp.Context) {
    arg_0 := ctx
    v_typed_php_interop(arg_0)
}

@[export: 'vphp_wrap_v_typed_object_restore']
fn vphp_wrap_v_typed_object_restore(ctx vphp.Context) {
    arg_0 := ctx
    v_typed_object_restore(arg_0)
}

@[export: 'vphp_wrap_v_read_php_global_const']
fn vphp_wrap_v_read_php_global_const(ctx vphp.Context) {
    arg_0 := ctx
    v_read_php_global_const(arg_0)
}

@[export: 'vphp_wrap_v_php_symbol_exists']
fn vphp_wrap_v_php_symbol_exists(ctx vphp.Context) {
    arg_0 := ctx
    v_php_symbol_exists(arg_0)
}

@[export: 'vphp_wrap_v_include_php_file']
fn vphp_wrap_v_include_php_file(ctx vphp.Context) {
    arg_0 := ctx
    v_include_php_file(arg_0)
}

@[export: 'vphp_wrap_v_include_php_file_once']
fn vphp_wrap_v_include_php_file_once(ctx vphp.Context) {
    arg_0 := ctx
    v_include_php_file_once(arg_0)
}

@[export: 'vphp_wrap_v_include_php_module_demo']
fn vphp_wrap_v_include_php_module_demo(ctx vphp.Context) {
    arg_0 := ctx
    v_include_php_module_demo(arg_0)
}

@[export: 'vphp_wrap_v_php_object_meta']
fn vphp_wrap_v_php_object_meta(ctx vphp.Context) {
    arg_0 := ctx
    v_php_object_meta(arg_0)
}

@[export: 'vphp_wrap_v_php_object_introspection']
fn vphp_wrap_v_php_object_introspection(ctx vphp.Context) {
    arg_0 := ctx
    v_php_object_introspection(arg_0)
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

@[export: 'vphp_wrap_v_test_globals']
fn vphp_wrap_v_test_globals(ctx vphp.Context) {
    arg_0 := ctx
    v_test_globals(arg_0)
}

@[export: 'vphp_wrap_v_get_v_closure']
fn vphp_wrap_v_get_v_closure(ctx vphp.Context) {
    arg_0 := ctx
    v_get_v_closure(arg_0)
}

@[export: 'vphp_wrap_v_get_v_closure_auto']
fn vphp_wrap_v_get_v_closure_auto(ctx vphp.Context) {
    arg_0 := ctx
    v_get_v_closure_auto(arg_0)
}

@[export: 'vphp_wrap_v_iter_helpers_demo']
fn vphp_wrap_v_iter_helpers_demo(ctx vphp.Context) {
    arg_0 := ctx
    v_iter_helpers_demo(arg_0)
}

@[export: 'vphp_wrap_v_iterable_object_demo']
fn vphp_wrap_v_iterable_object_demo(ctx vphp.Context) {
    arg_0 := ctx
    v_iterable_object_demo(arg_0)
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

@[export: 'vphp_wrap_v_slim_demo_dispatch']
fn vphp_wrap_v_slim_demo_dispatch(ctx vphp.Context) {
    arg_0 := ctx
    v_slim_demo_dispatch(arg_0)
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

@[export: 'vphp_ext_startup']
fn vphp_ext_startup() {
    vphp.ITask.register('AnalyzeTask', fn (ctx vphp.Context) vphp.ITask {
        return AnalyzeTask{
            symbol: ctx.arg[string](1)
            count: ctx.arg[int](2)
        }
    })
}
