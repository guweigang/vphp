--TEST--
Unified typed object interop helpers keep call/construct/static/const semantics consistent
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
class PhpUnifiedBox {
    public const LABEL = 'UNIFIED';
    public string $name;
    public int $score;

    public function __construct(string $name, int $score) {
        $this->name = $name;
        $this->score = $score;
    }

    public function doubleScore(): int {
        return $this->score * 2;
    }

    public static function triple(int $x): int {
        return $x * 3;
    }
}

echo v_unified_object_interop() . PHP_EOL;
?>
--EXPECT--
interop=neo:42:12:UNIFIED:NEO
