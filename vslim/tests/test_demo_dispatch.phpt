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
$req->headers_json = '{"x-trace-id":"from-header","content-type":"application/json"}';
$req->cookies_json = '{"sid":"cookie-7"}';
$req->attributes_json = '{"actor":"tester"}';
$req->query_json = '{"trace_id":"from-json"}';
$req->port = '443';
$req->protocol_version = '1.1';
echo $req->header('x-trace-id') . '|' . ($req->has_header('content-type') ? 'yes' : 'no') . '|' . $req->scheme . '|' . $req->host . '|' . $req->remote_addr . PHP_EOL;
echo $req->cookie('sid') . '|' . ($req->has_cookie('sid') ? 'yes' : 'no') . '|' . $req->param('id') . '|' . ($req->has_param('id') ? 'yes' : 'no') . PHP_EOL;
echo $req->query('trace_id') . '|' . $req->attribute('actor') . '|' . ($req->has_attribute('actor') ? 'yes' : 'no') . '|' . $req->port . '|' . $req->protocol_version . PHP_EOL;

$envelope = vslim_handle_request([
    'method' => 'GET',
    'path' => '/private?token=ok&trace_id=worker',
    'body' => '',
    'scheme' => 'https',
    'host' => 'worker.local',
    'port' => '443',
    'protocol_version' => '1.1',
    'remote_addr' => '10.0.0.8',
    'query_json' => '{"token":"ok","trace_id":"worker"}',
    'headers_json' => '{"x-worker":"yes"}',
    'cookies_json' => '{"session":"worker-cookie"}',
    'attributes_json' => '{"source":"httpd"}',
    'server_json' => '{"REQUEST_TIME_FLOAT":"1.23"}',
    'uploaded_files_json' => '[]',
]);
echo $envelope['status'] . '|' . $envelope['body'] . '|' . $envelope['content_type'] . PHP_EOL;

$resp = new VSlimResponse(201, 'created', 'text/plain; charset=utf-8');
$resp->set_header('x-demo', 'yes')->with_status(202)->json('{"ok":true}');
echo $resp->status . '|' . $resp->body . '|' . $resp->content_type . '|' . $resp->header('x-demo') . '|' . ($resp->has_header('content-type') ? 'yes' : 'no') . PHP_EOL;

$resp->text('plain-again');
echo $resp->status . '|' . $resp->body . '|' . $resp->content_type . PHP_EOL;
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
200|secret|text/plain; charset=utf-8
202|{"ok":true}|application/json; charset=utf-8|yes|yes
202|plain-again|text/plain; charset=utf-8
