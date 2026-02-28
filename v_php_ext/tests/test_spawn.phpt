--TEST--
test_spawn tests
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
// PHP 侧直接传数组，扩展会自动（或手动 json_encode）接收
$params = [
    "symbol" => "SH600519",
    "prices" => [1700.5, 1800.2],
    "limit" => 5,
];

$t = v_spawn("AnalyzeTask", json_encode($params));
$res = v_wait($t);
print_r($res);
--EXPECT--
Array
(
    [0] => 1
    [1] => 2
)
V: 正在处理 SH600519
