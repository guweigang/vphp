#!/usr/bin/env bash
set -euo pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$DIR"

PHP_BIN=$(which php)
if [ -z "$PHP_BIN" ]; then
    echo "Error: PHP is not found in PATH."
    exit 1
fi

RUN_TESTS="../v_php_ext/run-tests.php"
if [ ! -f "$RUN_TESTS" ]; then
    echo "Error: $RUN_TESTS is not available."
    exit 1
fi

echo "Running tests with PHP: $PHP_BIN"
TEST_PHP_EXECUTABLE="$PHP_BIN" php "$RUN_TESTS" -q --show-all -d extension=./vslim.so tests/
