--TEST--
VSlim View supports simple if/else and for control flow tokens
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlim\App();
$app->set_view_base_path(__DIR__ . '/fixtures');
$view = $app->make_view();

$body = $view->render('view_control_flow.html', [
    'show_title' => '1',
    'show_desc' => '0',
    'title' => 'Hello',
    'desc' => 'Should not render',
    'tags' => 'go,<b>x</b>,php',
]);

echo (str_contains($body, '<h1>Hello</h1>') ? 'if-ok' : 'if-miss') . PHP_EOL;
echo (str_contains($body, '<p>NO-DESC</p>') ? 'else-ok' : 'else-miss') . PHP_EOL;
echo (str_contains($body, '<li data-i="0">go</li>') ? 'for-0-ok' : 'for-0-miss') . PHP_EOL;
echo (str_contains($body, '<li data-i="1">&lt;b&gt;x&lt;/b&gt;</li>') ? 'for-escape-ok' : 'for-escape-miss') . PHP_EOL;
?>
--EXPECT--
if-ok
else-ok
for-0-ok
for-escape-ok
