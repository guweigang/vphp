--TEST--
VSlim typed wrapper chain keeps middleware, error, and not_found flows working together
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlim\App();

$app->middleware(function (VSlim\Request $req, callable $next) {
    $res = $next($req);
    $res->set_header('x-chain', 'mw');
    return $res;
});

$app->set_not_found_handler(function (VSlim\Request $req) {
    return [
        'status' => 404,
        'body' => 'nf:' . $req->path,
    ];
});

$app->set_error_handler(function (VSlim\Request $req, string $message, int $status) {
    return [
        'status' => $status,
        'body' => 'err:' . $message,
    ];
});

$app->get('/ok', function (VSlim\Request $req) {
    return 'ok';
});

$app->get('/bad', function (VSlim\Request $req) {
    return 123;
});

$ok = $app->dispatch('GET', '/ok');
echo $ok->status . '|' . $ok->body . '|' . $ok->header('x-chain') . PHP_EOL;

$bad = $app->dispatch('GET', '/bad');
echo $bad->status . '|' . $bad->body . '|' . $bad->header('x-chain') . PHP_EOL;

$missing = $app->dispatch('GET', '/missing');
echo $missing->status . '|' . $missing->body . '|' . $missing->header('x-chain') . PHP_EOL;
?>
--EXPECTF--
200|ok|mw
500|err:Invalid route response|mw
404|nf:/missing|mw
%A
