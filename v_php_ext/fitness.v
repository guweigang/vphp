module main

import vphp

// 定义一个分析结果结构体，方便返回
struct MotionReport {
	user_name   string
	max_hr      f64
	min_hr      f64
	avg_hr      f64
	risk_level  string
	device_mode string
}

@[export: 'v_analyze_fitness_data']
fn v_analyze_fitness_data(ctx vphp.Context) {
	name    := ctx.arg[string](0)
	hr_data := ctx.arg[[]f64](1)
	config  := ctx.arg[map[string]string](2)
  if ctx.has_exception() { return }

	if hr_data.len == 0 {
		ctx.return_string('Error: No heart rate data provided')
		return
	}

	mut total := 0.0
	mut max := 0.0
	mut min := hr_data[0]

	for hr in hr_data {
		total += hr
		if hr > max { max = hr }
		if hr < min { min = hr }
	}

	avg := total / f64(hr_data.len)
	mode := config['mode'] or { 'standard' }

	mut risk := 'Low'
	if max > 170 {
		risk = 'High Risk'
	}

	report := MotionReport{
		user_name:   name
		max_hr:      max
		min_hr:      min
		avg_hr:      avg
		risk_level:  risk
		device_mode: mode
	}
	ctx.return_struct(report)
}

struct HeartPoint {
	timestamp int
	hr        f64
}

struct FinalReport {
	user_name string
	alerts    []HeartPoint
}

@[export: 'v_get_alerts']
fn v_get_alerts(ctx vphp.Context) {
	mut alerts := []HeartPoint{}
	alerts << HeartPoint{ 1677481200, 155.0 }
	alerts << HeartPoint{ 1677481260, 162.5 }

	ctx.return_list(alerts)
}
