<?php
// test_closure.php
$callback = function ($data) {
    return "Received: " . $data;
};

echo v_call_php_closure($callback);
// 预期输出: Closure executed, PHP said: Received: Message from V Engine
