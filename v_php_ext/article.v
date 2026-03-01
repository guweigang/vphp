module main

import vphp

@[heap]
@[php_class]
struct Author {
pub mut:
    name string
}

@[php_method]
pub fn Author.create(name string) &Author {
    mut a := &Author{
        name: name.clone()
    }
    return a
}

@[php_method]
pub fn (p &Author) get_name() string {
    return p.name
}

@[heap]
@[php_class]
struct Post {
pub mut:
    post_id int
    author  &Author = unsafe { nil }
}

@[php_method]
pub fn (mut p Post) set_author(author &Author) {
    // println('V: Post.set_author called on ptr=${ptr_str(p)} with author_ptr=${ptr_str(author)}')
    p.author = author
}

@[php_method]
pub fn (p &Post) get_author() &Author {
    // println('V: Post.get_author called on ptr=${ptr_str(p)}')
    // println('V: Post.get_author returning author_ptr=${ptr_str(p.author)}')
    return p.author
}

struct ArticleConsts {
    max_title_len int
    name          string
    age           int
}

const article_consts = ArticleConsts{
    max_title_len: 1024
    name: 'Samantha Black'
    age: 24
}

article_statics := struct {
    total_count int = 0
}

@[heap]
@[php_class]
@[php_extends: 'Post']
@[php_const: article_consts]
@[php_static: article_statics]
struct Article {
	Post
pub:
    created_at    int   //  public readonly
pub mut:
	id            int    // public
	title         string // public
	is_top        bool   // public

mut:
	content       string // protected
	total_count   int    // @[php_static] protected static
}

@[php_method]
pub fn (mut a Article) init(title string, id int) &Article {
    a.title = title.clone()
    a.id = id
    a.is_top = true
    a.content = 'Default Content'.clone()
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
        title: title.clone()
        is_top: true
        content: 'Created via static'.clone()
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
    return true
}

@[php_method]
pub fn (a &Article) dump_properties(data vphp.Val) {
    if data.is_array() || data.is_object() {
        data.foreach(fn (key vphp.Val, val vphp.Val) {
            println('V Foreach -> Key: ${key.to_string()}, Value Type: ${val.type_name()}')
            if val.is_string() {
                println('             Value: ${val.to_string()}')
            }
        })
    } else {
        println('V Foreach -> Data is not iterable')
    }
}

@[php_method]
pub fn (a &Article) process_with_callback(callback vphp.Val) bool {
    if !callback.is_callable() {
        println('V process_with_callback -> Argument is not callable!')
        return false
    }
    
    // Call the PHP closure with a parameter
    mut args := []vphp.Val{}
    args << vphp.new_val_string('Calling from V')
    
    res := callback.invoke(args)
    if res.raw == 0 {
        return false
    }
    return res.type_id() == int(vphp.PHPType.true_) || (res.is_numeric() && res.to_int() != 0)
}

@[php_method]
pub fn Article.restore_author(author_val vphp.Val) &Author {
    mut author := author_val.to_object[Author]() or {
        println('V restore_author -> Failed to convert to Author')
        return &Author{ name: 'Unknown' }
    }
    println('V restore_author -> Successfully restored Author: ${author.name}')
    return author
}

// === 新增 Story 类：通过 Embed 自动识别 php_extends: 'Post' ===
@[heap]
@[php_class]
struct Story {
    Post	// PHP 自动识别为继承
pub mut:
    chapter_count int
}

@[php_method]
pub fn Story.create(author &Author, chapters int) &Story {
    mut s := &Story{
        chapter_count: chapters
        author: author
    }
    return s
}

@[php_method]
pub fn (s &Story) tell() string {
    return 'Author ${s.author.name} is telling a story with ${s.chapter_count} chapters.'
}
