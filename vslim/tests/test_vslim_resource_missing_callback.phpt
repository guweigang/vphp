--TEST--
VSlim resource_opts missing callback handles null action results
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
final class MissingModelController {
    public function show(VSlim\Request $req) {
        if ($req->param('id') === '42') {
            return null;
        }
        return 'show:' . $req->param('id');
    }
}

$app = new VSlim\App();
$app->container()->set(MissingModelController::class, new MissingModelController());
$app->resource_opts('/users', MissingModelController::class, [
    'only' => ['show'],
    'missing' => function (VSlim\Request $req, string $action, array $params) {
        return new VSlim\Response(
            404,
            'missing:' . $action . ':' . ($params['id'] ?? ''),
            'text/plain; charset=utf-8'
        );
    },
]);

echo $app->dispatch('GET', '/users/7')->body . PHP_EOL;
$res = $app->dispatch('GET', '/users/42');
echo $res->status . '|' . $res->body . PHP_EOL;
?>
--EXPECT--
show:7
404|missing:show:42
