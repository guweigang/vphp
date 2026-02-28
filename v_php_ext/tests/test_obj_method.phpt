--TEST--
test_obj_method tests
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
class User
{
    public function updateScore($score)
    {
        return "Score updated to " . $score;
    }
}

$u = new User();
// 输出: string(45) "Action triggered, PHP returned: Score updated to 100"
var_dump(v_trigger_user_action($u));
--EXPECT--
string(52) "Action triggered, PHP returned: Score updated to 100"
