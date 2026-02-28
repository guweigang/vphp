--TEST--
Article OOP Modifiers Test
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php

echo "1. Reflection checks:\n";

$rc = new ReflectionClass(Article::class);

$props = $rc->getProperties();
foreach ($props as $p) {
    $modifiers = implode(' ', Reflection::getModifierNames($p->getModifiers()));
    echo "Property: " . $p->getName() . " - " . $modifiers . "\n";
}

$methods = $rc->getMethods();
foreach ($methods as $m) {
    // Only check methods we defined, ignore standard ones if any
    $modifiers = implode(' ', Reflection::getModifierNames($m->getModifiers()));
    echo "Method: " . $m->getName() . " - " . $modifiers . "\n";
}


echo "\n2. Runtime behavior:\n";

$article = new Article("Hello V!", 1);
echo "Title: " . $article->title . "\n";

echo "Formatted: " . $article->get_formatted_title() . "\n";

try {
    echo $article->content;
} catch (Error $e) {
    echo "Caught protected property access: " . $e->getMessage() . "\n";
}

try {
    $article->internal_format();
} catch (Error $e) {
    echo "Caught protected method call: " . $e->getMessage() . "\n";
}

?>
--EXPECT--
1. Reflection checks:
Property: post_id - public
Property: author - public
Property: id - public
Property: title - public
Property: is_top - public
Property: max_title_len - public static
Property: content - protected
Property: total_count - protected static
Method: __construct - public
Method: internal_format - protected
Method: create - public static
Method: get_formatted_title - public
Method: save - public
Method: set_author - public
Method: get_author - public

2. Runtime behavior:
Title: Hello V!
V Article initialized with title: Hello V!
Formatted: [Protected] Hello V!
Default ContentCaught protected method call: Call to protected method Article::internal_format() from global scope
