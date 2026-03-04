module main

@[php_trait]
struct SlugTrait {
pub mut:
	slug   string
	visits int
}

@[php_method]
pub fn (s &SlugTrait) trait_only() string {
	return 'trait:' + s.slug
}

@[php_method]
pub fn (s &SlugTrait) summary() string {
	return 'trait-summary'
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
