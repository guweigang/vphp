--TEST--
Class constants are visible through reflection
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
echo "Article::MAX_TITLE_LEN=" . Article::MAX_TITLE_LEN . PHP_EOL;
echo "Article::NAME=" . Article::NAME . PHP_EOL;
echo "Article::AGE=" . Article::AGE . PHP_EOL;

$ref = new ReflectionClass(Article::class);
$consts = $ref->getConstants();
ksort($consts);
foreach ($consts as $name => $value) {
    if (is_bool($value)) {
        $value = $value ? 'true' : 'false';
    }
    echo $name . '=' . $value . PHP_EOL;
}
?>
--EXPECT--
Article::MAX_TITLE_LEN=1024
Article::NAME=Samantha Black
Article::AGE=24
AGE=24
MAX_TITLE_LEN=1024
NAME=Samantha Black
