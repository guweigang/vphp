<?php
echo "Step 1: Creating Author\n";
$author = Author::create("Gu Weigang");
echo "Author name: " . $author->get_name() . "\n";

echo "\nStep 2: Creating Article and setting Author\n";
$article = new Post();
$article->set_author($author);

echo "\nStep 3: Getting Author back\n";
$ret_author = $article->get_author();
echo "Returned Author name: " . $ret_author->get_name() . "\n";

echo "Are they the same object? " . ($author === $ret_author ? "Yes" : "No") . "\n";
