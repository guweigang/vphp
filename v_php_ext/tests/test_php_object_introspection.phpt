--TEST--
ZVal object introspection exposes method, property, and class constant metadata
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
namespace Demo\Inspect;

class BaseBox {}

final class GreeterBox extends BaseBox
{
    public const LABEL = 'BOX';
    public const VERSION = '1.0';

    public function __construct(public string $name) {}

    public function greet(): string
    {
        return "Hello {$this->name}";
    }
}

$box = new GreeterBox('Codex');
$meta = v_php_object_introspection($box);
ksort($meta);
foreach ($meta as $k => $v) {
    echo $k . '=' . $v . PHP_EOL;
}
?>
--EXPECT--
class_consts=LABEL,VERSION
datetime_has_atom=true
has_method_greet=true
has_method_missing=false
has_prop_missing=false
has_prop_name=true
implements_json=false
implements_string=false
is_box=true
is_datetime=false
is_subclass_parent=true
is_subclass_self=false
method_names=__construct,greet
property_names=name
