--TEST--
VHTTPD PSR-7 bridge builds a request when a PSR-17 style factory is available
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
namespace Nyholm\Psr7\Factory {
    final class Psr17Factory {
        public function createServerRequest(string $method, string $uri, array $server = []): \TestPsr7Request {
            return new \TestPsr7Request($method, $uri, $server);
        }
        public function createStream(string $content): \TestPsr7Stream {
            return new \TestPsr7Stream($content);
        }
    }
}

namespace {
    final class TestPsr7Stream {
        public function __construct(public string $content) {}
        public function __toString(): string { return $this->content; }
    }

    final class TestPsr7Request {
        public string $protocolVersion = '1.1';
        public array $headers = [];
        public array $cookies = [];
        public array $query = [];
        public array $attributes = [];
        public array $uploadedFiles = [];
        public ?TestPsr7Stream $body = null;

        public function __construct(
            public string $method,
            public string $uri,
            public array $server
        ) {}

        public function withProtocolVersion(string $version): self {
            $clone = clone $this;
            $clone->protocolVersion = $version;
            return $clone;
        }
        public function withBody(TestPsr7Stream $body): self {
            $clone = clone $this;
            $clone->body = $body;
            return $clone;
        }
        public function withCookieParams(array $cookies): self {
            $clone = clone $this;
            $clone->cookies = $cookies;
            return $clone;
        }
        public function withQueryParams(array $query): self {
            $clone = clone $this;
            $clone->query = $query;
            return $clone;
        }
        public function withUploadedFiles(array $uploadedFiles): self {
            $clone = clone $this;
            $clone->uploadedFiles = $uploadedFiles;
            return $clone;
        }
        public function withHeader(string $name, string $value): self {
            $clone = clone $this;
            $clone->headers[$name] = $value;
            return $clone;
        }
        public function withAttribute(string $name, mixed $value): self {
            $clone = clone $this;
            $clone->attributes[$name] = $value;
            return $clone;
        }
    }

    $autoload = dirname(__DIR__) . '/vendor/autoload.php';
    if (!is_file($autoload)) {
        echo "autoload_missing\n";
        exit;
    }
    require_once $autoload;

    $req = VHttpdPsr7Bridge::buildServerRequest([
        'method' => 'POST',
        'path' => '/users/9?trace_id=psr',
        'body' => '{"name":"Codex"}',
        'scheme' => 'https',
        'host' => 'demo.local',
        'port' => '443',
        'protocol_version' => '2',
        'remote_addr' => '127.0.0.1',
        'headers' => ['content-type' => 'application/json', 'x-request-id' => 'abc'],
        'cookies' => ['sid' => 'cookie-7'],
        'query' => ['trace_id' => 'psr'],
        'attributes' => ['route' => 'users.show'],
        'server' => ['REQUEST_TIME_FLOAT' => '1.23'],
        'uploaded_files' => [],
    ]);

    echo get_class($req) . PHP_EOL;
    echo $req->method . '|' . $req->uri . '|' . $req->protocolVersion . PHP_EOL;
    echo (string)$req->body . PHP_EOL;
    echo $req->headers['content-type'] . '|' . $req->headers['x-request-id'] . PHP_EOL;
    echo $req->cookies['sid'] . '|' . $req->query['trace_id'] . '|' . $req->attributes['route'] . PHP_EOL;
    echo $req->server['HTTP_HOST'] . '|' . $req->server['REMOTE_ADDR'] . '|' . $req->server['SERVER_PROTOCOL'] . PHP_EOL;

    $req2 = VHttpdPsr7Bridge::buildServerRequest([
        'method' => 'GET',
        'path' => '/hello/world?trace_id=array-shape',
        'scheme' => 'http',
        'host' => 'demo.local',
        'port' => '80',
        'protocol_version' => '1.1',
        'remote_addr' => '127.0.0.2',
        'headers' => ['x-request-id' => ['a', 'b']],
        'cookies' => ['sid' => 'cookie-array'],
        'query' => ['trace_id' => 'array-shape'],
        'attributes' => ['source' => 'worker-shape'],
        'server' => ['REQUEST_TIME_FLOAT' => '2.34'],
        'uploaded_files' => [],
    ]);
    echo $req2->method . '|' . $req2->uri . '|' . $req2->headers['x-request-id'] . PHP_EOL;
    echo $req2->cookies['sid'] . '|' . $req2->query['trace_id'] . '|' . $req2->attributes['source'] . '|' . $req2->server['REMOTE_ADDR'] . PHP_EOL;
}
?>
--EXPECT--
TestPsr7Request
POST|https://demo.local:443/users/9?trace_id=psr|2
{"name":"Codex"}
application/json|abc
cookie-7|psr|users.show
demo.local|127.0.0.1|HTTP/2
GET|http://demo.local:80/hello/world?trace_id=array-shape|a, b
cookie-array|array-shape|worker-shape|127.0.0.2
