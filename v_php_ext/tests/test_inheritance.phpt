--TEST--
test_inheritance tests
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
$article = Article::create("My Post");

echo "Step 1: Check instanceof\n";
var_dump($article instanceof Post);
var_dump($article instanceof Article);

echo "\nStep 2: Use inherited methods\n";
$author = Author::create("Weigang Gu");
$article->set_author($author);
var_dump($article->get_author()->get_name());

echo "\nStep 3: Access inherited properties (if V exposed or via PHP)\n";
$article->post_id = 12345;
var_dump($article->post_id);

echo "\nStep 4: Test Story (Auto inheritance via Embed)\n";
$author = Author::create("Gu Weigang");
$story = Story::create($author, 10);
var_dump($story instanceof Post);
var_dump($story instanceof Story);
echo $story->tell() . "\n";
$new_author = Author::create("New Author");
$story->set_author($new_author);
echo "Updated author: " . $story->get_author()->get_name() . "\n";

--EXPECTF--
Step 1: Check instanceof
bool(true)
bool(true)

Step 2: Use inherited methods
string(10) "Weigang Gu"

Step 3: Access inherited properties (if V exposed or via PHP)
int(12345)

Step 4: Test Story (Auto inheritance via Embed)
bool(true)
bool(true)
Author Gu Weigang is telling a story with 10 chapters.
Updated author: New Author
