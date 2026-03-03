--TEST--
php_class static_prop interop reads and writes PHP static properties
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
class PhpCounter
{
    public static int $count = 10;
}

echo v_mutate_php_static_prop() . "\n";
echo PhpCounter::$count . "\n";
?>
--EXPECT--
static_prop=10->15
15
