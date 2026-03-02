<?php
if (!extension_loaded('vphptest')) {
    @dl('v_php_ext.so');
}

echo "Testing Automated V Closure (2 Arguments)...\n";

// 调用我们在 functions.v 中导出的自动包装函数
$cb = v_get_v_closure_auto();

echo "Closure type: " . get_class($cb) . "\n";

$name = "Antigravity";
$count = 888;

echo "Invoking closure with ('$name', $count)...\n";
$result = $cb($name, $count);
echo "Result: $result\n";

// 再次测试，捕获值应该稳定
echo "Invoking again with ('PHP-User', 2026)...\n";
$result = $cb("PHP-User", 2026);
echo "Result: $result\n";
?>