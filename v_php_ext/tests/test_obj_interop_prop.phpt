--TEST--
ZVal object property interop
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
class User
{
    public $name = "Gu Weigang";
    public $age = 18;
}

$user = new User();
echo v_mutate_user_object($user) . "\n";
echo $user->name . "\n";
echo $user->age . "\n";
?>
--EXPECT--
updated=Updated by V:20
Updated by V
20
