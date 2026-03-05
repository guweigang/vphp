--TEST--
VHTTPD PSR-7 bridge builds a request with Laminas Diactoros factories
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
namespace Laminas\Diactoros {
    final class RequestFactory {
        public function createServerRequest(string $method, string $uri, array $server = []): \TestLaminasRequest {
            return new \TestLaminasRequest($method, $uri, $server);
        }
    }

    final class StreamFactory {
        public function createStream(string $content): \TestLaminasStream {
            return new \TestLaminasStream($content);
        }
    }
}

namespace {
    final class TestLaminasStream {
        public function __construct(public string $content) {}
        public function __toString(): string { return $this->content; }
    }

    final class TestLaminasRequest {
        public string $protocolVersion = '1.1';
        public array $headers = [];
        public array $cookies = [];
        public array $query = [];
        public array $attributes = [];
        public array $uploadedFiles = [];
        public ?TestLaminasStream $body = null;

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
        public function withBody(TestLaminasStream $body): self {
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

    require __DIR__ . '/../httpd/psr7_bridge.php';

    $req = VHttpdPsr7Bridge::buildServerRequest([
        'method' => 'PUT',
        'path' => '/items/8?trace_id=laminas',
        'body' => '{"name":"Laminas"}',
        'scheme' => 'https',
        'host' => 'demo.local',
        'port' => '443',
        'protocol_version' => '2',
        'remote_addr' => '127.0.0.1',
        'headers' => ['content-type' => 'application/json', 'x-request-id' => 'abc'],
        'cookies' => ['sid' => 'cookie-lam'],
        'query' => ['trace_id' => 'laminas'],
        'attributes' => ['route' => 'items.update'],
        'server' => ['REQUEST_TIME_FLOAT' => '1.23'],
        'uploaded_files' => [],
    ]);

    echo get_class($req) . PHP_EOL;
    echo $req->method . '|' . $req->uri . '|' . $req->protocolVersion . PHP_EOL;
    echo (string)$req->body . PHP_EOL;
    echo $req->headers['content-type'] . '|' . $req->headers['x-request-id'] . PHP_EOL;
    echo $req->cookies['sid'] . '|' . $req->query['trace_id'] . '|' . $req->attributes['route'] . PHP_EOL;
    echo $req->server['HTTP_HOST'] . '|' . $req->server['REMOTE_ADDR'] . '|' . $req->server['SERVER_PROTOCOL'] . PHP_EOL;
}
?>
--EXPECT--
TestLaminasRequest
PUT|https://demo.local:443/items/8?trace_id=laminas|2
{"name":"Laminas"}
application/json|abc
cookie-lam|laminas|items.update
demo.local|127.0.0.1|HTTP/2
