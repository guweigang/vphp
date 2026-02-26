module main
import vphp

@[export: "vphp_task_auto_startup"]
fn vphp_task_auto_startup() {
    vphp.ITask.register('AnalyzeTask', fn(s string) vphp.ITask { return AnalyzeTask{ json_data: s } })
}