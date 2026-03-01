--TEST--
Test Author object inside Post
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
echo "Step 1: Creating Author\n";
$author = Author::create("Gu Weigang");
echo "Author name: " . $author->get_name() . "\n";

echo "\nStep 2: Creating Article and setting Author\n";
$article = Article::create("VPHP is awesome");
$article->set_author($author);

echo "\nStep 3: Getting Author back\n";
$ret_author = $article->get_author();
echo "Returned Author name: " . $ret_author->get_name() . "\n";
echo "Are they the same object? " . ($author === $ret_author ? "Yes" : "No") . "\n";

echo "\nStep 4: Story create with Author\n";
$story = Story::create($author, 5);
echo $story->tell() . "\n";

?>
--EXPECT--
Step 1: Creating Author
Author name: Gu Weigang

Step 2: Creating Article and setting Author

Step 3: Getting Author back
Returned Author name: Gu Weigang
Are they the same object? No

Step 4: Story create with Author
Author Gu Weigang is telling a story with 5 chapters.
