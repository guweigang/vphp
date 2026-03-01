<?php
$author = Author::create("Gu Weigang");
echo "1: " . $author->get_name() . " (hash: " . spl_object_hash($author) . ")\n";
$article = Article::create("VPHP is awesome");
$article->set_author($author);
echo "2: " . $author->get_name() . "\n";
$ret_author = $article->get_author();
echo "3: " . (($ret_author === null) ? "NULL" : $ret_author->get_name()) . " (hash: " . spl_object_hash($ret_author) . ")\n";
