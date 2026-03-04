<?php
declare(strict_types=1);

$app = new VSlimApp();

$app->before(function (VSlimRequest $req) {
    if ($req->path === '/blocked') {
        return new VSlimResponse(403, 'blocked', 'text/plain; charset=utf-8');
    }
    return null;
});

$app->get_named('hello.show', '/hello/:name', function (VSlimRequest $req) {
    return new VSlimResponse(
        200,
        'Hello, ' . $req->param('name'),
        'text/plain; charset=utf-8'
    );
});

$app->get('/go/:name', function (VSlimRequest $req) use ($app) {
    return $app->redirect_to('hello.show', ['name' => $req->param('name')]);
});

$api = $app->group('/api');
$api->get('/meta', function (VSlimRequest $req) use ($app) {
    return [
        'status' => 200,
        'content_type' => 'application/json; charset=utf-8',
        'body' => json_encode([
            'path' => $req->path,
            'secure' => $req->is_secure(),
            'host' => $req->host,
            'hello_url' => $app->url_for('hello.show', ['name' => 'codex']),
        ]),
    ];
});

$app->after(function (VSlimRequest $req, VSlimResponse $res) {
    $res->set_header('x-runtime', 'vslim');
    return $res;
});

return $app;
