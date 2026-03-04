module main

@[heap]
@[php_class]
struct ReadonlyRecord {
pub:
	created_at int = 42
pub mut:
	title string
mut:
	internal_note string
}

@[php_method]
pub fn (mut r ReadonlyRecord) construct(title string) &ReadonlyRecord {
	r.title = title
	r.internal_note = 'sealed'
	return r
}

@[php_method]
pub fn (r &ReadonlyRecord) reveal() string {
	return '${r.title}:${r.created_at}'
}
