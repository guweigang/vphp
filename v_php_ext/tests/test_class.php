<?php
echo "Step 1: Calling Article::create...\n";
$article = Article::create("Hello");
echo "Step 2: Object created, var_dumping...\n";
var_dump($article);
echo "Step 3: Calling method save...\n";
$article->save();
echo "Done.\n";

var_dump($article->title);
