--TEST--
VSlim hook execution order is stable
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlim\App();
$trace = [];

$app->before(function (VSlim\Request $req) use (&$trace) {
    $trace[] = 'app-before';
    return null;
});

$app->after(function (VSlim\Request $req, VSlim\Response $res) use (&$trace) {
    $trace[] = 'app-after';
    return null;
});

$api = $app->group('/api');
$api->before(function (VSlim\Request $req) use (&$trace) {
    $trace[] = 'group-before';
    return null;
});
$api->after(function (VSlim\Request $req, VSlim\Response $res) use (&$trace) {
    $trace[] = 'group-after';
    return null;
});

$api->get('/ping', function (VSlim\Request $req) use (&$trace) {
    $trace[] = 'route';
    return 'pong';
});

$res = $app->dispatch('GET', '/api/ping');
echo $res->status . '|' . $res->body . PHP_EOL;
echo implode('>', $trace) . PHP_EOL;
?>
--EXPECT--
200|pong
app-before>group-before>route>app-after>group-after
