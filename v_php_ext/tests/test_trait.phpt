--TEST--
php_trait embedded structs flatten methods and properties, while outer class methods win on conflicts
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
$post = new TraitPost('Hello');
echo "slug=" . $post->slug . PHP_EOL;
echo "visits=" . $post->visits . PHP_EOL;
echo "trait_only=" . $post->trait_only() . PHP_EOL;
echo "summary=" . $post->summary() . PHP_EOL;
echo "bump=" . $post->bump() . PHP_EOL;
echo "visits_after=" . $post->visits . PHP_EOL;
?>
--EXPECT--
slug=from-trait
visits=1
trait_only=trait:from-trait
summary=class:Hello
bump=2
visits_after=2
