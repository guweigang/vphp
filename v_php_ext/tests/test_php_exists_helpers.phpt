--TEST--
Interop existence helpers check PHP functions, classes, interfaces, traits, and constants
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
namespace Demo\Interop;

trait HelperTrait {}

$meta = \v_php_symbol_exists();
ksort($meta);
foreach ($meta as $k => $v) {
    echo $k . '=' . $v . PHP_EOL;
}
?>
--EXPECT--
class_datetime=true
class_missing=false
const_missing=false
const_php_version=true
function_missing=false
function_strlen=true
interface_json=true
interface_missing=false
trait_missing=false
trait_user=true
