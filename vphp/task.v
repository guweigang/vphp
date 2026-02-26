module vphp
import json
import vphp.zend

// Spawn 支持
// 1. 定义通用任务接口
pub interface ITask {
  json_data string // 通用参数容器
	run() []f64 // 目前以 []f64 为通用返回类型，后续可扩展
}

type TaskCreator = fn (json_data string) ITask

// 这里我们用一个更符合 V 规范的方式：定义一个结构体来持有 map
struct TaskRegistry {
pub mut:
	tasks map[string]TaskCreator
}

// 获取单例注册表
// 修复：定义一个全局指针 (需要 build.v 开启 -enable-globals)
__global (
	g_registry &TaskRegistry
)

fn get_registry() &TaskRegistry {
	unsafe {
		// 如果指针为空，则初始化
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


@[export: 'v_spawn']
fn framework_v_spawn(ex &C.zend_execute_data, retval &C.zval) {
	ctx := new_context(ex, retval)
	task_name := ctx.arg[string](0)
	json_params := ctx.arg[string](1)

	// 使用新的 get_creator 逻辑
	creator := ITask.get_creator(task_name) or {
		throw_exception('Task $task_name not registered', 0)
		return
	}

	task_inst := creator(json_params)
	// 注意：spawn 接口方法时，V 有时需要明确返回值类型
	t := spawn task_inst.run()

	unsafe {
		mut res := &zend.AsyncResult(malloc(int(sizeof(zend.AsyncResult))))
		res.handle = t
		ctx.return_res(res, 'v_task')
	}
}

@[export: 'v_wait']
fn framework_v_wait(ex &C.zend_execute_data, retval &C.zval) {
	ctx := new_context(ex, retval)
	res_val := ctx.arg_raw(0)

	unsafe {
		ptr := res_val.to_res()
		if ptr == nil { return }

		mut task := &zend.AsyncResult(ptr)
		results := task.handle.wait()

		C.vphp_return_array_start(retval)
		for r in results {
			// 显式转换 f64 -> f64 (解决 double 报错)
			C.vphp_array_push_double(retval, f64(r))
		}
	}
}
