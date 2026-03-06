--TEST--
VSlim container is implemented in vslim.so and implements PSR-11 via psr extension
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
$c = new VSlim\Container();
var_dump($c instanceof Psr\Container\ContainerInterface);

$c->set('name', 'codex');
$c->factory('hello', fn () => 'hi-' . $c->get('name'));
echo $c->get('name') . PHP_EOL;
echo $c->get('hello') . PHP_EOL;
var_dump($c->has('name'));
var_dump($c->has('missing'));

try {
    $c->get('missing');
    echo "missing_not_thrown\n";
} catch (VSlim\Container\NotFoundException $e) {
    echo "not_found_class\n";
    var_dump($e instanceof Psr\Container\NotFoundExceptionInterface);
}
?>
--EXPECT--
bool(true)
codex
hi-codex
bool(true)
bool(false)
not_found_class
bool(true)
