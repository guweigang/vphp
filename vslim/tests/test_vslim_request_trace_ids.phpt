--TEST--
VSlim request/response trace id helpers and header propagation
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$app = new VSlim\App();
$app->get('/ids', function (VSlim\Request $req) {
    return [
        'status' => 200,
        'content_type' => 'application/json; charset=utf-8',
        'body' => json_encode([
            'rid' => $req->request_id(),
            'tid' => $req->trace_id(),
        ], JSON_UNESCAPED_UNICODE),
    ];
});

$req = new VSlim\Request('GET', '/ids?trace_id=q-trace&request_id=q-rid', '');
$req->set_headers([
    'x-request-id' => 'hdr-rid',
    'x-trace-id' => 'hdr-trace',
]);
$res = $app->dispatch_request($req);
echo $res->status . '|' . $res->body . PHP_EOL;
echo $res->header('x-request-id') . '|' . $res->header('x-trace-id') . '|' . $res->header('x-vhttpd-trace-id') . PHP_EOL;

$req2 = new VSlim\Request('GET', '/ids', '');
$req2->set_headers(['x-request-id' => 'only-rid']);
$res2 = $app->dispatch_request($req2);
echo $res2->status . '|' . $res2->body . PHP_EOL;
echo $res2->header('x-request-id') . '|' . $res2->header('x-trace-id') . '|' . $res2->header('x-vhttpd-trace-id') . PHP_EOL;

$resp = new VSlim\Response(200, 'ok', 'text/plain; charset=utf-8');
$resp->with_request_id('rid-7')->with_trace_id('trace-7');
echo $resp->header('x-request-id') . '|' . $resp->header('x-trace-id') . '|' . $resp->header('x-vhttpd-trace-id') . PHP_EOL;
?>
--EXPECT--
200|{"rid":"hdr-rid","tid":"hdr-trace"}
hdr-rid|hdr-trace|hdr-trace
200|{"rid":"only-rid","tid":"only-rid"}
only-rid|only-rid|only-rid
rid-7|trace-7|trace-7
