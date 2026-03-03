module main

import vphp

@[php_function]
fn v_add(a i64, b i64) i64 {
	return a + b
}

@[php_function]
fn v_greet(name string) string {
	return 'Hello, ${name} from V pure wrapper!'
}

@[php_function]
fn v_pure_map_test(k string, v string) map[string]string {
	return {
		k: v
	}
}

@[export: 'v_process_list']
fn v_process_list(ctx vphp.Context) {
	input_list := ctx.arg[[]string](0)

	unsafe {
		C.vphp_array_init(ctx.ret)

		for i := input_list.len - 1; i >= 0; i-- {
			val := input_list[i]
			C.vphp_array_push_string(ctx.ret, &char(val.str))
		}
	}
}

@[export: 'v_test_map']
fn v_test_map(ctx vphp.Context) {
	config := ctx.arg[map[string]string](0)

	if 'name' in config {
		println('Received name: ' + config['name'])
	}

	ctx.return_string('Map processed, keys: ${config.keys()}')
}

@[export: 'v_get_config']
fn v_get_config(ctx vphp.Context) {
	input := ctx.arg_raw(0)

	db_val := input.get('db_name') or {
		vphp.report_error(vphp.e_warning, 'db_name is missing, using default')
		ctx.return_string('bullsoft_db')
		return
	}

	ctx.return_string(db_val.to_string())
}

@[export: 'v_get_user']
fn v_get_user(ctx vphp.Context) {
	raw_id := ctx.arg_raw(0)
	println('DEBUG: PHP ID Type: ${raw_id.type_id()}')

	user_id := ctx.arg[i64](0)

	mut user_data := map[string]string{}
	user_data['id'] = user_id.str()
	user_data['name'] = 'Gu Weigang'
	user_data['role'] = 'Developer'
	user_data['company'] = 'Bullsoft'

	ctx.return_object(user_data)
}

@[export: 'v_call_back']
fn v_call_back(ctx vphp.Context) {
	php_version := vphp.php_fn('phpversion').call([])

	ctx.return_string('V knows PHP version is: ' + php_version.to_string())
}

@[export: 'v_complex_test']
fn v_complex_test(ctx vphp.Context) {
	s := ctx.arg[string](0)
	i := ctx.arg[int](1)
	b := ctx.arg[bool](2)
	list := ctx.arg[[]f64](3)

	if ctx.has_exception() {
		return
	}

	mut res := map[string]string{}
	res['str_val'] = s
	res['int_val'] = i.str()
	res['bool_val'] = b.str()
	res['list_len'] = list.len.str()

	ctx.return_map(res)
}

@[export: 'v_analyze_user_object']
fn v_analyze_user_object(ctx vphp.Context) {
	user_obj := ctx.arg_raw(0)

	if !user_obj.is_object() {
		vphp.throw_exception('Expected object, got ${user_obj.type_name()}', 0)
		return
	}

	name := user_obj.get_prop_string('name')
	age := user_obj.get_prop_int('age')

	if ctx.has_exception() {
		return
	}

	res_msg := 'V 侧收到对象数据：姓名=${name}, 年龄=${age}'
	ctx.return_string(res_msg)
}

@[export: 'v_mutate_user_object']
fn v_mutate_user_object(ctx vphp.Context) {
	user_obj := ctx.arg_raw(0)
	if !user_obj.is_object() {
		vphp.throw_exception('需要 User 对象', 0)
		return
	}

	user_obj.set_prop('name', vphp.ZVal.new_string('Updated by V'))
	user_obj.set_prop('age', vphp.ZVal.new_int(20))

	name := user_obj.prop('name').to_string()
	age := user_obj.prop('age').to_int()
	ctx.return_string('updated=${name}:${age}')
}

@[export: 'v_check_user_object_props']
fn v_check_user_object_props(ctx vphp.Context) {
	user_obj := ctx.arg_raw(0)
	if !user_obj.is_object() {
		vphp.throw_exception('需要 User 对象', 0)
		return
	}

	has_name := user_obj.has_prop('name')
	isset_name := user_obj.isset_prop('name')
	has_note := user_obj.has_prop('note')
	isset_note := user_obj.isset_prop('note')
	user_obj.unset_prop('age')
	has_age_after_unset := user_obj.has_prop('age')

	ctx.return_map({
		'has_name':            has_name.str()
		'isset_name':          isset_name.str()
		'has_note':            has_note.str()
		'isset_note':          isset_note.str()
		'has_age_after_unset': has_age_after_unset.str()
	})
}

@[export: 'v_construct_php_object']
fn v_construct_php_object(ctx vphp.Context) {
	obj := vphp.php_class('PhpGreeter').construct([vphp.ZVal.new_string('Codex')])
	if !obj.is_object() {
		vphp.throw_exception('构造 PhpGreeter 失败', 0)
		return
	}

	msg := obj.method('greet', []).to_string()
	name := obj.prop('name').to_string()
	ctx.return_string('constructed=${name}:${msg}')
}

@[export: 'v_call_php_static_method']
fn v_call_php_static_method(ctx vphp.Context) {
	res := vphp.php_class('PhpMath').static_method('triple', [vphp.ZVal.new_int(7)])
	ctx.return_string('static=' + res.to_int().str())
}

@[export: 'v_mutate_php_static_prop']
fn v_mutate_php_static_prop(ctx vphp.Context) {
	cls := vphp.php_class('PhpCounter')
	before := cls.static_prop('count').to_int()
	cls.set_static_prop('count', vphp.ZVal.new_int(before + 5))
	after := cls.static_prop('count').to_int()
	ctx.return_string('static_prop=${before}->${after}')
}

@[export: 'v_read_php_class_constant']
fn v_read_php_class_constant(ctx vphp.Context) {
	article_max := vphp.php_class('Article').const_v[int]('MAX_TITLE_LEN') or {
		vphp.throw_exception('读取 Article::MAX_TITLE_LEN 失败: ${err.msg()}', 0)
		return
	}
	php_version := vphp.php_class('PhpMeta').const_v[string]('VERSION') or {
		vphp.throw_exception('读取 PhpMeta::VERSION 失败: ${err.msg()}', 0)
		return
	}
	ctx.return_string('consts=${article_max}:${php_version}')
}

@[export: 'v_typed_php_interop']
fn v_typed_php_interop(ctx vphp.Context) {
	obj := ctx.arg_raw(0)
	if !obj.is_object() {
		vphp.throw_exception('需要 PhpTypedBox 对象', 0)
		return
	}

	length := vphp.php_fn('strlen').call_v[int]([vphp.ZVal.new_string('codex')]) or {
		vphp.throw_exception('调用 strlen 失败: ${err.msg()}', 0)
		return
	}
	name := obj.prop_v[string]('name') or {
		vphp.throw_exception('读取 name 属性失败: ${err.msg()}', 0)
		return
	}
	score := obj.method_v[int]('doubleScore', []) or {
		vphp.throw_exception('调用 doubleScore 失败: ${err.msg()}', 0)
		return
	}
	count := vphp.php_class('PhpTypedBox').static_prop_v[int]('count') or {
		vphp.throw_exception('读取静态属性 count 失败: ${err.msg()}', 0)
		return
	}
	label := vphp.php_class('PhpTypedBox').const_v[string]('LABEL') or {
		vphp.throw_exception('读取类常量 LABEL 失败: ${err.msg()}', 0)
		return
	}

	ctx.return_string('typed=${length}:${name}:${score}:${count}:${label}')
}

@[export: 'v_typed_object_restore']
fn v_typed_object_restore(ctx vphp.Context) {
	mut author := vphp.php_class('Author').static_method_object[Author]('create', [
		vphp.ZVal.new_string('Typed Author'),
	]) or {
		vphp.throw_exception('恢复 Author 对象失败', 0)
		return
	}

	mut article := vphp.php_class('Article').construct_object[Article]([
		vphp.ZVal.new_string('Typed Article'),
		vphp.ZVal.new_int(77),
	]) or {
		vphp.throw_exception('构造 Article 对象失败', 0)
		return
	}

	ctx.return_string('objects=${author.name}:${article.id}:${article.title}:${article.is_top}')
}

@[export: 'v_trigger_user_action']
fn v_trigger_user_action(ctx vphp.Context) {
	user_obj := ctx.arg_raw(0)
	if !user_obj.is_object() {
		vphp.throw_exception('需要 User 对象', 0)
		return
	}

	mut score_val := vphp.ZVal{
		raw: C.vphp_new_zval()
	}
	score_val.set_int(100)

	res := user_obj.method('updateScore', [score_val])

	if ctx.has_exception() {
		return
	}

	ctx.return_string('Action triggered, PHP returned: ' + res.to_string())
}

@[export: 'v_call_php_closure']
fn v_call_php_closure(ctx vphp.Context) {
	cb := ctx.arg_raw(0)

	mut msg := vphp.ZVal{
		raw: C.vphp_new_zval()
	}
	msg.set_string('Message from V Engine')

	res := cb.call([msg])

	if ctx.has_exception() {
		return
	}

	ctx.return_string('Closure executed, PHP said: ' + res.to_string())
}

@[export: 'v_test_globals']
fn v_test_globals(ctx vphp.Context) {
	mut g := vphp.get_globals[ExtGlobals]()
	g.request_count++
	g.last_user = 'VPHP_USER'

	ctx.return_map({
		'count': g.request_count.str()
		'user':  g.last_user
	})
}

// 测试 V 侧原生闭包自动转换。
@[export: 'v_get_v_closure']
@[php_function]
fn v_get_v_closure(ctx vphp.Context) {
	// 定义一个简单的 int -> int 闭包，供 test_closure.php 使用
	v_cb := fn (n int) int {
		return n * 10
	}
	ctx.wrap_closure(v_cb)
}

// 测试 V 侧原生闭包自动转换。
@[export: 'v_get_v_closure_auto']
fn v_get_v_closure_auto(ctx vphp.Context) {
	prefix := 'V-Power'
	// 定义一个带捕获的原生 V 闭包。
	v_cb := fn [prefix] (name string, count int) string {
		return '${prefix}: Hello ${name}, count is ${count}'
	}

	// 自动化包装成 PHP 对象。
	ctx.wrap_closure(v_cb)
}
