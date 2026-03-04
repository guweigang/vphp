--TEST--
ZVal each, fold, and reduce helpers cover side-effect and accumulator iteration styles
--SKIPIF--
<?php if (!extension_loaded("vphptest")) print "skip"; ?>
--FILE--
<?php
echo v_iter_helpers_demo([
    'mode' => 'prod',
    'driver' => 'mysql',
    'host' => '127.0.0.1',
]) . PHP_EOL;
?>
--EXPECT--
each=mode=prod,driver=mysql,host=127.0.0.1;fold=mode=prod,driver=mysql,host=127.0.0.1;values=prod,mysql,127.0.0.1;reduce=prod|mysql|127.0.0.1
