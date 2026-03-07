--TEST--
VSlim MVC View and Controller helpers render templates and asset URLs
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlim\App();
$app->set_view_base_path(__DIR__ . '/fixtures');
$app->set_assets_prefix('/assets');

$res = $app->view('view_home.html', [
    'title' => 'VSlim MVC Demo',
    'name' => 'neo',
    'trace' => 'trace-1',
]);
echo $res->status . '|' . $res->content_type . '|' . (str_contains($res->body, '/assets/app.js') ? 'asset-ok' : 'asset-miss') . PHP_EOL;
echo (str_contains($res->body, 'VSlim MVC Demo|neo|trace-1') ? 'body-ok' : 'body-miss') . PHP_EOL;

$view = new VSlim\View(__DIR__ . '/fixtures', '/assets');
echo $view->asset('app.js') . PHP_EOL;

final class TestPageController extends VSlim\Controller {
    public function page(): VSlim\Response {
        return $this->render('view_home.html', [
            'title' => 'controller-title',
            'name' => 'ada',
            'trace' => 'trace-2',
        ]);
    }
}

$controller = new TestPageController($app);
$res2 = $controller->page();
echo $res2->status . '|' . (str_contains($res2->body, 'controller-title|ada|trace-2') ? 'controller-ok' : 'controller-miss') . PHP_EOL;
?>
--EXPECT--
200|text/html; charset=utf-8|asset-ok
body-ok
/assets/app.js
200|controller-ok
