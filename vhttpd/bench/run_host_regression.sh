#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VSLIM_ROOT="${VSLIM_ROOT:-$(cd "${ROOT_DIR}/../vslim" && pwd)}"
BENCH_DIR="$ROOT_DIR/bench"
HTTPD_BIN="$ROOT_DIR/vhttpd"
WORKER_PHP="$ROOT_DIR/php/php-worker.php"
VSLIM_SO="$VSLIM_ROOT/vslim.so"
APP_BOOTSTRAP_DEFAULT="$ROOT_DIR/examples/stream-bench-app.php"

HOST="${VHTTPD_HOST:-${HOST:-127.0.0.1}}"
PORT="${VHTTPD_PORT:-${PORT:-19881}}"
POOL_SIZE="${VHTTPD_WORKER_POOL_SIZE:-${POOL_SIZE:-4}}"
RUN_K6="${VHTTPD_BENCH_RUN_K6:-${RUN_K6:-1}}"
BUILD_FIRST="${VHTTPD_BENCH_BUILD_FIRST:-${BUILD_FIRST:-1}}"

if [[ ! -x "$HTTPD_BIN" || "$BUILD_FIRST" == "1" ]]; then
  echo "[1/6] building vhttpd"
  make -C "$ROOT_DIR" vhttpd >/dev/null
  make -C "$VSLIM_ROOT" build >/dev/null
fi

if [[ "$RUN_K6" == "1" ]] && ! command -v k6 >/dev/null 2>&1; then
  echo "k6 is required (brew install k6), or run with RUN_K6=0"
  exit 1
fi

tmp_dir="$(mktemp -d /tmp/vhttpd_host_reg_XXXXXX)"
pid_file="$tmp_dir/vhttpd.pid"
event_log="$tmp_dir/events.ndjson"
stdout_log="$tmp_dir/stdout.log"
worker_socket_prefix="$tmp_dir/worker"
app_bootstrap="${VHTTPD_APP_BOOTSTRAP:-${APP_BOOTSTRAP:-$APP_BOOTSTRAP_DEFAULT}}"

q() {
  printf '%q' "$1"
}

worker_cmd="VSLIM_HTTPD_APP=$(q "$app_bootstrap") php -d extension=$(q "$VSLIM_SO") $(q "$WORKER_PHP") --socket {socket}"

server_pid=""

cleanup() {
  set +e
  if [[ -n "${server_pid}" ]] && kill -0 "$server_pid" >/dev/null 2>&1; then
    kill -INT "$server_pid" >/dev/null 2>&1 || true
    sleep 1
    kill -TERM "$server_pid" >/dev/null 2>&1 || true
    sleep 1
    kill -KILL "$server_pid" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

echo "[2/6] starting vhttpd host=$HOST port=$PORT pool=$POOL_SIZE"
"$HTTPD_BIN" \
  --host "$HOST" \
  --port "$PORT" \
  --pid-file "$pid_file" \
  --event-log "$event_log" \
  --worker-autostart 1 \
  --worker-pool-size "$POOL_SIZE" \
  --worker-socket-prefix "$worker_socket_prefix" \
  --worker-cmd "$worker_cmd" \
  >>"$stdout_log" 2>&1 &
server_pid=$!

base_url="http://$HOST:$PORT"
health_url="$base_url/bench/health"

echo "[3/6] waiting for health: $health_url"
ready=0
for _ in $(seq 1 100); do
  if curl --noproxy '*' -fsS "$health_url" >/dev/null 2>&1; then
    ready=1
    break
  fi
  sleep 0.1
done
if [[ "$ready" != "1" ]]; then
  echo "server not ready, logs: $stdout_log"
  tail -n 80 "$stdout_log" || true
  if grep -q 'worker_start_failed' "$stdout_log" 2>/dev/null; then
    echo "hint: check whether current runtime allows Unix domain sockets and verify worker command paths."
  fi
  exit 1
fi

if [[ "$RUN_K6" == "1" ]]; then
  echo "[4/6] running short benchmark"
  VHTTPD_BASE_URL="$base_url" VHTTPD_BENCH_PATH='/bench/health' \
    k6 run "$BENCH_DIR/k6_short.js"

  echo "[5/6] running stream benchmark"
  VHTTPD_BASE_URL="$base_url" VHTTPD_STREAM_MODE='sse' \
  VHTTPD_STREAM_PATH='/bench/stream?mode=sse&tokens=80&interval_ms=5&chunk_size=24' \
    k6 run "$BENCH_DIR/k6_stream.js"
else
  echo "[4/6] RUN_K6=0, skipping k6 benchmarks"
  echo "[5/6] RUN_K6=0, skipping k6 benchmarks"
fi

echo "[6/6] sending SIGINT and verifying worker cleanup"
kill -INT "$server_pid" >/dev/null 2>&1 || true

stopped=0
for _ in $(seq 1 30); do
  if ! kill -0 "$server_pid" >/dev/null 2>&1; then
    stopped=1
    break
  fi
  sleep 0.2
done

if [[ "$stopped" != "1" ]]; then
  echo "vhttpd did not stop in time (pid=$server_pid)"
  exit 1
fi

if pgrep -f "php-worker.php --socket ${worker_socket_prefix}_" >/dev/null 2>&1; then
  echo "worker leak detected for prefix ${worker_socket_prefix}_"
  pgrep -af "php-worker.php --socket ${worker_socket_prefix}_" || true
  exit 1
fi

echo "ok: vhttpd exited and no worker leak detected"
echo "event_log=$event_log"
echo "stdout_log=$stdout_log"
