--TEST--
ZVal object metadata helpers expose class and namespace names
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
namespace Demo\Meta;

interface NamedBox {}

class ParentBox {}

class Box extends ParentBox implements NamedBox, \JsonSerializable {
    public function jsonSerialize(): mixed
    {
        return ['ok' => true];
    }
}

$meta = \v_php_object_meta(new Box());
ksort($meta);
foreach ($meta as $k => $v) {
    echo $k . '=' . $v . PHP_EOL;
}

$internal = \v_php_object_meta(new \DateTimeImmutable('2026-03-04'));
echo 'internal_class=' . $internal['class'] . PHP_EOL;
echo 'internal_parent=' . $internal['parent'] . PHP_EOL;
echo 'internal_flag=' . $internal['internal'] . PHP_EOL;
?>
--EXPECT--
class=Demo\Meta\Box
interfaces=Demo\Meta\NamedBox,JsonSerializable
internal=false
namespace=Demo\Meta
parent=Demo\Meta\ParentBox
short=Box
user_class=true
internal_class=DateTimeImmutable
internal_parent=
internal_flag=true
