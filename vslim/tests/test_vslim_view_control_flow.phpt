--TEST--
VSlim View supports simple if/else and for control flow tokens
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlim\App();
$tmpDir = sys_get_temp_dir() . '/vslim_view_cf_' . uniqid('', true);
@mkdir($tmpDir, 0777, true);
$tpl = <<<'HTML'
{{if:show_title}}<h1>{{ title }}</h1>{{/if}}
{{if:show_desc}}<p>{{ desc }}</p>{{else}}<p>NO-DESC</p>{{/if}}
<ul>
{{for:tags}}<li data-i="{{index}}">{{item}}</li>{{/for}}
</ul>
<p id="trim">{{trim:title_spaced}}</p>
<p id="first">{{first:tags}}</p>
<p id="last">{{last:tags}}</p>
<p id="join">{{join:tags| + }}</p>
<p id="reduce-sum">{{reduce:scores|sum}}</p>
<p id="reduce-count">{{reduce:scores|count}}</p>
<p id="reduce-seed">{{reduce:scores|acc+item|10}}</p>
<p id="reduce-expr">{{reduce:scores|acc*2+item|1}}</p>
HTML;
file_put_contents($tmpDir . '/view_control_flow.inline.html', $tpl);
$app->set_view_base_path($tmpDir);
$view = $app->make_view();

$body = $view->render('view_control_flow.inline.html', [
    'show_title' => '1',
    'show_desc' => '0',
    'title' => 'Hello',
    'title_spaced' => '  Hello  ',
    'desc' => 'Should not render',
    'tags' => ['go', '<b>x</b>', 'php'],
    'scores' => ['1', '2', '3'],
]);

echo (str_contains($body, '<h1>Hello</h1>') ? 'if-ok' : 'if-miss') . PHP_EOL;
echo (str_contains($body, '<p>NO-DESC</p>') ? 'else-ok' : 'else-miss') . PHP_EOL;
echo (str_contains($body, '<li data-i="0">go</li>') ? 'for-0-ok' : 'for-0-miss') . PHP_EOL;
echo (str_contains($body, '<li data-i="1">&lt;b&gt;x&lt;/b&gt;</li>') ? 'for-escape-ok' : 'for-escape-miss') . PHP_EOL;
echo (str_contains($body, '<p id="trim">Hello</p>') ? 'trim-ok' : 'trim-miss') . PHP_EOL;
echo (str_contains($body, '<p id="first">go</p>') ? 'first-ok' : 'first-miss') . PHP_EOL;
echo (str_contains($body, '<p id="last">php</p>') ? 'last-ok' : 'last-miss') . PHP_EOL;
$joinOk = str_contains($body, '<p id="join">go + ')
    && str_contains($body, '&lt;b&gt;x&lt;/b&gt;')
    && str_contains($body, ' + php</p>');
echo ($joinOk ? 'join-ok' : 'join-miss') . PHP_EOL;
echo (str_contains($body, '<p id="reduce-sum">6</p>') ? 'reduce-sum-ok' : 'reduce-sum-miss') . PHP_EOL;
echo (str_contains($body, '<p id="reduce-count">3</p>') ? 'reduce-count-ok' : 'reduce-count-miss') . PHP_EOL;
echo (str_contains($body, '<p id="reduce-seed">16</p>') ? 'reduce-seed-ok' : 'reduce-seed-miss') . PHP_EOL;
echo (str_contains($body, '<p id="reduce-expr">19</p>') ? 'reduce-expr-ok' : 'reduce-expr-miss') . PHP_EOL;
@unlink($tmpDir . '/view_control_flow.inline.html');
@rmdir($tmpDir);
?>
--EXPECT--
if-ok
else-ok
for-0-ok
for-escape-ok
trim-ok
first-ok
last-ok
join-ok
reduce-sum-ok
reduce-count-ok
reduce-seed-ok
reduce-expr-ok
