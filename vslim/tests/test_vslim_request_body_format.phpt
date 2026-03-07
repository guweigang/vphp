--TEST--
VSlim Request body format helpers support json/form/multipart
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
$formReq = new VSlim\Request('POST', '/forms/echo?token=demo', 'name=neo&city=shanghai');
$formReq->set_headers(['content-type' => 'application/x-www-form-urlencoded']);
echo $formReq->body_format() . PHP_EOL;
echo ($formReq->is_form_body() ? 'yes' : 'no') . PHP_EOL;
echo $formReq->form_body()['name'] . PHP_EOL;

$jsonReq = new VSlim\Request('POST', '/json', '{"ok":"yes","trace":"demo"}');
$jsonReq->set_headers(['content-type' => 'application/json']);
echo $jsonReq->body_format() . PHP_EOL;
echo ($jsonReq->is_json_body() ? 'yes' : 'no') . PHP_EOL;
echo $jsonReq->json_body()['ok'] . PHP_EOL;

$boundary = '----vslimBoundary';
$multipartBody = ''
    . '--' . $boundary . "\r\n"
    . "Content-Disposition: form-data; name=\"name\"\r\n\r\n"
    . "neo\r\n"
    . '--' . $boundary . "\r\n"
    . "Content-Disposition: form-data; name=\"file\"; filename=\"hello.txt\"\r\n"
    . "Content-Type: text/plain\r\n\r\n"
    . "hello from body\r\n"
    . '--' . $boundary . "--\r\n";
$multipartReq = new VSlim\Request('POST', '/forms/echo', $multipartBody);
$multipartReq->set_headers(['content-type' => 'multipart/form-data; boundary=' . $boundary]);
echo $multipartReq->body_format() . PHP_EOL;
echo ($multipartReq->is_multipart_body() ? 'yes' : 'no') . PHP_EOL;
echo $multipartReq->multipart_body()['name'] . PHP_EOL;
echo implode(',', $multipartReq->uploaded_files()) . PHP_EOL;
?>
--EXPECT--
form
yes
neo
json
yes
yes
multipart
yes
neo
hello.txt
