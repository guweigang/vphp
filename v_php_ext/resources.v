module main

import vphp

struct Coach { mut: name string }
struct Database { mut: connected bool }

// 创建"教练"资源
@[export: 'v_new_coach']
fn v_new_coach(ctx vphp.Context) {
    unsafe {
        p := malloc(sizeof(Coach))
        mut c := &Coach(p)
        c.name = 'Bullsoft_Master'
        ctx.return_res(p, 'coach')
    }
}

// 创建"数据库"资源
@[export: 'v_new_db']
fn v_new_db(ctx vphp.Context) {
    unsafe {
        p := malloc(sizeof(Database))
        mut db := &Database(p)
        db.connected = true
        ctx.return_res(p, 'db')
    }
}

// 使用资源
@[export: 'v_check_res']
fn v_check_res(ctx vphp.Context) {
    res_val := ctx.arg_raw(0)

    unsafe {
        ptr := res_val.to_res()
        if ptr == nil {
            ctx.return_string('Invalid Resource')
            return
        }
        mut coach := &Coach(ptr)
        ctx.return_string('Hello, ' + coach.name)
    }
}
