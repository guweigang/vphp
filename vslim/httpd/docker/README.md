# vhttpd Docker Usage

## Build image

```bash
cd /Users/guweigang/Source/vphpext

docker build -t vhttpd-dev:latest -f /Users/guweigang/Source/vphpext/vslim/httpd/docker/Dockerfile .
```

## Run hello config

```bash
docker run --rm -p 19881:19881 -p 19981:19981 \
  vhttpd-dev:latest \
  /app/vslim/httpd/vhttpd --config /app/vslim/httpd/docker/config/hello.toml
```

## Run laravel config (4 workers)

```bash
docker run --rm -p 19886:19886 -p 19986:19986 \
  vhttpd-dev:latest \
  /app/vslim/httpd/vhttpd --config /app/vslim/httpd/docker/config/laravel.toml
```

## One-command helper

```bash
bash /Users/guweigang/Source/vphpext/vslim/httpd/docker/run.sh
```

Override config in helper:

```bash
VHTTPD_CONFIG_IN_CONTAINER=/app/vslim/httpd/docker/config/laravel.toml \
  bash /Users/guweigang/Source/vphpext/vslim/httpd/docker/run.sh
```
