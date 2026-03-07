--TEST--
VSlim route metadata helpers expose route names and allowed methods
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlim\App();
$app->get('/health', function (VSlim\Request $req) { return 'ok'; });
$app->post('/users', function (VSlim\Request $req) { return 'create'; });
$app->put_named('users.update', '/users/:id', function (VSlim\Request $req) { return 'u'; });
$app->delete_named('users.delete', '/users/:id', function (VSlim\Request $req) { return 'd'; });
$app->any_named('echo.any', '/echo/:id', function (VSlim\Request $req) { return 'e'; });
$app->get_named('health.dup', '/health', function (VSlim\Request $req) { return 'dup'; });

echo $app->route_count() . PHP_EOL;
echo implode(',', $app->route_names()) . PHP_EOL;
var_dump($app->has_route_name('users.update'));
var_dump($app->has_route_name('missing'));
echo implode(',', $app->allowed_methods_for('/users/7')) . PHP_EOL;
echo implode(',', $app->allowed_methods_for('/echo/9')) . PHP_EOL;
echo implode(',', $app->allowed_methods_for('/none')) . PHP_EOL;
echo $app->route_manifest_lines()[0] . PHP_EOL;
echo $app->route_conflict_keys()[0] . PHP_EOL;
$manifest = $app->route_manifest();
echo $manifest[0]['method'] . ' ' . $manifest[0]['pattern'] . PHP_EOL;
$conflicts = $app->route_conflicts();
echo count($conflicts) . '|' . $conflicts[0]['method'] . '|' . $conflicts[0]['pattern'] . '|' . $conflicts[0]['count'] . PHP_EOL;
?>
--EXPECT--
6
users.update,users.delete,echo.any,health.dup
bool(true)
bool(false)
PUT,DELETE,OPTIONS
GET,HEAD,POST,PUT,PATCH,DELETE,OPTIONS

GET /health
GET /health x2
GET /health
1|GET|/health|2
