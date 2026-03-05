module main

import vphp

struct IterTextState {
mut:
	buf   string
	first bool = true
}

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

@[php_function]
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

@[php_function]
fn v_test_map(ctx vphp.Context) {
	config := ctx.arg[map[string]string](0)

	if 'name' in config {
		println('Received name: ' + config['name'])
	}

	ctx.return_string('Map processed, keys: ${config.keys()}')
}

@[php_function]
fn v_get_config(ctx vphp.Context) {
	input := ctx.arg_raw(0)

	db_val := input.get('db_name') or {
		vphp.report_error(vphp.e_warning, 'db_name is missing, using default')
		ctx.return_string('bullsoft_db')
		return
	}

	ctx.return_string(db_val.to_string())
}

@[php_function]
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

@[php_function]
fn v_call_back(ctx vphp.Context) {
	php_version := vphp.php_fn('phpversion').call([])

	ctx.return_string('V knows PHP version is: ' + php_version.to_string())
}

@[php_function]
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

@[php_function]
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

@[php_function]
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

@[php_function]
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

@[php_function]
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

@[php_function]
fn v_call_php_static_method(ctx vphp.Context) {
	res := vphp.php_class('PhpMath').static_method('triple', [vphp.ZVal.new_int(7)])
	ctx.return_string('static=' + res.to_int().str())
}

@[php_function]
fn v_mutate_php_static_prop(ctx vphp.Context) {
	cls := vphp.php_class('PhpCounter')
	before := cls.static_prop('count').to_int()
	cls.set_static_prop('count', vphp.ZVal.new_int(before + 5))
	after := cls.static_prop('count').to_int()
	ctx.return_string('static_prop=${before}->${after}')
}

@[php_function]
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

@[php_function]
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

@[php_function]
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

@[php_function]
fn v_zval_conversion_api(ctx vphp.Context) {
	cfg_z := vphp.ZVal.from[map[string]string]({
		'lang':   'v'
		'bridge': 'vphp'
	}) or {
		vphp.throw_exception('ZVal.from map failed: ${err.msg()}', 0)
		return
	}
	cfg := cfg_z.to_v[map[string]string]() or {
		vphp.throw_exception('to_v map failed: ${err.msg()}', 0)
		return
	}

	mut nums_z := vphp.ZVal.new_null()
	nums_z.from_v[[]int]([7, 8, 9]) or {
		vphp.throw_exception('from_v list failed: ${err.msg()}', 0)
		return
	}
	nums := nums_z.to_v[[]int]() or {
		vphp.throw_exception('to_v list failed: ${err.msg()}', 0)
		return
	}

	flag_z := vphp.ZVal.from[bool](true) or {
		vphp.throw_exception('ZVal.from bool failed: ${err.msg()}', 0)
		return
	}
	flag := flag_z.to_v[bool]() or {
		vphp.throw_exception('to_v bool failed: ${err.msg()}', 0)
		return
	}

	ctx.return_string('conv=${cfg['lang']}:${cfg['bridge']}:${nums.len}:${nums[0]}:${flag}')
}

@[php_function]
fn v_unified_object_interop(ctx vphp.Context) {
	cls := vphp.php_class('PhpUnifiedBox')
	name_z := vphp.ZVal.from[string]('neo') or {
		vphp.throw_exception('build name arg failed: ${err.msg()}', 0)
		return
	}
	score_z := vphp.ZVal.from[int](21) or {
		vphp.throw_exception('build score arg failed: ${err.msg()}', 0)
		return
	}
	obj := cls.construct([name_z, score_z])
	if !obj.is_object() {
		vphp.throw_exception('construct PhpUnifiedBox failed', 0)
		return
	}

	name := obj.prop_v[string]('name') or {
		vphp.throw_exception('prop_v(name) failed: ${err.msg()}', 0)
		return
	}
	double_score := obj.method_v[int]('doubleScore', []) or {
		vphp.throw_exception('method_v(doubleScore) failed: ${err.msg()}', 0)
		return
	}
	triple := cls.static_method_v[int]('triple', [vphp.ZVal.new_int(4)]) or {
		vphp.throw_exception('static_method_v(triple) failed: ${err.msg()}', 0)
		return
	}
	label := cls.const_v[string]('LABEL') or {
		vphp.throw_exception('const_v(LABEL) failed: ${err.msg()}', 0)
		return
	}
	upper := vphp.php_fn('strtoupper').invoke_v[string]([vphp.ZVal.new_string(name)]) or {
		vphp.throw_exception('invoke_v(strtoupper) failed: ${err.msg()}', 0)
		return
	}

	ctx.return_string('interop=${name}:${double_score}:${triple}:${label}:${upper}')
}

@[php_function]
fn v_read_php_global_const(ctx vphp.Context) {
	const_name := ctx.arg[string](0)
	value := vphp.php_const(const_name)
	if !value.is_valid() {
		vphp.throw_exception('读取常量失败: ${const_name}', 0)
		return
	}
	ctx.return_string('${const_name}=${value.to_string()}')
}

@[php_function]
fn v_php_symbol_exists(ctx vphp.Context) {
	ctx.return_map({
		'function_strlen':     vphp.function_exists('strlen').str()
		'function_missing':    vphp.function_exists('definitely_missing_fn').str()
		'class_datetime':      vphp.class_exists('DateTimeImmutable').str()
		'class_missing':       vphp.class_exists('Nope\\MissingClass').str()
		'interface_json':      vphp.interface_exists('JsonSerializable').str()
		'interface_missing':   vphp.interface_exists('Nope\\MissingInterface').str()
		'trait_user':          vphp.trait_exists('Demo\\Interop\\HelperTrait').str()
		'trait_missing':       vphp.trait_exists('Nope\\MissingTrait').str()
		'const_php_version':   vphp.global_const_exists('PHP_VERSION').str()
		'const_missing':       vphp.global_const_exists('NOPE_MISSING_CONST').str()
	})
}

@[php_function]
fn v_include_php_file(ctx vphp.Context) {
	path := ctx.arg[string](0)
	result := vphp.include(path)
	if !result.is_valid() {
		vphp.throw_exception('include 失败: ${path}', 0)
		return
	}
	ctx.return_zval(result)
}

@[php_function]
fn v_include_php_file_once(ctx vphp.Context) {
	path := ctx.arg[string](0)
	result := vphp.include_once(path)
	if !result.is_valid() {
		vphp.throw_exception('include_once 失败: ${path}', 0)
		return
	}
	ctx.return_zval(result)
}

@[php_function]
fn v_include_php_module_demo(ctx vphp.Context) {
	path := ctx.arg[string](0)
	config := vphp.include_once(path)
	if !config.is_valid() {
		vphp.throw_exception('include_once 失败: ${path}', 0)
		return
	}
	if !config.is_array() {
		vphp.throw_exception('fixture 必须返回 array', 0)
		return
	}
	if !vphp.class_exists('Demo\\IncludeCase\\ModuleBox') {
		vphp.throw_exception('Demo\\IncludeCase\\ModuleBox 未加载', 0)
		return
	}

	box := vphp.php_class('Demo\\IncludeCase\\ModuleBox').construct([
		vphp.ZVal.new_string('codex'),
	])
	class_name := box.class_name()
	short_name := box.short_name()
	desc := box.method_v[string]('describe', []) or {
		vphp.throw_exception('调用 describe 失败: ${err.msg()}', 0)
		return
	}

	mut entries := []string{}
	entries = config.foreach_with_ctx[[]string](entries, fn (key vphp.ZVal, val vphp.ZVal, mut acc []string) {
		acc << '${key.to_string()}=${val.to_string()}'
	})

	ctx.return_string('count=${config.array_count()}|class=${class_name}|short=${short_name}|desc=${desc}|items=${entries.join(",")}')
}

@[php_function]
fn v_php_object_meta(ctx vphp.Context) {
	obj := ctx.arg_raw(0)
	if !obj.is_object() {
		vphp.throw_exception('需要对象参数', 0)
		return
	}

	ctx.return_map({
		'class':      obj.class_name()
		'namespace':  obj.namespace_name()
		'short':      obj.short_name()
		'parent':     obj.parent_class_name()
		'internal':   obj.is_internal_class().str()
		'user_class': obj.is_user_class().str()
		'interfaces': obj.interface_names().join(',')
	})
}

@[php_function]
fn v_php_object_introspection(ctx vphp.Context) {
	obj := ctx.arg_raw(0)
	if !obj.is_object() {
		vphp.throw_exception('需要对象参数', 0)
		return
	}

	ctx.return_map({
		'is_box':              obj.is_instance_of('Demo\\Inspect\\GreeterBox').str()
		'is_datetime':         obj.is_instance_of('DateTimeImmutable').str()
		'is_subclass_parent':  obj.is_subclass_of('Demo\\Inspect\\BaseBox').str()
		'is_subclass_self':    obj.is_subclass_of('Demo\\Inspect\\GreeterBox').str()
		'implements_string':   obj.implements_interface('Stringable').str()
		'implements_json':     obj.implements_interface('JsonSerializable').str()
		'has_method_greet':     obj.method_exists('greet').str()
		'has_method_missing':   obj.method_exists('missingMethod').str()
		'method_names':         obj.method_names().join(',')
		'has_prop_name':        obj.property_exists('name').str()
		'has_prop_missing':     obj.property_exists('missingProp').str()
		'property_names':       obj.property_names().join(',')
		'class_consts':         obj.const_names().join(',')
		'datetime_has_atom':    vphp.php_class('DateTimeImmutable').const_exists('ATOM').str()
	})
}

@[php_function]
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

@[php_function]
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

@[php_function]
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
@[php_function]
fn v_get_v_closure(ctx vphp.Context) {
	// 定义一个简单的 int -> int 闭包，供 test_closure.php 使用
	v_cb := fn (n int) int {
		return n * 10
	}
	ctx.wrap_closure(v_cb)
}

// 测试 V 侧原生闭包自动转换。
@[php_function]
fn v_get_v_closure_auto(ctx vphp.Context) {
	prefix := 'V-Power'
	// 定义一个带捕获的原生 V 闭包。
	v_cb := fn [prefix] (name string, count int) string {
		return '${prefix}: Hello ${name}, count is ${count}'
	}

	// 自动化包装成 PHP 对象。
	ctx.wrap_closure(v_cb)
}

@[php_function]
fn v_iter_helpers_demo(ctx vphp.Context) {
	input := ctx.arg_raw(0)
	if !input.is_array() {
		vphp.throw_exception('需要 array 参数', 0)
		return
	}

	mut each_state := IterTextState{}
	mut each_ref := &each_state
	input.each(fn [each_ref] (key vphp.ZVal, val vphp.ZVal) {
		unsafe {
			if !(*each_ref).first {
				(*each_ref).buf += ','
			}
			(*each_ref).buf += '${key.to_string()}=${val.to_string()}'
			(*each_ref).first = false
		}
	})
	fold_items := input.fold[[]string]([]string{}, fn (key vphp.ZVal, val vphp.ZVal, mut acc []string) {
		acc << '${key.to_string()}=${val.to_string()}'
	})
	values := input.fold[[]string]([]string{}, fn (key vphp.ZVal, val vphp.ZVal, mut acc []string) {
		acc << val.to_string()
	})
	reduced_parts := input.reduce[[]string]([]string{}, fn (_ vphp.ZVal, val vphp.ZVal, mut acc []string) {
		acc << val.to_string()
	})
	reduced := reduced_parts.join('|')

	ctx.return_string('each=${each_state.buf};fold=${fold_items.join(",")};values=${values.join(",")};reduce=${reduced}')
}

@[php_function]
fn v_iterable_object_demo(ctx vphp.Context) {
	input := ctx.arg_raw(0)
	mut each_state := IterTextState{}
	mut each_ref := &each_state
	input.each(fn [each_ref] (key vphp.ZVal, val vphp.ZVal) {
		unsafe {
			if !(*each_ref).first {
				(*each_ref).buf += ','
			}
			(*each_ref).buf += '${key.to_string()}=${val.to_string()}'
			(*each_ref).first = false
		}
	})
	fold_items := input.fold[[]string]([]string{}, fn (key vphp.ZVal, val vphp.ZVal, mut acc []string) {
		acc << '${key.to_string()}=${val.to_string()}'
	})
	ctx.return_string('each=${each_state.buf};fold=${fold_items.join(",")};count=${fold_items.len}')
}
