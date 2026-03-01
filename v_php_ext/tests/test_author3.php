<?php
$author = Author::create("Gu Weigang");
$article = Article::create("VPHP is awesome");
$article->set_author($author);

$ret_author = $article->get_author();
echo "Get name from Original: " . $author->get_name() . "\n";
echo "Get name from Returned: " . $ret_author->get_name() . "\n";
