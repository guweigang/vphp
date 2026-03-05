#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SMOKE="${ROOT}/tests/psr7_matrix_smoke.php"
COMPOSER_BIN="${COMPOSER_BIN:-composer}"

if ! command -v php >/dev/null 2>&1; then
  echo "php not found"
  exit 2
fi
if ! command -v "${COMPOSER_BIN}" >/dev/null 2>&1; then
  echo "composer not found (COMPOSER_BIN=${COMPOSER_BIN})"
  exit 2
fi

WORKDIR="${PSR_MATRIX_WORKDIR:-${ROOT}/.tmp/psr-matrix}"
rm -rf "${WORKDIR}"
mkdir -p "${WORKDIR}"

run_case() {
  local case_name="$1"
  local package_name="$2"
  local case_dir="${WORKDIR}/${case_name}"
  mkdir -p "${case_dir}"
  pushd "${case_dir}" >/dev/null
  "${COMPOSER_BIN}" init --name "vslim/${case_name}-matrix" --no-interaction >/dev/null
  "${COMPOSER_BIN}" require --no-interaction --prefer-dist "${package_name}" >/dev/null
  MATRIX_CASE="${case_name}" MATRIX_AUTOLOAD="${case_dir}/vendor/autoload.php" php "${SMOKE}"
  popd >/dev/null
}

echo "[psr-matrix] workdir=${WORKDIR}"
echo "[psr-matrix] composer=${COMPOSER_BIN}"
run_case "nyholm" "nyholm/psr7"
run_case "guzzle" "guzzlehttp/psr7"
run_case "laminas" "laminas/laminas-diactoros"
echo "[psr-matrix] all cases passed"
