<?php
echo "--- Testing to_object ---\n";
$author = Author::create("VPHP Coder");
$restored = Article::restore_author($author);
echo "Restored Author: " . $restored->get_name() . "\n";
echo "Are they the same object? " . ($author === $restored ? "Yes" : "No") . "\n";

echo "\n--- Testing Val.foreach on Array ---\n";
$article = Article::create("Iterating attributes");
$article->dump_properties(["A" => 10, "B" => "string_val", "C" => true]);

echo "\n--- Testing Val.foreach on Object ---\n";
$obj = new stdClass();
$obj->prop1 = "hello obj";
$obj->prop2 = 42;
$article->dump_properties($obj);
?>