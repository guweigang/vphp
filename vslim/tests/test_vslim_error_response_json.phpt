--TEST--
VSlim App can switch default error responses to JSON
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlim\App();
$app->set_error_response_json(true);
var_dump($app->error_response_json_enabled());

$res1 = $app->dispatch('GET', '/missing');
echo $res1->status . '|' . $res1->content_type . '|' . $res1->body . PHP_EOL;

$app->get('/broken', function () {
    return fopen('php://memory', 'r');
});
$res2 = $app->dispatch('GET', '/broken');
echo $res2->status . '|' . $res2->content_type . '|' . $res2->body . PHP_EOL;
?>
--EXPECT--
bool(true)
404|application/json; charset=utf-8|{"ok":false,"code":"not_found","error":"not_found","status":404,"message":"Not Found"}
500|application/json; charset=utf-8|{"ok":false,"code":"invalid_response","error":"invalid_response","status":500,"message":"Invalid route response"}
