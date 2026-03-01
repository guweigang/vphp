<?php

echo "Testing Article Static Properties:\n";
if (property_exists('Article', 'total_count')) {
    echo "Article::\$total_count exists!\n";

    // 验证初始值
    echo "Initial total_count: " . Article::$total_count . "\n";

    // 验证修改
    Article::$total_count = 100;
    echo "Modified total_count: " . Article::$total_count . "\n";
} else {
    echo "Error: Article::\$total_count not found!\n";
}

echo "\nTesting Reflection for Statics:\n";
$ref = new ReflectionClass('Article');
$props = $ref->getProperties(ReflectionProperty::IS_STATIC);
foreach ($props as $p) {
    echo "Found static property: " . $p->getName() . "\n";
}
