--TEST--
include_once can load a PHP module file, then V can construct the class and iterate returned config
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
$fixture = __DIR__ . '/fixtures/include_module_fixture.php';
echo v_include_php_module_demo($fixture) . PHP_EOL;
?>
--EXPECT--
count=3|class=Demo\IncludeCase\ModuleBox|short=ModuleBox|desc=box:codex|items=mode=prod,driver=mysql,host=127.0.0.1
