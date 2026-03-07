--TEST--
VSlim resource_opts supports only/except and custom route names
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
final class ResourceOptsController {
    public function index(VSlim\Request $req): string { return 'index'; }
    public function show(VSlim\Request $req): string { return 'show:' . $req->param('book_id'); }
    public function store(VSlim\Request $req): string { return 'store'; }
    public function update(VSlim\Request $req): string { return 'update:' . $req->param('book_id'); }
    public function destroy(VSlim\Request $req): string { return 'destroy:' . $req->param('book_id'); }
}

$app = new VSlim\App();
$app->container()->set(ResourceOptsController::class, new ResourceOptsController());
$app->resource_opts('/books', ResourceOptsController::class, [
    'only' => ['index', 'show'],
    'name_prefix' => 'library.books',
    'param' => 'book_id',
]);
$app->api_resource_opts('/api/books', ResourceOptsController::class, [
    'except' => 'destroy',
    'name_show' => 'api.books.fetch',
]);

echo $app->dispatch('GET', '/books')->body . PHP_EOL;
echo $app->dispatch('POST', '/books')->status . PHP_EOL;
echo $app->dispatch('GET', '/books/9')->body . PHP_EOL;
echo $app->has_route_name('library.books.index') ? 'yes' : 'no';
echo '|' . ($app->has_route_name('library.books.show') ? 'yes' : 'no');
echo '|' . ($app->has_route_name('library.books.store') ? 'yes' : 'no') . PHP_EOL;

echo $app->dispatch('DELETE', '/api/books/9')->status . PHP_EOL;
echo $app->has_route_name('api.books.fetch') ? 'yes' : 'no';
echo '|' . ($app->has_route_name('api.books.destroy') ? 'yes' : 'no') . PHP_EOL;
?>
--EXPECT--
index
405
show:9
yes|yes|no
405
yes|no
