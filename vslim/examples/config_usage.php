<?php
declare(strict_types=1);

use VSlim\Config;

$configPath = __DIR__ . '/config_usage.toml';

$cfg = new Config();
$cfg->load($configPath);

echo "== typed ==\n";
echo "app.name: " . $cfg->get_string('app.name', 'n/a') . PHP_EOL;
echo "app.port: " . $cfg->get_int('app.port', 0) . PHP_EOL;
echo "app.debug: " . ($cfg->get_bool('app.debug', false) ? 'true' : 'false') . PHP_EOL;
echo "app.ratio: " . $cfg->get_float('app.ratio', 0.0) . PHP_EOL;

echo "\n== mixed get ==\n";
echo "feature.flags[0]: " . $cfg->get('feature.flags')[0] . PHP_EOL;
echo "missing (null?): " . (is_null($cfg->get('missing.key')) ? 'null' : 'not-null') . PHP_EOL;
echo "missing with default: " . $cfg->get('missing.key', 'fallback') . PHP_EOL;

echo "\n== map/list ==\n";
$db = $cfg->get_map('db');
echo "db.driver: " . ($db['driver'] ?? 'n/a') . PHP_EOL;
echo "db.hosts count: " . count($cfg->get_list('db.hosts')) . PHP_EOL;

$fallbackMap = $cfg->get_map('missing.map', ['driver' => 'sqlite']);
echo "fallback map driver: " . ($fallbackMap['driver'] ?? 'n/a') . PHP_EOL;

$fallbackList = $cfg->get_list('missing.list', ['a', 'b']);
echo "fallback list: " . implode(',', $fallbackList) . PHP_EOL;

echo "\n== json bridge ==\n";
echo "all_json: " . $cfg->all_json() . PHP_EOL;
