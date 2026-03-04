module main

@[heap]
@[php_class]
struct StringableBox {
pub mut:
	name string
}

@[php_method]
pub fn (mut b StringableBox) construct(name string) &StringableBox {
	b.name = name
	return b
}

@[php_method]
pub fn (b &StringableBox) str() string {
	return 'box:${b.name}'
}
