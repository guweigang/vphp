struct Post {
pub mut:
    post_id int
    author voidptr
}
struct Article {
    Post
pub mut:
    title string
}
fn main() {
    mut a := &Article{title: "hello"}
    mut p := unsafe { &Post(voidptr(a)) }
    p.author = voidptr(0x123)
    println("p.author = ${p.author}, a.author = ${a.author}")
}
