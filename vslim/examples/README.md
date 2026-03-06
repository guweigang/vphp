# VSlim Examples

## TOML 一键启动（推荐）

先编译：

```bash
cd /Users/guweigang/Source/vphpext/vslim
make build vhttpd
```

然后直接：

```bash
./httpd/vhttpd --config /Users/guweigang/Source/vphpext/vslim/examples/config/hello.toml
```

已提供配置：

- `/Users/guweigang/Source/vphpext/vslim/examples/config/hello.toml`
- `/Users/guweigang/Source/vphpext/vslim/examples/config/ai-stream.toml`
- `/Users/guweigang/Source/vphpext/vslim/examples/config/stream-bench.toml`
- `/Users/guweigang/Source/vphpext/vslim/examples/config/ollama-proxy.toml`
- `/Users/guweigang/Source/vphpext/vslim/examples/config/symfony.toml`
- `/Users/guweigang/Source/vphpext/vslim/examples/config/laravel.toml`
- `/Users/guweigang/Source/vphpext/vslim/examples/config/wordpress.toml`

说明：

- `symfony.toml` / `laravel.toml` 需要先安装各自 `vendor` 依赖
- `wordpress.toml` 需要把 `VSLIM_WP_ROOT=/ABS/PATH/TO/WORDPRESS` 改成真实路径
- `ollama-proxy.toml` 里 `OLLAMA_CHAT_URL / OLLAMA_MODEL / OLLAMA_API_KEY` 可按需改

## 快速开始（VSlim 原生）

```bash
cd /Users/guweigang/Source/vphpext/vslim
VSLIM_HTTPD_APP=/Users/guweigang/Source/vphpext/vslim/examples/hello-app.php make serve
```

```bash
curl --noproxy '*' -i http://127.0.0.1:19881/hello/codex
curl --noproxy '*' -i http://127.0.0.1:19881/go/nova
curl --noproxy '*' -i -H 'Host: demo.local' http://127.0.0.1:19881/api/meta
```

一键演示（自动启动并发请求）：

```bash
make -C /Users/guweigang/Source/vphpext/vslim demo-vslim
```

## AI Token Streaming 示例

使用内置的流式 demo app：

```bash
cd /Users/guweigang/Source/vphpext/vslim
VSLIM_HTTPD_APP=/Users/guweigang/Source/vphpext/vslim/examples/ai-stream-app.php make serve
```

验证 text passthrough：

```bash
curl --noproxy '*' -N "http://127.0.0.1:19881/ai/stream?prompt=hello"
```

验证 SSE：

```bash
curl --noproxy '*' -N "http://127.0.0.1:19881/ai/sse?prompt=hello"
```

一键演示：

```bash
make -C /Users/guweigang/Source/vphpext/vslim demo-ai
```

## Ollama Cloud/Local Proxy 示例

用 PHP worker 作为 client 请求 Ollama 流，再转成 vhttpd 流：

```bash
cd /Users/guweigang/Source/vphpext/vslim
VSLIM_HTTPD_APP=/Users/guweigang/Source/vphpext/vslim/examples/ollama-proxy-app.php \
OLLAMA_CHAT_URL=https://<your-ollama-endpoint>/api/chat \
OLLAMA_MODEL=qwen2.5:7b-instruct \
OLLAMA_API_KEY=<your-token> \
make serve
```

text passthrough:

```bash
curl --noproxy '*' -N "http://127.0.0.1:19881/ollama/text?prompt=hello"
```

SSE:

```bash
curl --noproxy '*' -N "http://127.0.0.1:19881/ollama/sse?prompt=hello"
```

## Framework 示例（可独立进入目录运行）

- Symfony:
  - [examples/symfony/README.md](/Users/guweigang/Source/vphpext/vslim/examples/symfony/README.md)
  - 文件: [examples/symfony/composer.json](/Users/guweigang/Source/vphpext/vslim/examples/symfony/composer.json), [examples/symfony/app.php](/Users/guweigang/Source/vphpext/vslim/examples/symfony/app.php)
- Laravel:
  - [examples/laravel/README.md](/Users/guweigang/Source/vphpext/vslim/examples/laravel/README.md)
  - 文件: [examples/laravel/composer.json](/Users/guweigang/Source/vphpext/vslim/examples/laravel/composer.json), [examples/laravel/app.php](/Users/guweigang/Source/vphpext/vslim/examples/laravel/app.php)
- WordPress:
  - [examples/wordpress/README.md](/Users/guweigang/Source/vphpext/vslim/examples/wordpress/README.md)
  - 文件: [examples/wordpress/app.php](/Users/guweigang/Source/vphpext/vslim/examples/wordpress/app.php)

一键演示：

```bash
make -C /Users/guweigang/Source/vphpext/vslim demo-symfony
make -C /Users/guweigang/Source/vphpext/vslim demo-laravel
VSLIM_WP_ROOT=/abs/path/to/wordpress make -C /Users/guweigang/Source/vphpext/vslim demo-wordpress
```
