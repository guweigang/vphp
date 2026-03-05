--TEST--
ZVal conversion API supports roundtrip via from/to helpers
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
echo v_zval_conversion_api() . PHP_EOL;
?>
--EXPECT--
conv=v:vphp:3:7:true
