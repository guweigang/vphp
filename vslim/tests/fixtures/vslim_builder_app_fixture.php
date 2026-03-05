<?php

declare(strict_types=1);

$app = new VSlim\App();

$app->get('/hello/:name', function (VSlim\Request $req) {
    $res = new VSlim\Response(200, 'Hello, ' . $req->param('name'), 'text/plain; charset=utf-8');
    return $res->set_header('x-app', 'builder-object');
});

$app->post('/submit', function (VSlim\Request $req) {
    return [
        'status' => 202,
        'content_type' => 'application/json; charset=utf-8',
        'headers' => ['x-app' => 'builder-object'],
        'body' => json_encode([
            'body' => $req->body,
            'trace' => $req->query('trace_id') ?: 'none',
        ], JSON_UNESCAPED_UNICODE),
    ];
});

return $app;
