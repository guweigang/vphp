--TEST--
VHTTPD worker dispatches to a PSR-7 app handler when available
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

    final class TestPsr7Response {
        public function __construct(
            private int $status,
            private array $headers,
            private object $body,
        ) {}
        public function getStatusCode(): int { return $this->status; }
        public function getHeaders(): array { return $this->headers; }
        public function getBody(): object { return $this->body; }
    }

    putenv('VSLIM_HTTPD_APP=' . __DIR__ . '/fixtures/psr7_app_fixture.php');
    define('VSLIM_HTTPD_WORKER_NOAUTO', true);
    require __DIR__ . '/../httpd/php-worker.php';

    $worker = new PhpWorker('/tmp/vslim_worker_test.sock');
    $res = $worker->dispatchRequest([
        'id' => 'req-1',
        'method' => 'GET',
        'path' => '/users/9?trace_id=psr-app',
        'query' => ['trace_id' => 'psr-app'],
        'headers' => ['content-type' => 'application/json'],
        'cookies' => ['sid' => 'cookie-9'],
        'attributes' => ['route' => 'users.show'],
        'body' => '',
        'scheme' => 'https',
        'host' => 'demo.local',
        'port' => '443',
        'protocol_version' => '2',
        'remote_addr' => '127.0.0.1',
        'server' => ['REQUEST_TIME_FLOAT' => '1.23'],
        'uploaded_files' => [],
    ]);

    echo $res['id'] . PHP_EOL;
    echo $res['status'] . '|' . $res['content_type'] . '|' . $res['headers']['x-app'] . '|' . $res['headers']['content-length'] . PHP_EOL;
    echo $res['body'] . PHP_EOL;
}
?>
--EXPECT--
req-1
202|text/plain; charset=utf-8|psr7, bridge|83
app|GET|https://demo.local:443/users/9?trace_id=psr-app|psr-app|users.show|cookie-9
