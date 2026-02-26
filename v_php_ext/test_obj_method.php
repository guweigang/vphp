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
