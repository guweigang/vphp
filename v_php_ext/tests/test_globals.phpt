--TEST--
Check extension globals (request count)
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
$res1 = v_test_globals();
print_r($res1);

$res2 = v_test_globals();
print_r($res2);
?>
--EXPECT--
Array
(
    [count] => 1
    [user] => VPHP_USER
)
Array
(
    [count] => 2
    [user] => VPHP_USER
)
