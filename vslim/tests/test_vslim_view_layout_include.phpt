--TEST--
VSlim View supports include partials and layout slots
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlim\App();
$app->set_view_base_path(__DIR__ . '/fixtures');
$app->set_assets_prefix('/assets');

$view = $app->make_view();
$body = $view->render_with_layout('view_home.html', 'view_layout.html', [
    'title' => 'Layout Demo',
    'subtitle' => 'Header-OK',
    'name' => 'neo',
    'trace' => 'trace-l1',
]);
echo (str_contains($body, '<header>Header-OK</header>') ? 'header-ok' : 'header-miss') . PHP_EOL;
echo (str_contains($body, 'Layout Demo|neo|trace-l1') ? 'content-ok' : 'content-miss') . PHP_EOL;
echo (str_contains($body, '<main>') ? 'slot-ok' : 'slot-miss') . PHP_EOL;

$res = $app->view_with_layout('view_home.html', 'view_layout.html', [
    'title' => 'Layout Demo 2',
    'subtitle' => 'Header-2',
    'name' => 'ada',
    'trace' => 'trace-l2',
]);
echo $res->status . '|' . (str_contains($res->body, 'Header-2') ? 'res-ok' : 'res-miss') . PHP_EOL;

final class LayoutController extends VSlim\Controller {
    public function page(): VSlim\Response {
        return $this->render_with_layout('view_home.html', 'view_layout.html', [
            'title' => 'Controller Layout',
            'subtitle' => 'Header-C',
            'name' => 'mia',
            'trace' => 'trace-l3',
        ]);
    }
}
$controller = new LayoutController($app);
$res2 = $controller->page();
echo $res2->status . '|' . (str_contains($res2->body, 'Header-C') ? 'controller-ok' : 'controller-miss') . PHP_EOL;
?>
--EXPECT--
header-ok
content-ok
slot-ok
200|res-ok
200|controller-ok
