--TEST--
test_const tests
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
var_dump(APP_VERSION);
var_dump(MAX_RETRY);
var_dump(PI_VALUE);
var_dump(DEBUG_MODE);

// 确认常量已定义
var_dump(defined('APP_VERSION'));
var_dump(defined('MAX_RETRY'));
--EXPECT--
string(5) "1.0.0"
int(3)
float(3.14159)
bool(false)
bool(true)
bool(true)
