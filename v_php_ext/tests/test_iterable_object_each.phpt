--TEST--
ZVal each and fold can traverse PHP Traversable objects
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
class ConfigBag implements IteratorAggregate
{
    public function __construct(private array $items) {}

    public function getIterator(): Traversable
    {
        return new ArrayIterator($this->items);
    }
}

$bag = new ConfigBag([
    'mode' => 'prod',
    'driver' => 'mysql',
    'host' => '127.0.0.1',
]);

echo v_iterable_object_demo($bag) . PHP_EOL;
?>
--EXPECT--
each=mode=prod,driver=mysql,host=127.0.0.1;fold=mode=prod,driver=mysql,host=127.0.0.1;count=3
