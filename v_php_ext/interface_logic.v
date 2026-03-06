module main

@[php_interface]
interface ContentContract {
	save() bool
	get_formatted_title() string
}

@[php_interface: 'Demo\\Contracts\\AliasContract']
interface AliasContract {
	ping() string
}

@[heap]
@[php_class: 'Demo\\Contracts\\AliasBase']
struct AliasBase {
pub mut:
	label string
}

@[php_method]
pub fn (mut b AliasBase) construct(label string) &AliasBase {
	b.label = label
	return b
}

@[heap]
@[php_class]
@[php_extends: 'AliasBase']
@[php_implements: 'Demo\\Contracts\\AliasContract']
struct AliasWorker implements ContentContract {
	AliasBase
pub mut:
	title string
}

@[php_method]
pub fn (mut a AliasWorker) construct(label string, title string) &AliasWorker {
	a.label = label
	a.title = title
	return a
}

@[php_method]
pub fn (a &AliasWorker) save() bool {
	return true
}

@[php_method]
pub fn (a &AliasWorker) get_formatted_title() string {
	return a.label + ':' + a.title
}

@[php_method]
pub fn (a &AliasWorker) ping() string {
	return a.label + ':' + a.title
}
