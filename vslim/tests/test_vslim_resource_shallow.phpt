--TEST--
VSlim resource_opts supports shallow member routes for nested resources
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
final class NestedCommentsController {
    public function index(VSlim\Request $req): string { return 'index'; }
    public function show(VSlim\Request $req): string {
        return 'show:' . $req->param('comment_id') . '|photo:' . $req->param('photo_id');
    }
}

$app = new VSlim\App();
$app->container()->set(NestedCommentsController::class, new NestedCommentsController());
$app->resource_opts('/photos/:photo_id/comments', NestedCommentsController::class, [
    'only' => ['index', 'show'],
    'param' => 'comment_id',
    'shallow' => true,
]);

echo $app->dispatch('GET', '/photos/7/comments')->body . PHP_EOL;
echo $app->dispatch('GET', '/photos/7/comments/99')->status . PHP_EOL;
echo $app->dispatch('GET', '/comments/99')->body . PHP_EOL;
echo $app->url_for('photos.:photo_id.comments.show', ['comment_id' => '88']) . PHP_EOL;
?>
--EXPECT--
index
404
show:99|photo:
/comments/88
