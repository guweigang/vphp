module main
import vphp

@[export: "vphp_task_auto_startup"]
fn vphp_task_auto_startup() {
    vphp.ITask.register('AnalyzeTask', fn(s string) vphp.ITask { return AnalyzeTask{ json_data: s } })
}
// 自动分配堆内存的分配器
@[export: 'Article_new_raw']
pub fn article_new_raw() voidptr {
    return unsafe { &Article{} }
}
@[export: 'Article_get_prop']
pub fn article_get_prop(ptr voidptr, name_ptr &char, name_len int, rv &C.zval) {
    unsafe {
        // 1. 安全构造 V 字符串，解决 C 传参导致的内存错位
        name := name_ptr.vstring_with_len(name_len)
        mut a := &Article(ptr)
        
        match name {
            'id' { 
                vphp.return_val_raw(rv, i64(a.id))
            }
            'title' { 
                vphp.return_val_raw(rv, a.title)
            }
            'is_top' { 
                vphp.return_val_raw(rv, a.is_top)
            }
            else { /* 保持 rv 为 IS_UNDEF，触发 C 侧回退到 PHP 默认属性槽 */ }
        }
    }
}
@[export: 'Article_set_prop']
pub fn article_set_prop(ptr voidptr, name_ptr &char, name_len int, value &C.zval) {
    unsafe {
        name := name_ptr.vstring_with_len(name_len)
        mut a := &Article(ptr)
        // 包装 zval 方便读取
        arg := vphp.Val{ raw: value }
        
        match name {
            'id' { 
                a.id = int(arg.get_int())
            }
            'title' { 
                a.title = arg.get_string()
            }
            'is_top' { 
                a.is_top = arg.get_bool()
            }
            else { }
        }
    }
}
@[export: 'Article_sync_props']
pub fn article_sync_props(ptr voidptr, zv &C.zval) {
    unsafe {
        mut a := &Article(ptr)
        // 包装一个临时的 context，利用现有的反射同步逻辑
        ctx := vphp.Context{ ex: 0, ret: zv }
        ctx.sync_props(a)
    }
}