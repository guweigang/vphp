# WordPress Example

这个示例用于演示：`vhttpd -> php-worker -> WordPress runtime`。

## 前置条件

1. 你本机有一个可用的 WordPress 站点目录（含 `wp-load.php`）
2. 该站点能在 CLI 下正常加载（数据库配置可用）

## 1) 启动服务

```bash
cd /Users/guweigang/Source/vphpext/vslim
VSLIM_WP_ROOT=/abs/path/to/wordpress \
VSLIM_HTTPD_APP=/Users/guweigang/Source/vphpext/vslim/examples/wordpress/app.php \
make serve
```

或者一键 demo：

```bash
VSLIM_WP_ROOT=/abs/path/to/wordpress \
make -C /Users/guweigang/Source/vphpext/vslim demo-wordpress
```

## 2) 验证

```bash
curl --noproxy '*' -i "http://127.0.0.1:19881/wordpress/meta?trace_id=demo"
curl --noproxy '*' -i "http://127.0.0.1:19881/wordpress/post/1"
```

预期：

- header 含 `x-framework: wordpress`
- `/wordpress/meta` 返回站点基础信息
- `/wordpress/post/{id}` 返回文章摘要（不存在则 `404`）
