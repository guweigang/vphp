<?php
if (!extension_loaded('vphptest')) {
    dl('v_php_ext.so');
}

echo "Testing Article Class Constants:\n";
echo "Article::MAX_TITLE_LEN = " . Article::MAX_TITLE_LEN . "\n";
echo "Article::NAME = " . Article::NAME . "\n";
echo "Article::AGE = " . Article::AGE . "\n";

echo "\nTesting Reflection:\n";
$ref = new ReflectionClass('Article');
print_r($ref->getConstants());
