--TEST--
test_interface tests
--FILE--
<?php
$rc = new ReflectionClass(ContentContract::class);
echo "isInterface=" . ($rc->isInterface() ? 'yes' : 'no') . PHP_EOL;

$methods = $rc->getMethods();
usort($methods, fn($a, $b) => strcmp($a->getName(), $b->getName()));
foreach ($methods as $method) {
    echo $method->getName() . ':' . implode(' ', Reflection::getModifierNames($method->getModifiers())) . PHP_EOL;
}

$article = Article::create("Bridge");
echo "instanceof=" . ($article instanceof ContentContract ? 'yes' : 'no') . PHP_EOL;

$interfaces = class_implements($article);
ksort($interfaces);
foreach ($interfaces as $name) {
    echo "implements=" . $name . PHP_EOL;
}
?>
--EXPECT--
isInterface=yes
get_formatted_title:abstract public
save:abstract public
instanceof=yes
implements=ContentContract
