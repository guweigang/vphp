--TEST--
Readonly sample class keeps PHP readonly semantics
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
$rc = new ReflectionClass(ReadonlyRecord::class);
echo "created_at=" . implode(' ', Reflection::getModifierNames($rc->getProperty('created_at')->getModifiers())) . PHP_EOL;
echo "title=" . implode(' ', Reflection::getModifierNames($rc->getProperty('title')->getModifiers())) . PHP_EOL;
echo "internal_note=" . implode(' ', Reflection::getModifierNames($rc->getProperty('internal_note')->getModifiers())) . PHP_EOL;

$record = new ReadonlyRecord('Audit');
echo $record->reveal() . PHP_EOL;

try {
    $record->created_at = 99;
} catch (Error $e) {
    echo "readonly=" . $e->getMessage() . PHP_EOL;
}
?>
--EXPECT--
created_at=public protected(set) readonly
title=public
internal_note=protected
Audit:42
readonly=Cannot modify readonly property ReadonlyRecord::$created_at
