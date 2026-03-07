#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://127.0.0.1:19888}"
ADMIN_URL="${ADMIN_URL:-http://127.0.0.1:19988/admin/workers}"
OUT="${OUT:-/tmp/vslim_10x50k.tsv}"
ROUNDS="${ROUNDS:-10}"
VUS="${VUS:-30}"
ITER="${ITER:-50000}"

VHTTPD_PID="$(lsof -tiTCP:19888 -sTCP:LISTEN | head -n1 || true)"
if [[ -z "$VHTTPD_PID" ]]; then
  echo "找不到监听 19888 的 vhttpd 进程"
  exit 1
fi

curl --noproxy '*' -fsS "${BASE_URL}/health" >/dev/null
curl --noproxy '*' -fsS "${ADMIN_URL}" >/dev/null

echo -e "round\tvhttpd_rss_kb\tphp_workers_rss_kb\tserved_sum\trestart_sum\thttp_req_failed_pct" > "$OUT"

for r in $(seq 1 "$ROUNDS"); do
  K6_JSON="/tmp/k6_round_${r}.json"

  BASE_URL="$BASE_URL" API_TOKEN="demo-token" \
    k6 run --vus "$VUS" --iterations "$ITER" --summary-export "$K6_JSON" \
    /Users/guweigang/Source/vphpext/vslim/examples/k6_demo.js >/tmp/k6_round_${r}.log 2>&1 || true

  VHTTPD_RSS="$(ps -o rss= -p "$VHTTPD_PID" | tr -d ' ' || echo 0)"

  PHP_RSS_SUM=0
  while read -r p; do
    [[ -z "$p" ]] && continue
    rss="$(ps -o rss= -p "$p" | tr -d ' ' || echo 0)"
    PHP_RSS_SUM=$((PHP_RSS_SUM + rss))
  done < <(pgrep -f 'php-worker.*vslim_demo_worker' || true)

  ADMIN_JSON="$(curl --noproxy '*' -s "$ADMIN_URL" || echo '{}')"
  SERVED_SUM="$(echo "$ADMIN_JSON" | jq '[.workers[]?.served_requests // 0] | add // 0')"
  RESTART_SUM="$(echo "$ADMIN_JSON" | jq '[.workers[]?.restart_count // 0] | add // 0')"
  FAILED_PCT="$(jq -r '.metrics.http_req_failed.values.rate // 0' "$K6_JSON" 2>/dev/null | awk '{printf "%.4f", $1*100}')"

  echo -e "${r}\t${VHTTPD_RSS}\t${PHP_RSS_SUM}\t${SERVED_SUM}\t${RESTART_SUM}\t${FAILED_PCT}" | tee -a "$OUT"
done

echo "DONE: $OUT"
