--TEST--
Check extension configuration (INI)
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
echo "vphptest.enable_cache: " . ini_get("vphptest.enable_cache") . "\n";
echo "vphptest.max_threads: " . ini_get("vphptest.max_threads") . "\n";
?>
--EXPECT--
vphptest.enable_cache: 1
vphptest.max_threads: 4
