--TEST--
php_class static_method interop calls PHP static methods
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
class PhpMath
{
    public static function triple(int $n): int
    {
        return $n * 3;
    }
}

echo v_call_php_static_method() . "\n";
?>
--EXPECT--
static=21
