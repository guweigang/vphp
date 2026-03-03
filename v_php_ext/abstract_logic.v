module main

@[heap]
@[php_class]
@[php_abstract]
struct AbstractReport {
pub mut:
	title string
}

@[php_method]
pub fn (r &AbstractReport) label() string {
	return 'Report: ' + r.title
}

@[php_method]
@[php_abstract]
pub fn (r &AbstractReport) summarize() string {
	return r.title
}

@[heap]
@[php_class]
@[php_extends: 'AbstractReport']
struct DailyReport {
	AbstractReport
pub mut:
	summary string
}

@[php_method]
pub fn (mut r DailyReport) init(title string, summary string) &DailyReport {
	r.title = title
	r.summary = summary
	return r
}

@[php_method]
pub fn (r &DailyReport) summarize() string {
	return r.summary
}
