--TEST--
VSlim lifecycle hooks document response and error semantics
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlimApp();
$app->get('/hello', function (VSlimRequest $req) {
    return 'route';
});
$app->get('/bad-route', function (VSlimRequest $req) {
    return 123;
});
$app->get('/bad-after', function (VSlimRequest $req) {
    return 'base-after';
});
$app->get('/throw-after', function (VSlimRequest $req) {
    return 'base-throw-after';
});
$app->get('/throw-route', function (VSlimRequest $req) {
    throw new RuntimeException('route-failed');
});
$app->before(function (VSlimRequest $req) {
    if ($req->path === '/short') {
        return [
            'status' => 202,
            'content_type' => 'text/plain; charset=utf-8',
            'body' => 'shorted',
        ];
    }
    if ($req->path === '/throw-before') {
        throw new RuntimeException('before-failed');
    }
    return null;
});
$app->after(function (VSlimRequest $req, VSlimResponse $res) {
    if ($req->path === '/hello') {
        return 'after:' . $res->body;
    }
    if ($req->path === '/bad-after') {
        return 123;
    }
    if ($req->path === '/throw-after') {
        throw new RuntimeException('after-failed');
    }
    return null;
});

echo $app->dispatch('GET', '/hello')->status . '|' . $app->dispatch('GET', '/hello')->body . PHP_EOL;
echo $app->dispatch('GET', '/short')->status . '|' . $app->dispatch('GET', '/short')->body . PHP_EOL;
echo $app->dispatch('GET', '/bad-route')->status . '|' . $app->dispatch('GET', '/bad-route')->body . PHP_EOL;
echo $app->dispatch('GET', '/bad-after')->status . '|' . $app->dispatch('GET', '/bad-after')->body . PHP_EOL;

try {
    $app->dispatch('GET', '/throw-before');
    echo "before-no-throw\n";
} catch (Throwable $e) {
    echo get_class($e) . '|' . $e->getMessage() . PHP_EOL;
}

try {
    $app->dispatch('GET', '/throw-route');
    echo "route-no-throw\n";
} catch (Throwable $e) {
    echo get_class($e) . '|' . $e->getMessage() . PHP_EOL;
}

try {
    $app->dispatch('GET', '/throw-after');
    echo "after-no-throw\n";
} catch (Throwable $e) {
    echo get_class($e) . '|' . $e->getMessage() . PHP_EOL;
}
?>
--EXPECT--
200|after:route
202|shorted
500|Invalid route response
500|Invalid route response
RuntimeException|before-failed
RuntimeException|route-failed
RuntimeException|after-failed
