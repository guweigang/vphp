<?php
// 1. 测试普通函数
echo "Testing v_add(10, 20): " . v_add(10, 20) . "\n";

// 2. 测试并发任务
echo "Spawning AnalyzeTask...\n";

// v_spawn 会触发 V 侧的 ITask.register 查找并执行 spawn task.run()
$t1 = v_spawn("AnalyzeTask");
$t2 = v_spawn("AnalyzeTask");

echo "Tasks are running in V threads...\n";
echo "Doing something else in PHP...\n";
usleep(500000); // 模拟 PHP 侧的其它逻辑

// 3. 等待并获取结果
// v_wait 会阻塞直到 V 线程返回 []f64，并自动转为 PHP array
$res1 = v_wait($t1);
$res2 = v_wait($t2);

echo "Result 1: " . json_encode($res1) . "\n";
echo "Result 2: " . json_encode($res2) . "\n";
