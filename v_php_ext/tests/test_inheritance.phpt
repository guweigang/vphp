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
$article->set_author("Weigang Gu");
var_dump($article->get_author());

echo "\nStep 3: Access inherited properties (if V exposed or via PHP)\n";
$article->post_id = 12345;
var_dump($article->post_id);
--EXPECTF--
Step 1: Check instanceof
bool(true)
bool(true)

Step 2: Use inherited methods
string(10) "Weigang Gu"

Step 3: Access inherited properties (if V exposed or via PHP)
int(12345)
