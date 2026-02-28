#!/usr/bin/env bash
# run_tests.sh
# A simple wrapper to test the extension using PHP's run-tests.php

# Get directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$DIR"

# Download run-tests.php if not available
if [ ! -f "run-tests.php" ]; then
    echo "Downloading run-tests.php..."
    curl -sL https://raw.githubusercontent.com/php/php-src/master/run-tests.php -o run-tests.php
fi

# Locate PHP
PHP_BIN=$(which php)
if [ -z "$PHP_BIN" ]; then
    echo "Error: PHP is not found in PATH."
    exit 1
fi

echo "Running tests with PHP: $PHP_BIN"

# Execute run-tests.php for the compiled extension
TEST_PHP_EXECUTABLE="$PHP_BIN" php run-tests.php -q --show-all -d extension=./v_php_ext.so tests/
