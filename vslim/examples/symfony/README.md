# Symfony Example

## 1) 安装依赖

```bash
cd /Users/guweigang/Source/vphpext/vslim/examples/symfony
composer install
```

## 2) 启动服务

```bash
cd /Users/guweigang/Source/vphpext/vslim
VSLIM_HTTPD_APP=/Users/guweigang/Source/vphpext/vslim/examples/symfony/app.php make serve
```

## 3) 验证

```bash
curl --noproxy '*' -i "http://127.0.0.1:19881/symfony/hello/nova"
curl --noproxy '*' -i "http://127.0.0.1:19881/symfony/meta?trace_id=demo"
```

预期:

- `/symfony/hello/nova` -> `200`，header 有 `x-framework: symfony`，body 为 `symfony:nova`
- `/symfony/meta?...` -> `200`，返回 JSON，含 `framework: symfony`
