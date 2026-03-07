#!/usr/bin/env bash
set -euo pipefail

BASE_URL="${BASE_URL:-http://127.0.0.1:19888}"
TMP_DIR="$(mktemp -d /tmp/vslim_verify.XXXXXX)"
trap 'rm -rf "$TMP_DIR"' EXIT

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "missing required command: $1" >&2
    exit 1
  }
}

fetch() {
  local name="$1"
  local method="$2"
  local url="$3"
  local body="${4:-}"
  local content_type="${5:-}"

  local headers="$TMP_DIR/${name}.headers"
  local out="$TMP_DIR/${name}.body"
  local code

  if [[ -n "$content_type" ]]; then
    code="$(curl --noproxy '*' -sS -X "$method" \
      -H "Content-Type: $content_type" \
      -D "$headers" -o "$out" -w '%{http_code}' \
      --data "$body" "$url")"
  elif [[ -n "$body" ]]; then
    code="$(curl --noproxy '*' -sS -X "$method" \
      -D "$headers" -o "$out" -w '%{http_code}' \
      --data "$body" "$url")"
  else
    code="$(curl --noproxy '*' -sS -X "$method" \
      -D "$headers" -o "$out" -w '%{http_code}' "$url")"
  fi

  echo "$code" > "$TMP_DIR/${name}.code"
}

expect_code() {
  local name="$1"
  local want="$2"
  local got
  got="$(cat "$TMP_DIR/${name}.code")"
  if [[ "$got" != "$want" ]]; then
    echo "[FAIL] $name code expected $want got $got" >&2
    cat "$TMP_DIR/${name}.body" >&2 || true
    exit 1
  fi
}

expect_body_contains() {
  local name="$1"
  local needle="$2"
  if ! grep -Fq "$needle" "$TMP_DIR/${name}.body"; then
    echo "[FAIL] $name body missing: $needle" >&2
    cat "$TMP_DIR/${name}.body" >&2 || true
    exit 1
  fi
}

expect_header_contains() {
  local name="$1"
  local needle="$2"
  if ! grep -Fiq "$needle" "$TMP_DIR/${name}.headers"; then
    echo "[FAIL] $name header missing: $needle" >&2
    cat "$TMP_DIR/${name}.headers" >&2 || true
    exit 1
  fi
}

json_check() {
  local name="$1"
  local code="$2"
  php -r '
$f = $argv[1];
$src = file_get_contents($f);
$j = json_decode($src, true);
if (!is_array($j)) { fwrite(STDERR, "invalid json\n"); exit(2); }
' "$TMP_DIR/${name}.body"
  php -r "$code" "$TMP_DIR/${name}.body"
}

require_cmd curl
require_cmd php

echo "[1/7] health"
fetch health GET "${BASE_URL}/health"
expect_code health 200

echo "[2/7] hello route"
fetch hello GET "${BASE_URL}/hello/codex?trace_id=verify"
expect_code hello 200
expect_body_contains hello "hello codex"
expect_header_contains hello "X-Request-Id:"

echo "[3/7] api authorized"
fetch api_ok GET "${BASE_URL}/api/users/7?token=demo-token"
expect_code api_ok 200
expect_body_contains api_ok '"ok":true'

echo "[4/7] api unauthorized"
fetch api_bad GET "${BASE_URL}/api/users/7?token=bad-token"
expect_code api_bad 401

echo "[5/7] forms echo"
fetch forms POST "${BASE_URL}/forms/echo?token=demo" "name=neo&city=shanghai" "application/x-www-form-urlencoded"
expect_code forms 200
expect_body_contains forms '"body_format":"form"'
expect_body_contains forms '"name":"neo"'

echo "[6/7] debug routes"
fetch debug_routes GET "${BASE_URL}/debug/routes"
expect_code debug_routes 200
json_check debug_routes '
$j = json_decode(file_get_contents($argv[1]), true);
if (!isset($j["count"]) || !is_int($j["count"])) exit(3);
if (!isset($j["manifest"]) || !is_array($j["manifest"])) exit(4);
if (count($j["manifest"]) < 1) exit(5);
if (!isset($j["manifest"][0]["method"])) exit(6);
if (!isset($j["manifest_lines"]) || !is_array($j["manifest_lines"])) exit(7);
'

echo "[7/7] debug route conflicts"
fetch debug_conflicts GET "${BASE_URL}/debug/route-conflicts"
expect_code debug_conflicts 200
json_check debug_conflicts '
$j = json_decode(file_get_contents($argv[1]), true);
if (!array_key_exists("conflicts", $j) || !is_array($j["conflicts"])) exit(8);
if (!array_key_exists("conflict_keys", $j) || !is_array($j["conflict_keys"])) exit(9);
'

echo "verify_demo: PASS (${BASE_URL})"
