--TEST--
php_class constant interop reads class constants from PHP and vphp-exported classes
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
class PhpMeta
{
    public const VERSION = 'v1';
}

echo v_read_php_class_constant() . "\n";
?>
--EXPECT--
consts=1024:v1
