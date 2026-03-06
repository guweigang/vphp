--TEST--
VSlim map and map_named register one handler for multiple methods
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlim\App();
$app->map(['GET', 'POST'], '/multi/:id', function (VSlim\Request $req) {
    return $req->method . ':' . $req->param('id');
});
$app->map('PUT|PATCH', '/edit/:id', function (VSlim\Request $req) {
    return $req->method . ':' . $req->param('id');
});
$app->map_named(['DELETE', 'OPTIONS'], 'api.remove', '/api/items/:id', function (VSlim\Request $req) {
    return $req->method . ':' . $req->param('id');
});
$group = $app->group('/v1');
$group->map(['GET', 'HEAD'], '/ping', function (VSlim\Request $req) {
    return 'pong:' . $req->method;
});

echo $app->dispatch('GET', '/multi/7')->body . PHP_EOL;
echo $app->dispatch('POST', '/multi/7')->body . PHP_EOL;
echo $app->dispatch('PUT', '/edit/8')->body . PHP_EOL;
echo $app->dispatch('PATCH', '/edit/8')->body . PHP_EOL;
echo $app->dispatch('DELETE', '/api/items/9')->body . PHP_EOL;
echo $app->dispatch('OPTIONS', '/api/items/9')->body . PHP_EOL;
echo $app->dispatch('GET', '/v1/ping')->body . PHP_EOL;
echo $app->dispatch('HEAD', '/v1/ping')->status . '|' . strlen($app->dispatch('HEAD', '/v1/ping')->body) . PHP_EOL;
echo $app->url_for('api.remove', ['id' => '99']) . PHP_EOL;
?>
--EXPECT--
GET:7
POST:7
PUT:8
PATCH:8
DELETE:9
OPTIONS:9
pong:GET
200|0
/api/items/99
