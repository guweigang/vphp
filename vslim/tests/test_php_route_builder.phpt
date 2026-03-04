--TEST--
VSlimApp can register PHP route handlers and dispatch them
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlimApp();
$app->before(function (VSlimRequest $req) {
    if ($req->path === '/before-only') {
        return 'before-only';
    }
    return null;
});
$app->middleware(function (VSlimRequest $req) {
    if ($req->path === '/blocked') {
        return new VSlimResponse(403, 'blocked', 'text/plain; charset=utf-8');
    }
    return null;
});
$app->middleware(function (VSlimRequest $req) {
    if ($req->path === '/submit' && $req->query('trace_id') === 'mw') {
        return [
            'status' => 202,
            'content_type' => 'text/plain; charset=utf-8',
            'body' => 'middleware:' . $req->body,
        ];
    }
    return null;
});
$app->get('/hello/:name', function (VSlimRequest $req) {
    return new VSlimResponse(200, 'Hello, ' . $req->param('name'), 'text/plain; charset=utf-8');
});
$app->get_named('hello.show', '/hello/:name', function (VSlimRequest $req) {
    return new VSlimResponse(200, 'Named Hello, ' . $req->param('name'), 'text/plain; charset=utf-8');
});
$app->post('/submit', function (VSlimRequest $req) {
    return [
        'status' => 201,
        'content_type' => 'application/json; charset=utf-8',
        'headers' => ['x-mode' => 'builder'],
        'body' => json_encode(['body' => $req->body, 'trace' => $req->query('trace_id') ?: 'none']),
    ];
});
$app->after(function (VSlimRequest $req, VSlimResponse $res) {
    if ($req->path === '/hello/codex') {
        $res->set_header('x-after', 'app');
        return $res;
    }
    return null;
});
$api = $app->group('/api');
$api->middleware(function (VSlimRequest $req) {
    if ($req->path === '/api/blocked') {
        return 'group-blocked';
    }
    return null;
});
$api->get('/users/:id', function (VSlimRequest $req) {
    return 'user:' . $req->param('id');
});
$api->after(function (VSlimRequest $req, VSlimResponse $res) {
    if ($req->path === '/api/users/9') {
        $res->text('after:' . $res->body);
        return $res;
    }
    return null;
});
$api->get_named('api.users.show', '/members/:id', function (VSlimRequest $req) {
    return 'member:' . $req->param('id');
});
$api->get('/blocked', function (VSlimRequest $req) {
    return 'route-blocked';
});
$api->put_named('api.users.update', '/users/:id', function (VSlimRequest $req) {
    return 'put:' . $req->param('id');
});
$api->delete('/users/:id', function (VSlimRequest $req) {
    return 'delete:' . $req->param('id');
});
$api->patch('/users/:id', function (VSlimRequest $req) {
    return 'patch:' . $req->param('id');
});
$api->any_named('api.echo.any', '/echo/:id', function (VSlimRequest $req) {
    return $req->method . ':' . $req->param('id');
});
$v1 = $api->group('/v1');
$v1->middleware(function (VSlimRequest $req) {
    if ($req->path === '/api/v1/ping' && $req->query('trace_id') === 'group') {
        return [
            'status' => 206,
            'content_type' => 'text/plain; charset=utf-8',
            'body' => 'group-middleware',
        ];
    }
    return null;
});
$v1->get('/ping', function (VSlimRequest $req) {
    return [
        'status' => 200,
        'content_type' => 'application/json; charset=utf-8',
        'body' => json_encode(['pong' => true, 'path' => $req->path]),
    ];
});
$app->set_base_path('/v1');

echo $app->dispatch('GET', '/hello/codex')->body . '|' . $app->dispatch('GET', '/hello/codex')->header('x-after') . PHP_EOL;
echo $app->url_for('hello.show', ['name' => 'nova']) . PHP_EOL;
echo $app->url_for_query('api.users.show', ['id' => '12'], ['tab' => 'profile', 'trace' => '1']) . PHP_EOL;
echo $app->url_for_abs('hello.show', ['name' => 'nova'], 'https', 'demo.local') . PHP_EOL;
$app->set_base_path('');
$redirect = $app->redirect_to('hello.show', ['name' => 'jump']);
echo $redirect->status . '|' . $redirect->header('location') . '|' . $redirect->body . PHP_EOL;
$manual = new VSlimResponse(200, 'ignored', 'text/plain; charset=utf-8');
$manual->redirect_with_status('/moved', 307);
echo $manual->status . '|' . $manual->header('location') . '|' . $manual->content_type . PHP_EOL;
$res = $app->dispatch_body('POST', '/submit?trace_id=builder', 'payload');
echo $res->status . '|' . $res->body . '|' . $res->header('x-mode') . PHP_EOL;
echo $app->dispatch('GET', '/api/users/9')->body . PHP_EOL;
echo $app->dispatch('GET', '/api/members/12')->body . PHP_EOL;
echo $app->url_for('api.users.update', ['id' => '33']) . PHP_EOL;
echo $app->dispatch('PUT', '/api/users/33')->body . PHP_EOL;
echo $app->dispatch('PATCH', '/api/users/34')->body . PHP_EOL;
echo $app->dispatch('DELETE', '/api/users/35')->body . PHP_EOL;
echo $app->dispatch('POST', '/api/echo/44')->body . PHP_EOL;
echo $app->dispatch('GET', '/api/v1/ping')->body . PHP_EOL;
echo $app->dispatch('GET', '/api/blocked')->body . PHP_EOL;
echo $app->dispatch('GET', '/api/v1/ping?trace_id=group')->status . '|' . $app->dispatch('GET', '/api/v1/ping?trace_id=group')->body . PHP_EOL;
echo $app->dispatch('GET', '/blocked')->status . '|' . $app->dispatch('GET', '/blocked')->body . PHP_EOL;
echo $app->dispatch('POST', '/submit?trace_id=mw')->status . '|' . $app->dispatch('POST', '/submit?trace_id=mw')->body . PHP_EOL;
echo $app->dispatch('GET', '/before-only')->status . '|' . $app->dispatch('GET', '/before-only')->body . PHP_EOL;
?>
--EXPECT--
Hello, codex|app
/v1/hello/nova
/v1/api/members/12?tab=profile&trace=1
https://demo.local/v1/hello/nova
302|/hello/jump|
307|/moved|text/plain; charset=utf-8
201|{"body":"payload","trace":"builder"}|builder
after:user:9
member:12
/api/users/33
put:33
patch:34
delete:35
POST:44
{"pong":true,"path":"\/api\/v1\/ping"}
group-blocked
206|group-middleware
403|blocked
202|middleware:
200|before-only
