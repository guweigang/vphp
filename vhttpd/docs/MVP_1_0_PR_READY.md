# vhttpd MVP 1.0 PR Ready Checklist

## Scope

This checklist is for final MVP 1.0 release readiness of `vhttpd`.

## 1. Build

```bash
make -C /Users/guweigang/Source/vphpext/vhttpd vhttpd
```

Expected:
- binary exists at `/Users/guweigang/Source/vphpext/vhttpd/vhttpd`
- `./vhttpd --help` prints usage and exits

## 2. Config startup (TOML)

```bash
/Users/guweigang/Source/vphpext/vhttpd/vhttpd \
  --config /Users/guweigang/Source/vphpext/vhttpd/examples/config/laravel.toml
```

Expected:
- data plane reachable (`/laravel/meta`)
- admin plane reachable (`/admin/workers`, `/admin/stats`)

## 3. Data/Admin split

When admin is enabled on dedicated port:
- data plane `/admin/*` should return 404
- admin plane should return 200 with valid token (if configured)

Verify:

```bash
curl --noproxy '*' -i http://127.0.0.1:19886/admin/workers
curl --noproxy '*' -i -H 'x-vhttpd-admin-token: <token>' http://127.0.0.1:19986/admin/workers
```

## 4. Worker counters

Drive requests then check runtime counters:

```bash
seq 50 | xargs -I{} -P4 curl --noproxy '*' -s -o /dev/null \
  'http://127.0.0.1:19886/laravel/hello/guweigang'

curl --noproxy '*' -s http://127.0.0.1:19986/admin/workers | jq .workers
```

Expected:
- at least one worker has `served_requests > 0`
- no worker stuck with high `inflight_requests`

## 5. Restart APIs

```bash
curl --noproxy '*' -s -X POST \
  'http://127.0.0.1:19986/admin/workers/restart?id=1' | jq .

curl --noproxy '*' -s -X POST \
  'http://127.0.0.1:19986/admin/workers/restart/all' | jq .
```

Expected:
- both return `ok: true`
- workers come back alive

## 6. Graceful stop

Stop `vhttpd` via `Ctrl+C`, then verify worker cleanup.

```bash
pgrep -fal 'php-worker.php|vhttpd'
```

Expected:
- no orphan `php-worker.php` process remains

## 7. Benchmark smoke

```bash
bash /Users/guweigang/Source/vphpext/vhttpd/bench/run_host_regression.sh
```

Expected:
- short request benchmark passes thresholds
- stream benchmark passes thresholds

## 8. CI binary workflow

Workflow file:
- `.github/workflows/vhttpd-binaries.yml`

Expected:
- `linux-amd64`, `macos-amd64`, `macos-arm64` artifacts produced
- tag builds publish release assets with `SHA256SUMS.txt`

## 9. Known non-goals (MVP)

- no built-in DB gateway server in `vhttpd` yet (only PHP client API prototype exists)
- no dynamic scale in/out orchestration (external process manager responsibility)
