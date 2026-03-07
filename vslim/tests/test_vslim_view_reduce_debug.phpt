--TEST--
VSlim View reduce shows debug error details when VSLIM_VIEW_DEBUG is enabled
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
putenv('VSLIM_VIEW_DEBUG=1');
$app = new VSlim\App();
$tmpDir = sys_get_temp_dir() . '/vslim_view_reduce_dbg_' . uniqid('', true);
@mkdir($tmpDir, 0777, true);

$tpl = <<<'HTML'
<p id="ok">{{reduce:scores|acc+item|0}}</p>
<p id="bad">{{reduce:scores|acc+*item|0}}</p>
HTML;
file_put_contents($tmpDir . '/reduce_debug.html', $tpl);
$app->set_view_base_path($tmpDir);
$view = $app->make_view();

$body = $view->render('reduce_debug.html', ['scores' => ['1', '2', '3']]);
echo (str_contains($body, '<p id="ok">6</p>') ? 'ok-reduce' : 'bad-reduce') . PHP_EOL;
echo (str_contains($body, 'vslim.reduce.error') ? 'debug-error-shown' : 'debug-error-miss') . PHP_EOL;

@unlink($tmpDir . '/reduce_debug.html');
@rmdir($tmpDir);
putenv('VSLIM_VIEW_DEBUG');
?>
--EXPECT--
ok-reduce
debug-error-shown
