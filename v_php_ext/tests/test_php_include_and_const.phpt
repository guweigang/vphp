--TEST--
PHP global constants and include helpers work from V interop
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
$fixture = __DIR__ . '/fixtures/include_fixture.php';

echo v_read_php_global_const('PHP_VERSION') . PHP_EOL;
echo v_include_php_file_once($fixture) . PHP_EOL;
echo v_read_php_global_const('VPHP_INCLUDED_VALUE') . PHP_EOL;
var_dump(v_include_php_file_once($fixture));
echo v_include_php_file($fixture) . PHP_EOL;
?>
--EXPECTF--
PHP_VERSION=%s
include:1
VPHP_INCLUDED_VALUE=loaded-from-php
bool(true)
include:2
