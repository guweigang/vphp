--TEST--
ZVal object metadata helpers expose class and namespace names
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
namespace Demo\Meta;

class Box {}

$meta = \v_php_object_meta(new Box());
ksort($meta);
foreach ($meta as $k => $v) {
    echo $k . '=' . $v . PHP_EOL;
}
?>
--EXPECT--
class=Demo\Meta\Box
namespace=Demo\Meta
short=Box
