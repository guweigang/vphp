module vphp

import vphp.zend as _

// 并发任务的异步结果包装器
pub struct AsyncResult {
pub mut:
	handle thread []f64
}

// 通用任务接口
pub interface ITask {
	json_data string // 通用参数容器
	run() []f64      // 通用返回类型
}

type TaskCreator = fn (json_data string) ITask

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

// 内部实现：Spawn 逻辑
pub fn task_spawn(ctx Context) {
	task_name := ctx.arg[string](0)
	json_params := ctx.arg[string](1)

	creator := ITask.get_creator(task_name) or {
		throw_exception('Task $task_name not registered', 0)
		return
	}

	task_inst := creator(json_params)
	t := spawn task_inst.run()

	unsafe {
		mut res := &AsyncResult(malloc(int(sizeof(AsyncResult))))
		res.handle = t
		ctx.return_res(res, 'v_task')
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

		mut task := &AsyncResult(ptr)
		results := task.handle.wait()
		ctx.return_val(results)
	}
}
