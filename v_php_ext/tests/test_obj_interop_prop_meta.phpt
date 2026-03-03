--TEST--
ZVal object property has/isset/unset interop
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
class User
{
    public $name = "Gu Weigang";
    public $age = 18;
    public $note = null;
}

$user = new User();
$res = v_check_user_object_props($user);
ksort($res);
foreach ($res as $k => $v) {
    echo $k . "=" . $v . "\n";
}
echo "php_has_age=" . (property_exists($user, 'age') ? 'true' : 'false') . "\n";
echo "php_isset_age=" . (isset($user->age) ? 'true' : 'false') . "\n";
?>
--EXPECT--
has_age_after_unset=false
has_name=true
has_note=true
isset_name=true
isset_note=false
php_has_age=true
php_isset_age=false
