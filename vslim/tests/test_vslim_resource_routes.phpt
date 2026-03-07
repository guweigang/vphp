--TEST--
VSlim resource and api_resource register RESTful routes
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
final class ResourceDemoController {
    public function index(VSlim\Request $req): string { return 'index'; }
    public function show(VSlim\Request $req): string { return 'show:' . $req->param('id'); }
    public function store(VSlim\Request $req): string { return 'store'; }
    public function update(VSlim\Request $req): string { return 'update:' . $req->param('id'); }
    public function destroy(VSlim\Request $req): string { return 'destroy:' . $req->param('id'); }
    public function create(VSlim\Request $req): string { return 'create'; }
    public function edit(VSlim\Request $req): string { return 'edit:' . $req->param('id'); }
}

$app = new VSlim\App();
$app->container()->set(ResourceDemoController::class, new ResourceDemoController());
$app->resource('/items', ResourceDemoController::class);
$app->api_resource('/api/items', ResourceDemoController::class);

echo $app->dispatch('GET', '/items')->body . PHP_EOL;
echo $app->dispatch('GET', '/items/create')->body . PHP_EOL;
echo $app->dispatch('POST', '/items')->body . PHP_EOL;
echo $app->dispatch('GET', '/items/7')->body . PHP_EOL;
echo $app->dispatch('GET', '/items/7/edit')->body . PHP_EOL;
echo $app->dispatch('PUT', '/items/7')->body . PHP_EOL;
echo $app->dispatch('DELETE', '/items/7')->body . PHP_EOL;

echo $app->dispatch('GET', '/api/items')->body . PHP_EOL;
echo $app->dispatch('GET', '/api/items/create')->body . PHP_EOL;
echo $app->dispatch('GET', '/api/items/8/edit')->status . PHP_EOL;
?>
--EXPECT--
index
create
store
show:7
edit:7
update:7
destroy:7
index
show:create
404
