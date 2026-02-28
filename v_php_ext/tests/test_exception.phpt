--TEST--
test_exception tests
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
echo v_logic_main("Hello World") . PHP_EOL;

echo v_logic_main();
--EXPECTF--
dlroW olleH

Fatal error: Uncaught Exception: 至少需要一个参数 in %s/tests/test_exception.php:%d
Stack trace:
#0 %s/tests/test_exception.php(4): v_logic_main()
#1 {main}
  thrown in %s/tests/test_exception.php on line 4
