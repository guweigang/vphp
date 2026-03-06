--TEST--
VSlim\App exposes built-in container lifecycle APIs
--SKIPIF--
<?php
if (!extension_loaded('vslim')) {
    echo "skip vslim extension missing";
    return;
}
if (!interface_exists('Psr\\Container\\ContainerInterface')) {
    echo "skip psr extension missing";
    return;
}
?>
--FILE--
<?php
$app = new VSlim\App();
var_dump($app->has_container());

$c1 = $app->container();
var_dump($app->has_container());
var_dump($c1 instanceof Psr\Container\ContainerInterface);

$c1->set('name', 'codex');
$c2 = $app->container();
echo $c2->get('name') . PHP_EOL;
echo ($c1 === $c2 ? 'same' : 'different') . PHP_EOL;

$external = new VSlim\Container();
$external->set('from_external', 'ok');
$app->set_container($external);
echo $app->container()->get('from_external') . PHP_EOL;
?>
--EXPECTF--
bool(false)
bool(true)
bool(true)
codex
same
ok
