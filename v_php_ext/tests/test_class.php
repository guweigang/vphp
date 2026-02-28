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
