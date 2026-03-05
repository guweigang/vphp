#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CASE="${1:-vslim}"
HOST="${VHTTPD_HOST:-127.0.0.1}"
PORT="${VHTTPD_PORT:-19881}"
SOCKET="/tmp/vslim_demo_${CASE}.sock"
PID_FILE="/tmp/vslim_demo_${CASE}.pid"
EVENT_LOG="/tmp/vslim_demo_${CASE}.events.ndjson"
STDOUT_LOG="/tmp/vslim_demo_${CASE}.stdout.log"

APP_PATH=""
WORKER_ENV=""
declare -a URLS=()

case "${CASE}" in
  vslim)
    APP_PATH="${ROOT}/examples/hello-app.php"
    URLS=(
      "http://${HOST}:${PORT}/hello/codex"
      "http://${HOST}:${PORT}/go/nova"
      "http://${HOST}:${PORT}/api/meta"
    )
    ;;
  ai)
    APP_PATH="${ROOT}/examples/ai-stream-app.php"
    URLS=(
      "http://${HOST}:${PORT}/ai/stream?prompt=hello-from-demo"
      "http://${HOST}:${PORT}/ai/sse?prompt=hello-from-demo"
    )
    ;;
  symfony)
    APP_PATH="${ROOT}/examples/symfony/app.php"
    if [ ! -f "${ROOT}/examples/symfony/vendor/autoload.php" ]; then
      echo "[demo] symfony dependencies missing"
      echo "run: cd ${ROOT}/examples/symfony && /Users/guweigang/bin/composer install"
      exit 2
    fi
    URLS=(
      "http://${HOST}:${PORT}/symfony/hello/nova"
      "http://${HOST}:${PORT}/symfony/meta?trace_id=demo"
    )
    ;;
  laravel)
    APP_PATH="${ROOT}/examples/laravel/app.php"
    if [ ! -f "${ROOT}/examples/laravel/vendor/autoload.php" ]; then
      echo "[demo] laravel dependencies missing"
      echo "run: cd ${ROOT}/examples/laravel && /Users/guweigang/bin/composer install"
      exit 2
    fi
    URLS=(
      "http://${HOST}:${PORT}/laravel/hello/nova"
      "http://${HOST}:${PORT}/laravel/meta?trace_id=demo"
    )
    ;;
  wordpress)
    APP_PATH="${ROOT}/examples/wordpress/app.php"
    WP_ROOT="${VSLIM_WP_ROOT:-}"
    if [ -z "${WP_ROOT}" ]; then
      echo "[demo] VSLIM_WP_ROOT is required for wordpress demo"
      exit 2
    fi
    if [ ! -f "${WP_ROOT}/wp-load.php" ]; then
      echo "[demo] wp-load.php not found under VSLIM_WP_ROOT=${WP_ROOT}"
      exit 2
    fi
    WORKER_ENV="VSLIM_WP_ROOT='${WP_ROOT}'"
    URLS=(
      "http://${HOST}:${PORT}/wordpress/meta?trace_id=demo"
      "http://${HOST}:${PORT}/wordpress/post/1"
    )
    ;;
  *)
    echo "usage: $0 [vslim|ai|symfony|laravel|wordpress]"
    exit 2
    ;;
esac

wait_ready() {
  local tries=120
  local i=0
  while [ "${i}" -lt "${tries}" ]; do
    if curl --noproxy '*' -sS "http://${HOST}:${PORT}/health" >/dev/null 2>&1; then
      return 0
    fi
    i=$((i + 1))
    sleep 0.2
  done
  return 1
}

cleanup() {
  if [ -f "${PID_FILE}" ]; then
    kill "$(cat "${PID_FILE}")" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

make -C "${ROOT}" build >/dev/null
make -C "${ROOT}" vhttpd >/dev/null

"${ROOT}/httpd/vhttpd" \
  --host "${HOST}" \
  --port "${PORT}" \
  --pid-file "${PID_FILE}" \
  --event-log "${EVENT_LOG}" \
  --worker-socket "${SOCKET}" \
  --worker-autostart 1 \
  --worker-cmd "${WORKER_ENV} VSLIM_HTTPD_APP='${APP_PATH}' php -d extension='${ROOT}/vslim.so' '${ROOT}/httpd/php-worker.php' --socket '${SOCKET}'" \
  >"${STDOUT_LOG}" 2>&1 &

if ! wait_ready; then
  echo "[demo] vhttpd not ready, log: ${STDOUT_LOG}"
  exit 1
fi

echo "[demo] case=${CASE}"
if [ "${CASE}" = "ai" ]; then
  txt_url="${URLS[0]}"
  sse_url="${URLS[1]}"
  echo "200 ${txt_url}"
  curl --noproxy '*' -sS -N "${txt_url}"
  echo
  echo "200 ${sse_url}"
  curl --noproxy '*' -sS -N --max-time 2 "${sse_url}"
  echo
else
  for url in "${URLS[@]}"; do
    code="$(curl --noproxy '*' -sS -o /tmp/vslim_demo_body.$$ -w '%{http_code}' "${url}")"
    body="$(cat /tmp/vslim_demo_body.$$)"
    rm -f /tmp/vslim_demo_body.$$
    echo "${code} ${url}"
    echo "${body}"
  done
fi

echo "[demo] done"
