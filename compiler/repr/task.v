module repr

pub struct PhpTaskRepr {
pub mut:
	task_name  string       // 任务的 PHP 注册名称
	v_name     string       // 任务在 V 语言中的 struct 名称
	parameters []PhpTaskArg // 保存提取的字段及其类型
}

pub struct PhpTaskArg {
pub mut:
	name   string
	v_type string
}

pub fn new_task_repr() &PhpTaskRepr {
	return &PhpTaskRepr{}
}
