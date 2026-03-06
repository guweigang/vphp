--TEST--
php_extends/php_implements attributes resolve V symbols and PHP interface names
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
$base = new ReflectionClass('Demo\\Contracts\\AliasBase');
$worker = new ReflectionClass(AliasWorker::class);

echo "base_name=" . $base->getName() . PHP_EOL;
echo "parent_name=" . $worker->getParentClass()->getName() . PHP_EOL;

$obj = new AliasWorker('edge', 'bridge');
echo "instanceof_base=" . ($obj instanceof Demo\Contracts\AliasBase ? 'yes' : 'no') . PHP_EOL;
echo "instanceof_contract=" . ($obj instanceof ContentContract ? 'yes' : 'no') . PHP_EOL;
echo "instanceof_alias_contract=" . ($obj instanceof Demo\Contracts\AliasContract ? 'yes' : 'no') . PHP_EOL;
echo "formatted=" . $obj->get_formatted_title() . PHP_EOL;
echo "ping=" . $obj->ping() . PHP_EOL;

$ifaces = class_implements($obj);
ksort($ifaces);
foreach ($ifaces as $name) {
    echo "implements=" . $name . PHP_EOL;
}
?>
--EXPECT--
base_name=Demo\Contracts\AliasBase
parent_name=Demo\Contracts\AliasBase
instanceof_base=yes
instanceof_contract=yes
instanceof_alias_contract=yes
formatted=edge:bridge
ping=edge:bridge
implements=ContentContract
implements=Demo\Contracts\AliasContract
