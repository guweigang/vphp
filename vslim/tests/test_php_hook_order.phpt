--TEST--
VSlim hook execution order is stable
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlimApp();
$trace = [];

$app->before(function (VSlimRequest $req) use (&$trace) {
    $trace[] = 'app-before';
    return null;
});

$app->after(function (VSlimRequest $req, VSlimResponse $res) use (&$trace) {
    $trace[] = 'app-after';
    return null;
});

$api = $app->group('/api');
$api->before(function (VSlimRequest $req) use (&$trace) {
    $trace[] = 'group-before';
    return null;
});
$api->after(function (VSlimRequest $req, VSlimResponse $res) use (&$trace) {
    $trace[] = 'group-after';
    return null;
});

$api->get('/ping', function (VSlimRequest $req) use (&$trace) {
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
