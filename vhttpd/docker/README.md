# vhttpd Docker Usage

## Build image

```bash
cd /Users/guweigang/Source/vphpext

docker build -t vhttpd-dev:latest -f /Users/guweigang/Source/vphpext/vhttpd/docker/Dockerfile .
```

## Run hello config

```bash
docker run --rm -p 19881:19881 -p 19981:19981 \
  vhttpd-dev:latest \
  --config /app/vhttpd/docker/config/hello.toml
```

## Run laravel config (4 workers)

```bash
docker run --rm -p 19886:19886 -p 19986:19986 \
  vhttpd-dev:latest \
  --config /app/vhttpd/docker/config/laravel.toml
```

## One-command helper

```bash
bash /Users/guweigang/Source/vphpext/vhttpd/docker/run.sh --config /app/vhttpd/docker/config/hello.toml
```

Run wrapper as command:

```bash
/Users/guweigang/Source/vphpext/vhttpd/docker/vhttpd --config /app/vhttpd/docker/config/laravel.toml
```

Optional port mapping overrides for helper/wrapper:

```bash
VHTTPD_DOCKER_PORT_MAP=19886:19886 \
VHTTPD_DOCKER_ADMIN_PORT_MAP=19986:19986 \
  bash /Users/guweigang/Source/vphpext/vhttpd/docker/run.sh --config /app/vhttpd/docker/config/laravel.toml
```
