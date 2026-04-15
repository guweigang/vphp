module vphp

import vphp.zend as _

// 任务可能的返回结果，定义为 Sum Type（代数数据类型）
pub type TaskResult = string | int | i64 | f64 | bool | []string | []int | []i64 | []f64

// 并发任务的异步结果包装器
pub struct AsyncResult {
pub mut:
	handle thread TaskResult
}

// 通用任务接口
pub interface ITask {
	run() TaskResult // 返回动态类型
}

// Creator directly receives already-decoded PHP args.
type TaskCreator = fn (args []ZVal) ITask

struct TaskRegistry {
pub mut:
	tasks map[string]TaskCreator
}

__global (
	g_registry &TaskRegistry
)

fn get_registry() &TaskRegistry {
	unsafe {
		if g_registry == 0 {
			g_registry = &TaskRegistry{
				tasks: map[string]TaskCreator{}
			}
		}
		return g_registry
	}
}

pub fn ITask.register(name string, creator TaskCreator) {
	mut r := get_registry()
	r.tasks[name] = creator
}

pub fn ITask.get_creator(name string) ?TaskCreator {
	r := get_registry()
	if name in r.tasks {
		return r.tasks[name]
	}
	return none
}

pub fn task_exists(name string) bool {
	r := get_registry()
	return name in r.tasks
}

pub fn task_names() []string {
	r := get_registry()
	mut names := []string{}
	for k, _ in r.tasks {
		names << k
	}
	return names
}

pub fn task_spawn_handle(task_name string, args []ZVal) !&AsyncResult {
	creator := ITask.get_creator(task_name) or { return error('Task ${task_name} not registered') }

	task_inst := creator(args)
	t := spawn task_inst.run()

	unsafe {
		mut res := &AsyncResult(C.emalloc(usize(sizeof(AsyncResult))))
		res.handle = t
		return res
	}
}

pub fn task_wait_result(ptr voidptr) !TaskResult {
	unsafe {
		if ptr == nil {
			return error('Task handle is nil')
		}

		task := &AsyncResult(ptr)
		return task.handle.wait()
	}
}

pub fn task_release_handle(ptr voidptr) {
	if ptr == 0 {
		return
	}
	unsafe {
		C.efree(ptr)
	}
}

pub fn task_wait_box(ptr voidptr) RequestOwnedZBox {
	results := task_wait_result(ptr) or { return RequestOwnedZBox.new_null() }

	match results {
		string {
			return RequestOwnedZBox.new_string(results)
		}
		int {
			return RequestOwnedZBox.new_int(i64(results))
		}
		i64 {
			return RequestOwnedZBox.new_int(results)
		}
		f64 {
			return RequestOwnedZBox.new_float(results)
		}
		bool {
			return RequestOwnedZBox.new_bool(results)
		}
		[]string {
			mut out := RequestOwnedZBox.new_null().to_zval()
			out.array_init()
			for item in results {
				out.push_string(item)
			}
			return RequestOwnedZBox.adopt_zval(out)
		}
		[]int {
			mut out := RequestOwnedZBox.new_null().to_zval()
			out.array_init()
			for item in results {
				out.push_long(i64(item))
			}
			return RequestOwnedZBox.adopt_zval(out)
		}
		[]i64 {
			mut out := RequestOwnedZBox.new_null().to_zval()
			out.array_init()
			for item in results {
				out.push_long(item)
			}
			return RequestOwnedZBox.adopt_zval(out)
		}
		[]f64 {
			mut out := RequestOwnedZBox.new_null().to_zval()
			out.array_init()
			for item in results {
				out.push_double(item)
			}
			return RequestOwnedZBox.adopt_zval(out)
		}
	}
}

// 暴露给 PHP：获取所有已注册的任务名称
pub fn task_list(ctx Context) {
	ctx.return_val(task_names())
}

// 内部实现：Spawn 逻辑
pub fn task_spawn(ctx Context) {
	task_name := ctx.arg[string](0)
	args := ctx.get_args()
	task_args := if args.len > 1 { args[1..] } else { []ZVal{} }

	task_ref := task_spawn_handle(task_name, task_args) or {
		throw_exception(err.msg(), 0)
		return
	}

	unsafe {
		ctx.return_res(task_ref, 'v_task')
	}
}

// 内部实现：Wait 逻辑
pub fn task_wait(ctx Context) {
	res_val := ctx.arg_raw(0)

	unsafe {
		ptr := res_val.to_res()
		if ptr == nil {
			return
		}
		ctx.return_zval(task_wait_box(ptr).to_zval())
	}
}

fn C.emalloc(size usize) voidptr
fn C.efree(ptr voidptr)
