--TEST--
VSlim resource skips actions that controller does not implement
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
final class PartialUsersController {
    public function index(VSlim\Request $req): string { return 'index'; }
    public function show(VSlim\Request $req): string { return 'show:' . $req->param('id'); }
}

$app = new VSlim\App();
$app->container()->set(PartialUsersController::class, new PartialUsersController());
$app->resource('/users', PartialUsersController::class);

echo $app->dispatch('GET', '/users')->body . PHP_EOL;
echo $app->dispatch('GET', '/users/7')->body . PHP_EOL;
echo $app->dispatch('POST', '/users')->status . PHP_EOL;
echo $app->dispatch('GET', '/users/create')->body . PHP_EOL;
echo $app->dispatch('DELETE', '/users/7')->status . PHP_EOL;
?>
--EXPECT--
index
show:7
405
show:create
405
