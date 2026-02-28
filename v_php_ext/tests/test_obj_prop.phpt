--TEST--
test_obj_prop tests
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
class User
{
    public $name = "Gu Weigang";
    public $age = 18;
}

$user = new User();
echo v_analyze_user_object($user);
// 输出: V 侧收到对象数据：姓名=Gu Weigang, 年龄=18
--EXPECT--

