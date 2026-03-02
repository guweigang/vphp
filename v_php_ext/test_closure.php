<?php
if (!extension_loaded('vphptest')) {
    dl('v_php_ext.so');
}

echo "Testing V Closure...\n";

$cb = v_get_v_closure();

echo "Closure type: " . get_class($cb) . "\n";
echo "Invoking closure with 5...\n";
$result = $cb(5);
echo "Result: $result (Expected: 50)\n";

echo "Invoking closure with 10...\n";
$result = $cb(10);
echo "Result: $result (Expected: 100)\n";
?>