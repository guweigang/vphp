# k6 Benchmarks

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

## 1) Short request benchmark

Default target:

- `BASE_URL=http://127.0.0.1:19881`
- `PATH_UNDER_TEST=/laravel/hello/guweigang`

Run:

```bash
k6 run /Users/guweigang/Source/vphpext/vslim/bench/k6_short.js
```

Custom path:

```bash
BASE_URL=http://127.0.0.1:19881 PATH_UNDER_TEST=/health \
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
BASE_URL=http://127.0.0.1:19881 STREAM_MODE=sse STREAM_PATH='/bench/stream?mode=sse&tokens=80&interval_ms=5&chunk_size=24' \
k6 run /Users/guweigang/Source/vphpext/vslim/bench/k6_stream.js
```

Text stream:

```bash
BASE_URL=http://127.0.0.1:19881 STREAM_MODE=text STREAM_PATH='/bench/stream?mode=text&tokens=80&interval_ms=5&chunk_size=24' \
k6 run /Users/guweigang/Source/vphpext/vslim/bench/k6_stream.js
```

## Recommended comparison matrix

Use these two groups for reproducible stream transport benchmarks.

### Group A: transport overhead (fixed tokens, vary interval)

SSE:

```bash
for i in 0 1 5; do
  echo "=== SSE interval_ms=$i ==="
  BASE_URL=http://127.0.0.1:19881 STREAM_MODE=sse \
  STREAM_PATH="/bench/stream?mode=sse&tokens=80&interval_ms=$i&chunk_size=24" \
  k6 run /Users/guweigang/Source/vphpext/vslim/bench/k6_stream.js
done
```

Text:

```bash
for i in 0 1 5; do
  echo "=== TEXT interval_ms=$i ==="
  BASE_URL=http://127.0.0.1:19881 STREAM_MODE=text \
  STREAM_PATH="/bench/stream?mode=text&tokens=80&interval_ms=$i&chunk_size=24" \
  k6 run /Users/guweigang/Source/vphpext/vslim/bench/k6_stream.js
done
```

### Group B: scalability (fixed interval, vary tokens)

SSE:

```bash
for t in 40 80 160; do
  echo "=== SSE tokens=$t ==="
  BASE_URL=http://127.0.0.1:19881 STREAM_MODE=sse \
  STREAM_PATH="/bench/stream?mode=sse&tokens=$t&interval_ms=5&chunk_size=24" \
  k6 run /Users/guweigang/Source/vphpext/vslim/bench/k6_stream.js
done
```

Text:

```bash
for t in 40 80 160; do
  echo "=== TEXT tokens=$t ==="
  BASE_URL=http://127.0.0.1:19881 STREAM_MODE=text \
  STREAM_PATH="/bench/stream?mode=text&tokens=$t&interval_ms=5&chunk_size=24" \
  k6 run /Users/guweigang/Source/vphpext/vslim/bench/k6_stream.js
done
```

Tip:

- Group A helps isolate runtime/transport overhead.
- Group B helps verify near-linear growth with stream length.
