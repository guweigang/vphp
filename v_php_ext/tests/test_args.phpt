--TEST--
test_args tests
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php

echo v_universal_handler("PHP", 3);
--EXPECTF--
Fatal error: Uncaught Error: Call to undefined function v_universal_handler() in %s/tests/test_args.php:%d
Stack trace:
#0 {main}
  thrown in %s/tests/test_args.php on line 3
