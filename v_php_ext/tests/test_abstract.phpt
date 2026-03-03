--TEST--
test_abstract tests
--FILE--
<?php
$rc = new ReflectionClass(AbstractReport::class);
echo "isAbstract=" . ($rc->isAbstract() ? 'yes' : 'no') . PHP_EOL;
echo "isInstantiable=" . ($rc->isInstantiable() ? 'yes' : 'no') . PHP_EOL;

$methods = $rc->getMethods();
usort($methods, fn($a, $b) => strcmp($a->getName(), $b->getName()));
foreach ($methods as $method) {
    if (!in_array($method->getName(), ['label', 'summarize'], true)) {
        continue;
    }
    echo $method->getName() . ':' . implode(' ', Reflection::getModifierNames($method->getModifiers())) . PHP_EOL;
}

try {
    new AbstractReport();
} catch (Error $e) {
    echo "new_error=" . $e->getMessage() . PHP_EOL;
}

$report = new DailyReport('Sales', 'Strong growth');
echo $report->label() . PHP_EOL;
echo $report->summarize() . PHP_EOL;
echo "instanceof=" . ($report instanceof AbstractReport ? 'yes' : 'no') . PHP_EOL;
?>
--EXPECT--
isAbstract=yes
isInstantiable=no
label:public
summarize:abstract public
new_error=Cannot instantiate abstract class AbstractReport
Report: Sales
Strong growth
instanceof=yes
