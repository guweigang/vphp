--TEST--
VSlim Config loads TOML and exposes typed/mixed accessors
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$path = sys_get_temp_dir() . '/vslim_config_' . getmypid() . '.toml';
file_put_contents($path, <<<TOML
[app]
name = "demo"
debug = true
port = 19888
ratio = 1.5

[db]
hosts = ["db1", "db2"]
TOML);

$cfg = new VSlim\Config();
$cfg->load($path);

echo ($cfg->is_loaded() ? 'loaded' : 'not-loaded') . PHP_EOL;
echo ($cfg->path() === $path ? 'path-ok' : 'path-bad') . PHP_EOL;
echo ($cfg->has('app.name') ? 'has-name' : 'no-name') . PHP_EOL;
echo $cfg->get_string('app.name', 'x') . PHP_EOL;
echo $cfg->get_int('app.port', 0) . PHP_EOL;
echo ($cfg->get_bool('app.debug', false) ? 'debug-on' : 'debug-off') . PHP_EOL;
echo $cfg->get_float('app.ratio', 0.0) . PHP_EOL;
echo $cfg->get_json('missing.key', '"fallback"') . PHP_EOL;

$hosts = json_decode($cfg->get_json('db.hosts', '[]'), true);
echo count($hosts) . ':' . $hosts[0] . ':' . $hosts[1] . PHP_EOL;

$all = json_decode($cfg->all_json(), true);
echo $all['app']['name'] . ':' . $all['app']['port'] . PHP_EOL;

$name = $cfg->get('app.name');
echo (is_string($name) ? $name : 'bad') . PHP_EOL;

$missing = $cfg->get('missing.key');
echo (is_null($missing) ? 'null' : 'not-null') . PHP_EOL;

$fallback = $cfg->get('missing.key', ['x' => 1]);
echo ($fallback['x'] ?? -1) . PHP_EOL;

$app = $cfg->get_map('app');
echo $app['name'] . ':' . $app['port'] . ':' . ($app['debug'] ? '1' : '0') . PHP_EOL;

$hostList = $cfg->get_list('db.hosts');
echo count($hostList) . ':' . $hostList[0] . ':' . $hostList[1] . PHP_EOL;

$fallbackMap = $cfg->get_map('missing.map', ['d' => 9]);
echo ($fallbackMap['d'] ?? -1) . PHP_EOL;

$fallbackList = $cfg->get_list('missing.list', ['x', 'y']);
echo count($fallbackList) . ':' . $fallbackList[0] . ':' . $fallbackList[1] . PHP_EOL;

$wrongTypeMap = $cfg->get_map('app.name', ['z' => 7]);
echo ($wrongTypeMap['z'] ?? -1) . PHP_EOL;

$wrongTypeList = $cfg->get_list('app.name', ['m']);
echo count($wrongTypeList) . ':' . $wrongTypeList[0] . PHP_EOL;

unlink($path);
?>
--EXPECT--
loaded
path-ok
has-name
demo
19888
debug-on
1.5
"fallback"
2:db1:db2
demo:19888
demo
null
1
demo:19888:1
2:db1:db2
9
2:x:y
7
1:m
