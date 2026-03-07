--TEST--
VSlim View supports dot-path lookup for nested map/object values
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlim\App();
$app->set_view_base_path(__DIR__ . '/fixtures');
$view = $app->make_view();

$meta = new stdClass();
$meta->enabled = true;
$meta->profile = ['title' => 'Engineer'];

$body = $view->render('view_dot_path.html', [
    'user' => [
        'name' => 'neo',
        'active' => true,
        'tags' => ['go', '<b>x</b>'],
    ],
    'meta' => $meta,
    'rows' => [
        ['name' => 'r0'],
        ['name' => 'r1'],
    ],
]);

echo (str_contains($body, '<h1>neo</h1>') ? 'name-ok' : 'name-miss') . PHP_EOL;
echo (str_contains($body, '<p>ACTIVE</p>') ? 'if-ok' : 'if-miss') . PHP_EOL;
echo (str_contains($body, '<li>go</li>') ? 'for-ok' : 'for-miss') . PHP_EOL;
echo (str_contains($body, '<li>&lt;b&gt;x&lt;/b&gt;</li>') ? 'for-escape-ok' : 'for-escape-miss') . PHP_EOL;
echo (str_contains($body, '<div>Engineer</div>') ? 'object-ok' : 'object-miss') . PHP_EOL;
echo (str_contains($body, '<div class="row0">r0</div>') ? 'index-bracket-ok' : 'index-bracket-miss') . PHP_EOL;
echo (str_contains($body, '<div class="row1">r1</div>') ? 'index-dot-ok' : 'index-dot-miss') . PHP_EOL;
echo (str_contains($body, '<li>r0</li><li>r1</li>') ? 'for-item-dot-if-ok' : 'for-item-dot-if-miss') . PHP_EOL;
echo (str_contains($body, '<span>ENABLED</span>') ? 'bool-ok' : 'bool-miss') . PHP_EOL;
?>
--EXPECT--
name-ok
if-ok
for-ok
for-escape-ok
object-ok
index-bracket-ok
index-dot-ok
for-item-dot-if-ok
bool-ok
