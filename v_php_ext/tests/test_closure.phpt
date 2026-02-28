--TEST--
test_closure tests
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
// test_closure.php
$callback = function ($data) {
    return "Received: " . $data;
};

echo v_call_php_closure($callback);
// 预期输出: Closure executed, PHP said: Received: Message from V Engine
--EXPECT--
Closure executed, PHP said: Received: Message from V Engine
