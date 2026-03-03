--TEST--
php_class interop constructs PHP objects
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
class PhpGreeter
{
    public string $name;

    public function __construct(string $name)
    {
        $this->name = $name;
    }

    public function greet(): string
    {
        return "Hello {$this->name}";
    }
}

echo v_construct_php_object() . "\n";
?>
--EXPECT--
constructed=Codex:Hello Codex
