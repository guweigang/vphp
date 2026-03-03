--TEST--
test_enum tests
--FILE--
<?php
echo "draft=" . ArticleStatus::draft . PHP_EOL;
echo "review=" . ArticleStatus::review . PHP_EOL;
echo "published=" . ArticleStatus::published . PHP_EOL;

$rc = new ReflectionClass(ArticleStatus::class);
echo "isFinal=" . ($rc->isFinal() ? 'yes' : 'no') . PHP_EOL;
echo "isInstantiable=" . ($rc->isInstantiable() ? 'yes' : 'no') . PHP_EOL;

$constants = $rc->getConstants();
ksort($constants);
foreach ($constants as $name => $value) {
    echo $name . '=' . $value . PHP_EOL;
}
?>
--EXPECT--
draft=0
review=1
published=2
isFinal=yes
isInstantiable=no
draft=0
published=2
review=1
