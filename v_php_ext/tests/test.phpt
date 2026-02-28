--TEST--
test tests
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
echo v_reverse_string("Hello World") . PHP_EOL;
try {
    v_reverse_string("");
} catch (Exception $e) {
    echo "Caught: " . $e->getMessage();
}
--EXPECT--
dlroW olleH
Caught: String is empty!
