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
@[export: 'Article_handlers']
pub fn article_handlers() voidptr {
    return unsafe { &C.vphp_class_handlers{
        prop_handler:  voidptr(article_get_prop)
        write_handler: voidptr(article_set_prop)
        sync_handler:  voidptr(article_sync_props)
        new_raw:       voidptr(article_new_raw)
    } }
}