--TEST--
VSlim View escapes template values by default and supports raw output token
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlim\App();
$app->set_view_base_path(__DIR__ . '/fixtures');
$view = $app->make_view();

$payload = '<b>"x"&\'y\'</b>';
$body = $view->render('view_escape.html', ['payload' => $payload]);

echo (str_contains($body, '&lt;b&gt;&quot;x&quot;&amp;&#39;y&#39;&lt;/b&gt;') ? 'safe-ok' : 'safe-miss') . PHP_EOL;
echo (str_contains($body, '<div id="raw"><b>"x"&\'y\'</b></div>') ? 'raw-ok' : 'raw-miss') . PHP_EOL;
?>
--EXPECT--
safe-ok
raw-ok
