--TEST--
VSlim PSR-7 adapter converts requests into VSlim\Request and dispatches them
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
final class TestUri {
    public function __construct(
        public string $scheme,
        public string $host,
        public ?int $port,
        public string $path,
        public string $query,
    ) {}
    public function getScheme(): string { return $this->scheme; }
    public function getHost(): string { return $this->host; }
    public function getPort(): ?int { return $this->port; }
    public function getPath(): string { return $this->path; }
    public function getQuery(): string { return $this->query; }
}

final class TestBody {
    public function __construct(private string $content) {}
    public function __toString(): string { return $this->content; }
}

final class TestServerRequest {
    public function __construct(
        private string $method,
        private TestUri $uri,
        private array $headers,
        private array $cookies,
        private array $query,
        private array $attributes,
        private array $server,
        private TestBody $body,
    ) {}
    public function getMethod(): string { return $this->method; }
    public function getUri(): TestUri { return $this->uri; }
    public function getProtocolVersion(): string { return '2'; }
    public function getHeaders(): array { return $this->headers; }
    public function getCookieParams(): array { return $this->cookies; }
    public function getQueryParams(): array { return $this->query; }
    public function getAttributes(): array { return $this->attributes; }
    public function getServerParams(): array { return $this->server; }
    public function getUploadedFiles(): array { return []; }
    public function getBody(): TestBody { return $this->body; }
}

$autoload = dirname(__DIR__) . '/vendor/autoload.php';
if (!is_file($autoload)) {
    echo "autoload_missing\n";
    exit;
}
require_once $autoload;

$app = VSlim\App::demo();
$req = new TestServerRequest(
    'GET',
    new TestUri('https', 'demo.local', 443, '/users/55', 'trace_id=psr-bridge'),
    ['x-trace-id' => ['from-psr7']],
    ['sid' => 'cookie-55'],
    ['trace_id' => 'psr-bridge'],
    ['actor' => 'psr-user'],
    ['REMOTE_ADDR' => '127.0.0.1'],
    new TestBody(''),
);

$vreq = VSlimPsr7Adapter::toVSlimRequest($req);
echo $vreq->method . '|' . $vreq->raw_path . '|' . $vreq->scheme . '|' . $vreq->host . '|' . $vreq->port . '|' . $vreq->protocol_version . PHP_EOL;
echo $vreq->query('trace_id') . '|' . $vreq->cookie('sid') . '|' . $vreq->attribute('actor') . '|' . $vreq->header('x-trace-id') . PHP_EOL;

$env = VSlimPsr7Adapter::toWorkerEnvelope($req);
echo $env['method'] . '|' . $env['path'] . '|' . $env['headers']['x-trace-id'] . '|' . $env['cookies']['sid'] . '|' . $env['query']['trace_id'] . PHP_EOL;

$res = VSlimPsr7Adapter::dispatch($app, $req);
echo $res->status . '|' . $res->body . '|' . $res->content_type . PHP_EOL;
?>
--EXPECT--
GET|/users/55?trace_id=psr-bridge|https|demo.local|443|2
psr-bridge|cookie-55|psr-user|from-psr7
GET|/users/55?trace_id=psr-bridge|from-psr7|cookie-55|psr-bridge
200|{"user":"55","trace":"psr-bridge"}|application/json; charset=utf-8
