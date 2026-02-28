--TEST--
test_analyze tests
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
// 准备测试数据
$user = "Bullsoft_User_001";
$heart_rates = [75.5, 120.0, 155.2, 180.5, 90.0];
$settings = [
    "mode" => "HIIT_Training",
    "version" => "1.0.2",
];

echo "🚀 发送数据到 V 扩展进行高性能分析...\n";

// 调用你在 V 侧导出的函数
$result = v_analyze_fitness_data($user, $heart_rates, $settings);

var_dump($result);

// echo "📊 分析结果: " . $result . "\n";
--EXPECT--
🚀 发送数据到 V 扩展进行高性能分析...
array(6) {
  ["user_name"]=>
  string(17) "Bullsoft_User_001"
  ["max_hr"]=>
  float(180.5)
  ["min_hr"]=>
  float(75.5)
  ["avg_hr"]=>
  float(124.24000000000001)
  ["risk_level"]=>
  string(9) "High Risk"
  ["device_mode"]=>
  string(13) "HIIT_Training"
}
