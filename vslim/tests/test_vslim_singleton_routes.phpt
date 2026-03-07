--TEST--
VSlim singleton and api_singleton register singleton REST routes
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
final class ProfileController {
    public function show(VSlim\Request $req): string { return 'show'; }
    public function create(VSlim\Request $req): string { return 'create'; }
    public function store(VSlim\Request $req): string { return 'store'; }
    public function edit(VSlim\Request $req): string { return 'edit'; }
    public function update(VSlim\Request $req): string { return 'update'; }
    public function destroy(VSlim\Request $req): string { return 'destroy'; }
}

$app = new VSlim\App();
$app->container()->set(ProfileController::class, new ProfileController());
$app->singleton('/profile', ProfileController::class);
$app->api_singleton('/api/profile', ProfileController::class);

echo $app->dispatch('GET', '/profile')->body . PHP_EOL;
echo $app->dispatch('GET', '/profile/create')->body . PHP_EOL;
echo $app->dispatch('POST', '/profile')->body . PHP_EOL;
echo $app->dispatch('GET', '/profile/edit')->body . PHP_EOL;
echo $app->dispatch('PATCH', '/profile')->body . PHP_EOL;
echo $app->dispatch('DELETE', '/profile')->body . PHP_EOL;

echo $app->dispatch('GET', '/api/profile')->body . PHP_EOL;
echo $app->dispatch('GET', '/api/profile/create')->status . PHP_EOL;
echo $app->dispatch('GET', '/api/profile/edit')->status . PHP_EOL;
echo $app->dispatch('PUT', '/api/profile')->body . PHP_EOL;
echo $app->dispatch('DELETE', '/api/profile')->body . PHP_EOL;
?>
--EXPECT--
show
create
store
edit
update
destroy
show
404
404
update
destroy
