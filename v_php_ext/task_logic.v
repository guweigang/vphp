module main

import vphp

// === 新增：利用 @[php_class] 机制定义的 VPhp\Task ===
@[php_task: 'AnalyzeTask']
struct AnalyzeTask {
pub mut:
    symbol string
    count  int
}

fn (t AnalyzeTask) run() vphp.TaskResult {
    println('V: 正在处理 ${t.symbol}, count: ${t.count}')
    return [1.0, 2.0] // 隐式转换为 TaskResult (Sum Type中的 []f64)
}

@[php_class: 'VPhp\\Task']
struct VPhpTask {}

@[php_method]
pub fn VPhpTask.spawn(ctx vphp.Context) {
	vphp.task_spawn(ctx)
}

@[php_method]
pub fn VPhpTask.wait(ctx vphp.Context) {
	vphp.task_wait(ctx)
}

@[php_method]
pub fn VPhpTask.list(ctx vphp.Context) {
	vphp.task_list(ctx)
}
