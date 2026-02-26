module main
import vphp

@[export: "vphp_task_auto_startup"]
fn vphp_task_auto_startup() {
    vphp.ITask.register('AnalyzeTask', fn() vphp.ITask { return AnalyzeTask{} })
}