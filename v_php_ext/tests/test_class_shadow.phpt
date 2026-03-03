--TEST--
test_class_shadow tests
--FILE--
<?php
echo "const.max=" . Article::MAX_TITLE_LEN . PHP_EOL;
echo "const.name=" . Article::NAME . PHP_EOL;
echo "const.age=" . Article::AGE . PHP_EOL;

echo "static.initial=" . Article::$total_count . PHP_EOL;

new Article("A", 1);
new Article("B", 2);
echo "static.after_v=" . Article::$total_count . PHP_EOL;

Article::$total_count = 100;
new Article("C", 3);
echo "static.after_php=" . Article::$total_count . PHP_EOL;
?>
--EXPECT--
const.max=1024
const.name=Samantha Black
const.age=24
static.initial=0
static.after_v=2
static.after_php=101
