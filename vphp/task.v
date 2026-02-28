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

// Creator 现在直接接收 Context，可以自由提取需要的参数
type TaskCreator = fn (ctx Context) ITask

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

// 暴露给 PHP：获取所有已注册的任务名称
pub fn task_list(ctx Context) {
	r := get_registry()
	mut names := []string{}
	for k, _ in r.tasks {
		names << k
	}
	ctx.return_val(names)
}

// 内部实现：Spawn 逻辑
pub fn task_spawn(ctx Context) {
	task_name := ctx.arg[string](0)

	creator := ITask.get_creator(task_name) or {
		throw_exception('Task $task_name not registered', 0)
		return
	}

	task_inst := creator(ctx)
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
		
		match results {
			string   { ctx.return_val[string](results) }
			int      { ctx.return_val[int](results) }
			i64      { ctx.return_val[i64](results) }
			f64      { ctx.return_val[f64](results) }
			bool     { ctx.return_val[bool](results) }
			[]string { ctx.return_val[[]string](results) }
			[]int    { ctx.return_val[[]int](results) }
			[]i64    { ctx.return_val[[]i64](results) }
			[]f64    { ctx.return_val[[]f64](results) }
		}
	}
}
