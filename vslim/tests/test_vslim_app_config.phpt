--TEST--
VSlim App integrates shared Config instance
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = VSlim\App::demo();
echo ($app->has_config() ? 'has' : 'no') . PHP_EOL;

$app->load_config_text(<<<TOML
[app]
name = "demo"
port = 19888
debug = true

[db]
hosts = ["a", "b"]
TOML);

echo ($app->has_config() ? 'has' : 'no') . PHP_EOL;

$cfg = $app->config();
echo $cfg->get_string('app.name', 'x') . PHP_EOL;
echo $cfg->get_int('app.port', 0) . PHP_EOL;
echo ($cfg->get_bool('app.debug', false) ? 'debug-on' : 'debug-off') . PHP_EOL;
$hosts = $cfg->get_list('db.hosts');
echo count($hosts) . ':' . $hosts[0] . ':' . $hosts[1] . PHP_EOL;

$cfgFromContainer = $app->container()->get('config');
echo get_class($cfgFromContainer) . PHP_EOL;
echo $cfgFromContainer->get_string('app.name', 'x') . PHP_EOL;
?>
--EXPECT--
no
has
demo
19888
debug-on
2:a:b
VSlim\Config
demo
