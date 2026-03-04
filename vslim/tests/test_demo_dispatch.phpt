--TEST--
VSlim demo app dispatches routes through the extension
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = VSlimApp::demo();
$res = $app->dispatch('GET', '/health');
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;

$res = $app->dispatch('GET', '/users/42');
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;

$res = $app->dispatch('POST', '/health');
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;

$res = $app->dispatch('GET', '/missing');
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;

$res = $app->dispatch('GET', '/private');
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;

$res = $app->dispatch('GET', '/private?token=ok');
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;

$res = $app->dispatch('GET', '/panic');
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;

$meta = vslim_demo_dispatch('GET', '/meta');
echo $meta['status'] . '|' . $meta['body'] . '|' . $meta['content_type'] . PHP_EOL;

$req = new VSlimRequest('GET', '/users/7?trace_id=from-php', '');
$res = $app->dispatch_request($req);
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;
echo $req->query('trace_id') . '|' . ($req->has_query('trace_id') ? 'yes' : 'no') . PHP_EOL;

$req->scheme = 'https';
$req->host = 'demo.local';
$req->remote_addr = '127.0.0.1';
$req->set_headers(['x-trace-id' => 'from-header', 'content-type' => 'application/json']);
$req->set_cookies(['sid' => 'cookie-7']);
$req->set_attributes(['actor' => 'tester']);
$req->set_query(['trace_id' => 'from-json']);
$req->set_server(['server_name' => 'demo.local']);
$req->port = '443';
$req->protocol_version = '1.1';
echo $req->header('x-trace-id') . '|' . ($req->has_header('content-type') ? 'yes' : 'no') . '|' . $req->scheme . '|' . $req->host . '|' . $req->remote_addr . PHP_EOL;
echo $req->cookie('sid') . '|' . ($req->has_cookie('sid') ? 'yes' : 'no') . '|' . $req->param('id') . '|' . ($req->has_param('id') ? 'yes' : 'no') . PHP_EOL;
echo $req->query('trace_id') . '|' . $req->attribute('actor') . '|' . ($req->has_attribute('actor') ? 'yes' : 'no') . '|' . $req->port . '|' . $req->protocol_version . PHP_EOL;
echo $req->content_type() . '|' . $req->server_value('server_name') . '|' . ($req->has_server('server_name') ? 'yes' : 'no') . '|' . $req->uploaded_file_count() . '|' . ($req->is_secure() ? 'yes' : 'no') . PHP_EOL;
echo $req->query_all()['trace_id'] . '|' . $req->headers_all()['content-type'] . '|' . $req->cookies_all()['sid'] . '|' . $req->attributes_all()['actor'] . '|' . $req->server_all()['server_name'] . '|' . ($req->has_uploaded_files() ? 'yes' : 'no') . PHP_EOL;

$envelope = vslim_handle_request([
    'method' => 'GET',
    'path' => '/private?token=ok&trace_id=worker',
    'body' => '',
    'scheme' => 'https',
    'host' => 'worker.local',
    'port' => '443',
    'protocol_version' => '1.1',
    'remote_addr' => '10.0.0.8',
    'query' => ['token' => 'ok', 'trace_id' => 'worker'],
    'headers' => ['x-worker' => 'yes'],
    'cookies' => ['session' => 'worker-cookie'],
    'attributes' => ['source' => 'httpd'],
    'server' => ['REQUEST_TIME_FLOAT' => '1.23'],
    'uploaded_files' => [],
]);
echo $envelope['status'] . '|' . $envelope['body'] . '|' . $envelope['content_type'] . PHP_EOL;

$resp = new VSlimResponse(201, 'created', 'text/plain; charset=utf-8');
$resp->set_header('x-demo', 'yes')->with_status(202)->json('{"ok":true}');
echo $resp->status . '|' . $resp->body . '|' . $resp->content_type . '|' . $resp->header('x-demo') . '|' . ($resp->has_header('content-type') ? 'yes' : 'no') . PHP_EOL;
$resp->set_cookie('sid', 'cookie-202');
echo $resp->cookie_header() . PHP_EOL;
$resp->delete_cookie('sid');
echo $resp->cookie_header() . PHP_EOL;

$resp->text('plain-again');
echo $resp->status . '|' . $resp->body . '|' . $resp->content_type . PHP_EOL;
$resp->html('<b>ok</b>');
echo $resp->status . '|' . $resp->body . '|' . $resp->content_type . '|' . $resp->content_length() . PHP_EOL;
$resp->set_content_type('application/xml');
echo $resp->content_type . '|' . $resp->header('content-type') . PHP_EOL;
echo $resp->headers_all()['content-type'] . '|' . $resp->headers_all()['x-demo'] . PHP_EOL;
$resp->set_cookie_full('sid', 'cookie-303', '/', 'demo.local', 60, true, true, 'lax');
echo $resp->cookie_header() . PHP_EOL;
?>
--EXPECT--
200|OK|text/plain; charset=utf-8
200|{"user":"42","trace":"trace-local-mvp"}|application/json; charset=utf-8
405|Method Not Allowed|text/plain; charset=utf-8
404|Not Found|text/plain; charset=utf-8
401|Unauthorized|text/plain; charset=utf-8
200|secret|text/plain; charset=utf-8
500|Internal Server Error|text/plain; charset=utf-8
200|{"runtime":"vslim","bridge":"vphp","server":"vhttpd","trace":"trace-local-mvp"}|application/json; charset=utf-8
200|{"user":"7","trace":"from-php"}|application/json; charset=utf-8
from-php|yes
from-header|yes|https|demo.local|127.0.0.1
cookie-7|yes|7|yes
from-json|tester|yes|443|1.1
application/json|demo.local|yes|0|yes
from-json|application/json|cookie-7|tester|demo.local|no
200|secret|text/plain; charset=utf-8
202|{"ok":true}|application/json; charset=utf-8|yes|yes
sid=cookie-202; Path=/
sid=; Path=/; Max-Age=0
202|plain-again|text/plain; charset=utf-8
202|<b>ok</b>|text/html|9
application/xml|application/xml
application/xml|yes
sid=cookie-303; Path=/; Domain=demo.local; Max-Age=60; HttpOnly; Secure; SameSite=Lax
