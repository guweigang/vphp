--TEST--
VSlim\App supports custom not_found and error handlers
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlim\App();
$app->get('/ok', function (VSlim\Request $req) {
    return 'ok';
});
$app->post('/write', function (VSlim\Request $req) {
    return 'w:' . $req->body;
});
$app->get('/bad', function (VSlim\Request $req) {
    return 123;
});

$app->set_not_found_handler(function (VSlim\Request $req) {
    return [
        'status' => 404,
        'content_type' => 'application/json; charset=utf-8',
        'body' => json_encode(['missing' => $req->path]),
    ];
});

$app->set_error_handler(function (VSlim\Request $req, string $message, int $status) {
    return [
        'status' => $status,
        'content_type' => 'application/json; charset=utf-8',
        'body' => json_encode([
            'path' => $req->path,
            'status' => $status,
            'message' => $message,
        ]),
    ];
});

echo $app->dispatch('GET', '/missing')->status . '|' . $app->dispatch('GET', '/missing')->body . PHP_EOL;
echo $app->dispatch('GET', '/bad')->status . '|' . $app->dispatch('GET', '/bad')->body . PHP_EOL;
echo $app->dispatch('GET', '/write')->status . '|' . $app->dispatch('GET', '/write')->body . PHP_EOL;

try {
    $app->set_not_found_handler(123);
    echo "not_found_invalid_not_thrown\n";
} catch (InvalidArgumentException $e) {
    echo "not_found_invalid_thrown\n";
}

try {
    $app->set_error_handler(123);
    echo "error_invalid_not_thrown\n";
} catch (InvalidArgumentException $e) {
    echo "error_invalid_thrown\n";
}
?>
--EXPECT--
404|{"missing":"\/missing"}
500|{"path":"\/bad","status":500,"message":"Invalid route response"}
405|{"path":"\/write","status":405,"message":"Method not allowed"}
not_found_invalid_thrown
error_invalid_thrown
