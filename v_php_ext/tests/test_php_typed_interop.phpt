--TEST--
typed PHP interop helpers convert ZVal results directly into V values
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
class PhpTypedBox
{
    public const LABEL = 'BOX';
    public static int $count = 21;

    public function __construct(
        public string $name,
        public int $score,
    ) {}

    public function doubleScore(): int
    {
        return $this->score * 2;
    }
}

$box = new PhpTypedBox('Codex', 6);
echo v_typed_php_interop($box) . "\n";
?>
--EXPECT--
typed=5:Codex:12:21:BOX
