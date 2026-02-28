--TEST--
test_map tests
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
$map = v_pure_map_test("name", "Weigang");
var_dump($map);
--EXPECTF--
array(1) {
  ["name"]=>
  string(7) "Weigang"
}
