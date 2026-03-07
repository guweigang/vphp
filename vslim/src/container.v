module main

import vphp

@[heap]
@[php_class: 'VSlim\\Container\\ContainerException']
@[php_extends: 'Exception']
@[php_implements: 'Psr\\Container\\ContainerExceptionInterface']
struct VSlimContainerException {}

@[heap]
@[php_class: 'VSlim\\Container\\NotFoundException']
@[php_extends: 'VSlim\\Container\\ContainerException']
@[php_implements: 'Psr\\Container\\NotFoundExceptionInterface']
struct VSlimContainerNotFoundException {}

@[heap]
@[php_class: 'VSlim\\Container']
@[php_implements: 'Psr\\Container\\ContainerInterface']
struct VSlimContainer {
mut:
	entries   map[string]vphp.PersistentOwnedZVal
	factories map[string]vphp.PersistentOwnedZVal
	resolved  map[string]vphp.PersistentOwnedZVal
}

@[php_method]
pub fn (mut c VSlimContainer) construct() &VSlimContainer {
	c.entries = map[string]vphp.PersistentOwnedZVal{}
	c.factories = map[string]vphp.PersistentOwnedZVal{}
	c.resolved = map[string]vphp.PersistentOwnedZVal{}
	return &c
}

@[php_method]
pub fn (mut c VSlimContainer) set(id string, value vphp.ZVal) &VSlimContainer {
	c.entries[id] = vphp.PersistentOwnedZVal.from_zval(value)
	c.factories.delete(id)
	c.resolved.delete(id)
	return &c
}

@[php_method]
pub fn (mut c VSlimContainer) factory(id string, callable vphp.ZVal) &VSlimContainer {
	if !callable.is_valid() || !callable.is_callable() {
		throw_container_exception('factory for "${id}" must be callable')
		return &c
	}
	c.factories[id] = vphp.PersistentOwnedZVal.from_zval(callable)
	c.entries.delete(id)
	c.resolved.delete(id)
	return &c
}

@[php_method]
pub fn (c &VSlimContainer) has(id string) bool {
	return id in c.entries || id in c.factories || id in c.resolved
}

// `get()` is wired via a custom bridge export so we can return mixed zval values safely.
@[php_method]
@[export: 'manual']
pub fn (c &VSlimContainer) get(id string) {}

fn (mut c VSlimContainer) get_entry(id string) !vphp.ZVal {
	if id in c.resolved {
		return c.resolved[id].clone_request_owned().to_zval()
	}
	if id in c.entries {
		return c.entries[id].clone_request_owned().to_zval()
	}
	if id in c.factories {
		factory := c.factories[id].to_zval()
		res := factory.call_owned_request([])
		if !res.is_valid() {
			return error('factory "${id}" returned invalid value')
		}
		c.resolved[id] = vphp.PersistentOwnedZVal.from_zval(res)
		return res
	}
	return error('entry "${id}" not found')
}

@[export: 'VSlimContainer_get']
pub fn vslimcontainer_get(ptr voidptr, ctx vphp.Context) {
	mut recv := unsafe { &VSlimContainer(ptr) }
	id := ctx.arg[string](0)
	res := recv.get_entry(id) or {
		if err.msg().contains('not found') {
			throw_not_found(id)
		} else {
			throw_container_exception(err.msg())
		}
		return
	}
	ctx.return_zval(res)
}

fn throw_not_found(id string) {
	vphp.throw_exception_class('VSlim\\Container\\NotFoundException',
		'Container entry "${id}" not found', 0)
}

fn throw_container_exception(msg string) {
	vphp.throw_exception_class('VSlim\\Container\\ContainerException', msg, 0)
}

fn (mut c VSlimContainer) free() {
	for _, entry in c.entries {
		mut z := entry
		z.release()
	}
	for _, factory in c.factories {
		mut z := factory
		z.release()
	}
	for _, resolved in c.resolved {
		mut z := resolved
		z.release()
	}
	unsafe {
		c.entries.free()
		c.factories.free()
		c.resolved.free()
	}
}
