--TEST--
VSlim demo app dispatches routes through the extension
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = VSlimApp::demo();
$res = $app->dispatch('GET', '/hello/codex');
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;

echo (string)$res . PHP_EOL;

$meta = vslim_demo_dispatch('GET', '/meta');
echo $meta['status'] . '|' . $meta['body'] . '|' . $meta['content_type'] . PHP_EOL;
?>
--EXPECT--
200|Hello, codex|text/plain; charset=utf-8
200 text/plain; charset=utf-8 Hello, codex
200|{"runtime":"vslim","bridge":"vphp","server":"vhttpd"}|application/json; charset=utf-8
