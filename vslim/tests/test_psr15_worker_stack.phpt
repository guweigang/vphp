--TEST--
VHTTPD worker dispatches PSR-15 middleware stack bootstrap
--SKIPIF--
<?php if (!extension_loaded("vslim")) print "skip"; ?>
--FILE--
<?php
namespace Psr\Http\Message {
    interface ServerRequestInterface {}
    interface ResponseInterface {}
}

namespace Psr\Http\Server {
    interface RequestHandlerInterface {
        public function handle(\Psr\Http\Message\ServerRequestInterface $request): \Psr\Http\Message\ResponseInterface;
    }
    interface MiddlewareInterface {
        public function process(
            \Psr\Http\Message\ServerRequestInterface $request,
            RequestHandlerInterface $handler
        ): \Psr\Http\Message\ResponseInterface;
    }
}

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

    final class TestPsr7Request implements \Psr\Http\Message\ServerRequestInterface {
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

    final class TestPsr7Response implements \Psr\Http\Message\ResponseInterface {
        public function __construct(
            private int $status,
            private array $headers,
            private object $body,
        ) {}
        public function getStatusCode(): int { return $this->status; }
        public function getHeaders(): array { return $this->headers; }
        public function getBody(): object { return $this->body; }
    }

    putenv('VSLIM_HTTPD_APP=' . __DIR__ . '/fixtures/psr15_stack_app_fixture.php');
    define('VSLIM_HTTPD_WORKER_NOAUTO', true);
    require __DIR__ . '/../httpd/php-worker.php';

    $worker = new PhpWorker('/tmp/vslim_worker_test.sock');
    $res = $worker->dispatchRequest([
        'id' => 'req-psr15-stack',
        'method' => 'GET',
        'path' => '/stack/run?trace_id=worker-stack',
        'query' => ['trace_id' => 'worker-stack'],
        'headers' => ['content-type' => 'application/json'],
        'cookies' => ['sid' => 'cookie-stack'],
        'attributes' => ['source' => 'psr15-stack'],
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
    echo $res['status'] . '|' . $res['content_type'] . '|' . $res['headers']['x-app'] . PHP_EOL;
    echo $res['body'] . PHP_EOL;
}
?>
--EXPECT--
req-psr15-stack
209|text/plain; charset=utf-8|psr15, stack
stack|GET|https://demo.local:443/stack/run?trace_id=worker-stack|worker-stack|mw1-mw2
