# Laravel Example

## 1) 安装依赖

```bash
cd /Users/guweigang/Source/vphpext/vhttpd/examples/laravel
composer install
```

## 2) 启动服务

```bash
cd /Users/guweigang/Source/vphpext/vslim
VSLIM_HTTPD_APP=/Users/guweigang/Source/vphpext/vhttpd/examples/laravel/app.php make serve
```

## 3) 验证

```bash
curl --noproxy '*' -i "http://127.0.0.1:19881/laravel/hello/nova"
curl --noproxy '*' -i "http://127.0.0.1:19881/laravel/meta?trace_id=demo"
```

预期:

- `/laravel/hello/nova` -> `200`，header 有 `x-framework: laravel`，body 为 `laravel:nova`
- `/laravel/meta?...` -> `200`，返回 JSON，含 `framework: laravel`
