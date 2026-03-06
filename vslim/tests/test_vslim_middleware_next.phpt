--TEST--
VSlim middleware requires response return and supports next-chain style
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlim\App();
$app->middleware(function (VSlim\Request $req, callable $next) {
    if ($req->path === '/stop') {
        return 'stopped';
    }
    $res = $next($req);
    $res->set_header('x-chain', 'm1');
    return $res;
});
$app->middleware(function (VSlim\Request $req, callable $next) {
    if ($req->path === '/null-invalid') {
        return null;
    }
    $res = $next($req);
    return new VSlim\Response($res->status, $res->body . '|m2', $res->content_type);
});
$app->get('/ok', function (VSlim\Request $req) {
    return 'route';
});
$app->get('/stop', function (VSlim\Request $req) {
    return 'route-stop';
});

$ok = $app->dispatch('GET', '/ok');
echo $ok->status . '|' . $ok->body . '|' . $ok->header('x-chain') . PHP_EOL;
$stop = $app->dispatch('GET', '/stop');
echo $stop->status . '|' . $stop->body . PHP_EOL;

$app2 = new VSlim\App();
$app2->middleware(function (VSlim\Request $req, callable $next) {
    return null;
});
$app2->get('/null-invalid', function (VSlim\Request $req) {
    return 'null-ok';
});
$nullPass = $app2->dispatch('GET', '/null-invalid');
echo $nullPass->status . '|' . $nullPass->body . PHP_EOL;
?>
--EXPECT--
200|route|m2|m1
200|stopped
500|Middleware must return a response
