--TEST--
V str() maps to PHP __toString()
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
$box = new StringableBox('codex');
echo $box . PHP_EOL;
echo (method_exists($box, '__toString') ? 'has_magic=yes' : 'has_magic=no') . PHP_EOL;
?>
--EXPECT--
box:codex
has_magic=yes
