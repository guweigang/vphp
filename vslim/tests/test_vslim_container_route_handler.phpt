--TEST--
VSlim route handlers can be resolved from VSlim\Container by service id
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
class VslimTestAutoController {
    public function __invoke(VSlim\Request $req): string {
        return 'auto:' . $req->param('id');
    }
    public function show(VSlim\Request $req): string {
        return 'auto-show:' . $req->param('id');
    }
}

$app = new VSlim\App();
$container = $app->container();

$container->set('hello.handler', function (VSlim\Request $req) {
    return 'hello:' . $req->param('id');
});
$container->factory('json.handler', function () {
    return function (VSlim\Request $req) {
        return [
            'status' => 200,
            'content_type' => 'application/json; charset=utf-8',
            'body' => json_encode([
                'id' => $req->param('id'),
                'method' => $req->method,
            ]),
        ];
    };
});
$container->set('users.controller', new class {
    public function show(VSlim\Request $req): string {
        return 'ctrl:' . $req->param('id');
    }
});
$container->set('invoke.controller', new class {
    public function __invoke(VSlim\Request $req): string {
        return 'inv:' . $req->param('id');
    }
});

$app->set_error_handler(function (VSlim\Request $req, string $message, int $status) {
    return [
        'status' => $status,
        'content_type' => 'text/plain; charset=utf-8',
        'body' => "ERR:$status:$message",
    ];
});

$app->get('/hello/:id', 'hello.handler');
$app->get('/json/:id', 'json.handler');
$app->get('/ctrl/:id', ['users.controller', 'show']);
$app->get('/inv/:id', 'invoke.controller');
$app->get('/inv2/:id', ['invoke.controller']);
$app->get('/auto/:id', 'VslimTestAutoController');
$app->get('/auto-show/:id', ['VslimTestAutoController', 'show']);
$app->get('/bad-method/:id', ['users.controller', 'missing']);
$app->get('/missing/:id', 'missing.handler');

echo $app->dispatch('GET', '/hello/7')->status . '|' . $app->dispatch('GET', '/hello/7')->body . PHP_EOL;
echo $app->dispatch('GET', '/json/8')->status . '|' . $app->dispatch('GET', '/json/8')->body . PHP_EOL;
echo $app->dispatch('GET', '/ctrl/11')->status . '|' . $app->dispatch('GET', '/ctrl/11')->body . PHP_EOL;
echo $app->dispatch('GET', '/inv/12')->status . '|' . $app->dispatch('GET', '/inv/12')->body . PHP_EOL;
echo $app->dispatch('GET', '/inv2/13')->status . '|' . $app->dispatch('GET', '/inv2/13')->body . PHP_EOL;
echo $app->dispatch('GET', '/auto/20')->status . '|' . $app->dispatch('GET', '/auto/20')->body . PHP_EOL;
echo $app->dispatch('GET', '/auto-show/21')->status . '|' . $app->dispatch('GET', '/auto-show/21')->body . PHP_EOL;
echo $app->dispatch('GET', '/bad-method/14')->status . '|' . $app->dispatch('GET', '/bad-method/14')->body . PHP_EOL;
echo $app->dispatch('GET', '/missing/15')->status . '|' . $app->dispatch('GET', '/missing/15')->body . PHP_EOL;
?>
--EXPECT--
200|hello:7
200|{"id":"8","method":"GET"}
200|ctrl:11
200|inv:12
200|inv:13
200|auto:20
200|auto-show:21
500|ERR:500:Container service "users.controller" has no method "missing"
500|ERR:500:Container service "missing.handler" not found
