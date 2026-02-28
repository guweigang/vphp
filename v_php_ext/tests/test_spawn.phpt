--TEST--
test_spawn tests
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
// 先看看可用什么任务
print_r(VPhp\Task::list());

// PHP 侧直接传基础类型参数
$t = VPhp\Task::spawn("AnalyzeTask", "SH600519", 100);
$res = VPhp\Task::wait($t);
print_r($res);
--EXPECT--
Array
(
    [0] => AnalyzeTask
)
Array
(
    [0] => 1
    [1] => 2
)
V: 正在处理 SH600519, count: 100
