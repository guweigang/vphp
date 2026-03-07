--TEST--
VSlim request validation returns 400 for invalid JSON and 413 for oversized body
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlim\App();
$app->post('/x', fn (VSlim\Request $req) => 'ok');

$invalid = new VSlim\Request('POST', '/x', '{bad');
$invalid->set_headers(['content-type' => 'application/json']);
$r1 = $app->dispatch_request($invalid);
echo $r1->status, PHP_EOL;
echo $r1->body, PHP_EOL;

putenv('VSLIM_MAX_BODY_BYTES=4');
$oversized = new VSlim\Request('POST', '/x', '12345');
$oversized->set_headers(['content-type' => 'application/x-www-form-urlencoded']);
$r2 = $app->dispatch_request($oversized);
echo $r2->status, PHP_EOL;
echo $r2->body, PHP_EOL;
?>
--EXPECT--
400
Bad Request: invalid JSON body
413
Payload Too Large
