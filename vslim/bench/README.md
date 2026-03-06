# k6 Benchmarks

## Variable convention

Primary variables now use `VHTTPD_*` prefix. Legacy names are still accepted for compatibility.

- `VHTTPD_BASE_URL` (legacy: `BASE_URL`)
- `VHTTPD_BENCH_PATH` (legacy: `PATH_UNDER_TEST`)
- `VHTTPD_STREAM_PATH` (legacy: `STREAM_PATH`)
- `VHTTPD_STREAM_MODE` (legacy: `STREAM_MODE`)
- `VHTTPD_WORKER_POOL_SIZE` (legacy: `POOL_SIZE`)
- `VHTTPD_BENCH_RUN_K6` (legacy: `RUN_K6`)
- `VHTTPD_APP_BOOTSTRAP` (legacy in script: `APP_BOOTSTRAP`)
- `VHTTPD_HOST`, `VHTTPD_PORT` (legacy: `HOST`, `PORT`)

## Prerequisite

Install k6:

```bash
brew install k6
```

## 0) One-command host regression

This script runs an end-to-end host check:

- build `vhttpd`
- start `vhttpd` with managed worker pool (`POOL_SIZE`, default `4`)
- run short + stream k6 benchmarks
- send `SIGINT` to `vhttpd`
- verify no `php-worker.php` process is left for this run

Run:

```bash
bash /Users/guweigang/Source/vphpext/vslim/bench/run_host_regression.sh
```

Tune:

```bash
PORT=19882 POOL_SIZE=6 bash /Users/guweigang/Source/vphpext/vslim/bench/run_host_regression.sh
```

Skip k6 and only verify lifecycle:

```bash
RUN_K6=0 bash /Users/guweigang/Source/vphpext/vslim/bench/run_host_regression.sh
```

Using unified names:

```bash
VHTTPD_PORT=19882 VHTTPD_WORKER_POOL_SIZE=6 bash /Users/guweigang/Source/vphpext/vslim/bench/run_host_regression.sh
VHTTPD_BENCH_RUN_K6=0 bash /Users/guweigang/Source/vphpext/vslim/bench/run_host_regression.sh
```

## 1) Short request benchmark

Default target:

- `VHTTPD_BASE_URL=http://127.0.0.1:19881`
- `VHTTPD_BENCH_PATH=/laravel/hello/guweigang`

Run:

```bash
k6 run /Users/guweigang/Source/vphpext/vslim/bench/k6_short.js
```

Custom path:

```bash
VHTTPD_BASE_URL=http://127.0.0.1:19881 VHTTPD_BENCH_PATH=/health \
k6 run /Users/guweigang/Source/vphpext/vslim/bench/k6_short.js
```

## 2) Stream benchmark (SSE/text)

Before running stream benchmark, start `vhttpd` with deterministic benchmark app:

```bash
cd /Users/guweigang/Source/vphpext/vslim
VSLIM_HTTPD_APP=/Users/guweigang/Source/vphpext/vslim/examples/stream-bench-app.php make serve
```

SSE default:

```bash
VHTTPD_BASE_URL=http://127.0.0.1:19881 VHTTPD_STREAM_MODE=sse VHTTPD_STREAM_PATH='/bench/stream?mode=sse&tokens=80&interval_ms=5&chunk_size=24' \
k6 run /Users/guweigang/Source/vphpext/vslim/bench/k6_stream.js
```

Text stream:

```bash
VHTTPD_BASE_URL=http://127.0.0.1:19881 VHTTPD_STREAM_MODE=text VHTTPD_STREAM_PATH='/bench/stream?mode=text&tokens=80&interval_ms=5&chunk_size=24' \
k6 run /Users/guweigang/Source/vphpext/vslim/bench/k6_stream.js
```

## Recommended comparison matrix

Use these two groups for reproducible stream transport benchmarks.

### Group A: transport overhead (fixed tokens, vary interval)

SSE:

```bash
for i in 0 1 5; do
  echo "=== SSE interval_ms=$i ==="
  VHTTPD_BASE_URL=http://127.0.0.1:19881 VHTTPD_STREAM_MODE=sse \
  VHTTPD_STREAM_PATH="/bench/stream?mode=sse&tokens=80&interval_ms=$i&chunk_size=24" \
  k6 run /Users/guweigang/Source/vphpext/vslim/bench/k6_stream.js
done
```

Text:

```bash
for i in 0 1 5; do
  echo "=== TEXT interval_ms=$i ==="
  VHTTPD_BASE_URL=http://127.0.0.1:19881 VHTTPD_STREAM_MODE=text \
  VHTTPD_STREAM_PATH="/bench/stream?mode=text&tokens=80&interval_ms=$i&chunk_size=24" \
  k6 run /Users/guweigang/Source/vphpext/vslim/bench/k6_stream.js
done
```

### Group B: scalability (fixed interval, vary tokens)

SSE:

```bash
for t in 40 80 160; do
  echo "=== SSE tokens=$t ==="
  VHTTPD_BASE_URL=http://127.0.0.1:19881 VHTTPD_STREAM_MODE=sse \
  VHTTPD_STREAM_PATH="/bench/stream?mode=sse&tokens=$t&interval_ms=5&chunk_size=24" \
  k6 run /Users/guweigang/Source/vphpext/vslim/bench/k6_stream.js
done
```

Text:

```bash
for t in 40 80 160; do
  echo "=== TEXT tokens=$t ==="
  VHTTPD_BASE_URL=http://127.0.0.1:19881 VHTTPD_STREAM_MODE=text \
  VHTTPD_STREAM_PATH="/bench/stream?mode=text&tokens=$t&interval_ms=5&chunk_size=24" \
  k6 run /Users/guweigang/Source/vphpext/vslim/bench/k6_stream.js
done
```

Tip:

- Group A helps isolate runtime/transport overhead.
- Group B helps verify near-linear growth with stream length.
