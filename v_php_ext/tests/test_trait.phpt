--TEST--
php_trait embedded structs flatten methods and properties, while outer class methods win on conflicts
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
$post = new TraitPost('Hello');
$rc = new ReflectionClass(TraitPost::class);
echo "internal_note_mods=" . implode(' ', Reflection::getModifierNames($rc->getProperty('internal_note')->getModifiers())) . PHP_EOL;
echo "internal_trait_mods=" . implode(' ', Reflection::getModifierNames($rc->getMethod('internal_trait')->getModifiers())) . PHP_EOL;
echo "slug=" . $post->slug . PHP_EOL;
echo "visits=" . $post->visits . PHP_EOL;
echo "trait_only=" . $post->trait_only() . PHP_EOL;
echo "summary=" . $post->summary() . PHP_EOL;
echo "bump=" . $post->bump() . PHP_EOL;
echo "visits_after=" . $post->visits . PHP_EOL;
try {
    echo $post->internal_trait() . PHP_EOL;
} catch (Error $e) {
    echo "protected_method=" . $e->getMessage() . PHP_EOL;
}
?>
--EXPECT--
internal_note_mods=protected
internal_trait_mods=protected
slug=from-trait
visits=1
trait_only=trait:from-trait
summary=class:Hello
bump=2
visits_after=2
protected_method=Call to protected method TraitPost::internal_trait() from global scope
