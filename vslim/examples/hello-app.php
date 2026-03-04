<?php
declare(strict_types=1);

$app = new VSlimApp();

$app->before(function (VSlimRequest $req) {
    if ($req->path === '/blocked') {
        return new VSlimResponse(403, 'blocked', 'text/plain; charset=utf-8');
    }
    return null;
});

$app->get('/hello/:name', function (VSlimRequest $req) {
    return new VSlimResponse(
        200,
        'Hello, ' . $req->param('name'),
        'text/plain; charset=utf-8'
    );
});

$api = $app->group('/api');
$api->get('/meta', function (VSlimRequest $req) {
    return [
        'status' => 200,
        'content_type' => 'application/json; charset=utf-8',
        'body' => json_encode([
            'path' => $req->path,
            'secure' => $req->is_secure(),
            'host' => $req->host,
        ]),
    ];
});

$app->after(function (VSlimRequest $req, VSlimResponse $res) {
    $res->set_header('x-runtime', 'vslim');
    return $res;
});

return $app;
