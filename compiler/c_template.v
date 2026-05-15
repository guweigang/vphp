module compiler

// 模板变量替换
fn render_tpl(tpl string, vars map[string]string) string {
	mut out := tpl
	for k, v in vars {
		out = out.replace('{{${k}}}', v)
	}
	return out
}

// 将 V 字符串中的 \ 转义为 C 字符串字面量的 \\
fn c_string_escape(s string) string {
	return s.replace('\\', '\\\\')
}
