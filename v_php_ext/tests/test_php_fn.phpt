--TEST--
php_fn interop calls PHP global functions
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
echo v_call_back() . "\n";
?>
--EXPECTF--
V knows PHP version is: %s
