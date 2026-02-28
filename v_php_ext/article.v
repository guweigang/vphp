module main

@[php_class]
struct Post {
pub mut:
    post_id int
    author  string
}

@[php_method]
pub fn (mut p Post) set_author(name string) {
    p.author = name
}

@[php_method]
pub fn (p &Post) get_author() string {
    return p.author
}

@[php_class]
@[php_extends: 'Post']
struct Article {
	Post
pub mut:
	id            int    // public
	title         string // public
	is_top        bool   // public
	max_title_len int    // @[php_static] public static

mut:
	content       string // protected
	total_count   int    // @[php_static] protected static
}

@[php_method]
pub fn (mut a Article) init(title string, id int) &Article {
    a.title = title
    a.id = id
    a.is_top = true
    a.content = 'Default Content'
    println('V Article initialized with title: ${a.title}')
    return a
}

// 动态方法（受保护）：前面没有 pub 关键字，将被自动映射为 PHP 的 protected
@[php_method]
fn (a &Article) internal_format() string {
    return '[Protected] ' + a.title
}

// 静态公开方法：V中没有接收者
@[php_method]
pub fn Article.create(title string) &Article {
    mut a := &Article{
        id: 1024
        title: title
        is_top: true
        content: 'Created via static'
    }
    return a
}

@[php_method]
pub fn (a &Article) get_formatted_title() string {
    // 内部类方法可以调用内部的其它方法或访问属性
    return a.internal_format()
}

@[php_method]
pub fn (a &Article) save() bool {
    println('Saving article: $a.title')
    return true
}

// === 新增 Story 类：通过 Embed 自动识别 php_extends: 'Post' ===
@[php_class]
struct Story {
    Post
pub mut:
    chapter_count int
}

@[php_method]
pub fn Story.create(author string, chapters int) &Story {
    mut s := &Story{
        chapter_count: chapters
    }
    s.author = author
    return s
}

@[php_method]
pub fn (s &Story) tell() string {
    return 'Author ${s.author} is telling a story with ${s.chapter_count} chapters.'
}
