--TEST--
VSlim demo app dispatches routes through the extension
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = VSlimApp::demo();
$res = $app->dispatch('GET', '/health');
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;

$res = $app->dispatch('GET', '/users/42');
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;

$res = $app->dispatch('POST', '/health');
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;

$res = $app->dispatch('GET', '/missing');
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;

$res = $app->dispatch('GET', '/private');
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;

$res = $app->dispatch('GET', '/private?token=ok');
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;

$res = $app->dispatch('GET', '/panic');
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;

$meta = vslim_demo_dispatch('GET', '/meta');
echo $meta['status'] . '|' . $meta['body'] . '|' . $meta['content_type'] . PHP_EOL;
?>
--EXPECT--
200|OK|text/plain; charset=utf-8
200|{"user":"42","trace":"trace-local-mvp"}|application/json; charset=utf-8
405|Method Not Allowed|text/plain; charset=utf-8
404|Not Found|text/plain; charset=utf-8
401|Unauthorized|text/plain; charset=utf-8
200|secret|text/plain; charset=utf-8
500|Internal Server Error|text/plain; charset=utf-8
200|{"runtime":"vslim","bridge":"vphp","server":"vhttpd","trace":"trace-local-mvp"}|application/json; charset=utf-8
