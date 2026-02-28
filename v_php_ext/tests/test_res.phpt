--TEST--
test_res tests
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
// test_coach.php
$coach = v_new_coach();
var_dump($coach);

if (get_resource_type($coach) === "VPHP Generic Resource") {
    echo "✅ 资源类型识别成功！\n";
}

// 尝试使用该资源
echo v_check_res($coach) . "\n";
--EXPECT--
resource(4) of type (VPHP Generic Resource)
✅ 资源类型识别成功！
Hello, Bullsoft_Master
