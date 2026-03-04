module main

@[php_trait]
struct SlugTrait {
pub mut:
	slug   string
	visits int
mut:
	internal_note string
}

@[php_method]
pub fn (s &SlugTrait) trait_only() string {
	return 'trait:' + s.slug
}

@[php_method]
pub fn (s &SlugTrait) summary() string {
	return 'trait-summary'
}

@[php_method]
fn (s &SlugTrait) internal_trait() string {
	return 'hidden:' + s.internal_note
}

@[heap]
@[php_class]
struct TraitPost {
	SlugTrait
pub mut:
	title string
}

@[php_method]
pub fn (mut p TraitPost) construct(title string) &TraitPost {
	p.title = title
	p.slug = 'from-trait'
	p.visits = 1
	p.internal_note = 'secret'
	return p
}

@[php_method]
pub fn (p &TraitPost) summary() string {
	return 'class:' + p.title
}

@[php_method]
pub fn (mut p TraitPost) bump() int {
	p.visits++
	return p.visits
}
