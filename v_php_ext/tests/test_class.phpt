--TEST--
test_class tests
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
echo "Step 1: Calling Article::create...\n";
$article = Article::create("Hello");
echo "Step 2: Object created, var_dumping...\n";
var_dump($article);
echo "Step 3: Calling method save...\n";
$article->save();
echo "Done.\n";

echo "\nStep 4: Accessing property from PHP...\n";
var_dump($article->title);

echo "\nStep 5: Modifying property from PHP...\n";
$article->title = "Updated in PHP";
$article->is_top = false;
$article->save(); // 观察 V 侧打印的结果

echo "\nStep 6: new class from PHP...\n";
$b = new Article("Weigang", 1234);
var_dump($b);
$b->save();

echo "\nStep 7: Call is_top from PHP...\n";
$c = new Article("is_top_test", 1234567);
var_dump($c->is_top());
$c->is_top = false;
var_dump($c->is_top());
$b->save();
--EXPECT--
Step 1: Calling Article::create...
Step 2: Object created, var_dumping...
object(Article)#1 (3) {
  ["id"]=>
  int(1024)
  ["title"]=>
  string(5) "Hello"
  ["is_top"]=>
  bool(true)
}
Step 3: Calling method save...
Done.
Saving article: Hello

Step 4: Accessing property from PHP...
string(5) "Hello"

Step 5: Modifying property from PHP...

Step 6: new class from PHP...
Saving article: Updated in PHP
object(Article)#2 (3) {
V Article initialized with title: Weigang
  ["id"]=>
  int(1234)
  ["title"]=>
  string(7) "Weigang"
  ["is_top"]=>
  bool(true)
}

Step 7: Call is_top from PHP...
Saving article: Weigang
bool(true)
V Article initialized with title: is_top_test
bool(false)
Saving article: Weigang
