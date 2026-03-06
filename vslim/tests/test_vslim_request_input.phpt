--TEST--
VSlim Request input helpers merge query and parsed body values
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$req = new VSlim\Request('POST', '/submit?from=query&same=qv', 'from=body&same=bv&n=1');
$req->set_headers(['content-type' => 'application/x-www-form-urlencoded']);
echo $req->input('from') . PHP_EOL;
echo $req->input('same') . PHP_EOL;
echo ($req->has_input('n') ? 'yes' : 'no') . PHP_EOL;
echo $req->input_or('none', 'fallback') . PHP_EOL;
echo $req->parsed_body()['from'] . PHP_EOL;
echo $req->all_inputs()['from'] . '|' . $req->all_inputs()['same'] . PHP_EOL;

$jsonReq = new VSlim\Request('POST', '/json?trace=query', '{"trace":"body","ok":"yes"}');
$jsonReq->set_headers(['content-type' => 'application/json']);
echo $jsonReq->input('trace') . PHP_EOL;
echo $jsonReq->input('ok') . PHP_EOL;
echo $jsonReq->parsed_body()['ok'] . PHP_EOL;
?>
--EXPECT--
body
bv
yes
fallback
body
body|bv
body
yes
yes
