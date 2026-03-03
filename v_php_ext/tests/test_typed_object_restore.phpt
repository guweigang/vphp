--TEST--
typed object helpers restore vphp-exported PHP objects back into V pointers
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
echo v_typed_object_restore() . "\n";
?>
--EXPECT--
objects=Typed Author:77:Typed Article:true
