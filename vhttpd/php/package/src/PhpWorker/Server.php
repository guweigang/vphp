<?php

declare(strict_types=1);

namespace VHttpd\PhpWorker;

/**
 * PHP Worker for vhttpd proxy mode.
 *
 * Protocol:
 * - request:  [4-byte big-endian length][json payload]
 * - response: [4-byte big-endian length][json payload]
 *
 * Usage:
 *   php php/php-worker.php --socket /tmp/vphp_worker.sock
 */

final class Server
{
    private string $socketPath;
    private ?string $appBootstrapPath;
    private int $parentPid = 0;
    /** @var resource|null */
    private $server = null;
    /** @var mixed */
    private $appHandler = null;
    private bool $appLoaded = false;

    public function __construct(
        string $socketPath,
        ?string $appBootstrapPath = null,
    ) {
        $this->socketPath = $socketPath;
        $this->appBootstrapPath = $appBootstrapPath;
        $this->parentPid = (int) (getenv('VHTTPD_PARENT_PID') ?: 0);
    }

    public function run(): void
    {
        $this->prepareSocketPath();
        $uri = "unix://" . $this->socketPath;
        $errno = 0;
        $errstr = "";

        $this->server = @stream_socket_server($uri, $errno, $errstr);
        if (!is_resource($this->server)) {
            fwrite(STDERR, "worker_start_failed: {$errstr} ({$errno})\n");
            exit(1);
        }

        @chmod($this->socketPath, 0660);
        fwrite(STDOUT, "worker_started socket={$this->socketPath}\n");

        while (true) {
            $conn = @stream_socket_accept($this->server, 1.0);
            if ($conn === false) {
                if ($this->shouldExitBecauseParentGone()) {
                    break;
                }
                continue;
            }
            if (!is_resource($conn)) {
                continue;
            }
            $this->handleConnection($conn);
            if ($this->shouldExitBecauseParentGone()) {
                break;
            }
        }

        if (is_resource($this->server)) {
            @fclose($this->server);
        }
    }

    private function shouldExitBecauseParentGone(): bool
    {
        if ($this->parentPid <= 0) {
            return false;
        }
        if (function_exists('posix_kill')) {
            /** @var bool $alive */
            $alive = @posix_kill($this->parentPid, 0);
            return !$alive;
        }
        return false;
    }

    /** @param resource $conn */
    private function handleConnection($conn): void
    {
        stream_set_blocking($conn, true);

        while (true) {
            $payload = $this->readFrame($conn);
            if ($payload === null) {
                break;
            }

            $req = json_decode($payload, true);
            if (!is_array($req)) {
                $this->writeFrame(
                    $conn,
                    json_encode(
                        [
                            "id" => "",
                            "status" => 400,
                            "headers" => [
                                "content-type" => "text/plain; charset=utf-8",
                            ],
                            "body" => "Bad Request: invalid JSON",
                        ],
                        JSON_UNESCAPED_UNICODE,
                    ),
                );
                continue;
            }

            $result = $this->dispatchRequestResult($req);
            $id = (string) ($req["id"] ?? "");
            if ($result instanceof StreamResponse) {
                $this->writeStreamResponse($conn, $id, $result);
                continue;
            }
            if (!is_array($result)) {
                $result = $this->res($id, 500, "Internal Server Error", [
                    "x-worker-error" => "Invalid worker response type",
                    "x-worker-error-class" => "app_contract_error",
                ]);
            }
            $this->writeFrame($conn, json_encode($result, JSON_UNESCAPED_UNICODE));
        }

        fclose($conn);
    }

    /**
     * @param array<string,mixed> $req
     * @return array<string,mixed>
     */
    public function dispatchRequest(array $req): array
    {
        $id = (string) ($req["id"] ?? "");
        $result = $this->dispatchRequestResult($req);
        if ($result instanceof StreamResponse) {
            return $this->res($id, 500, "Streaming response requires vhttpd stream mode", [
                "x-worker-error-class" => "app_contract_error",
            ]);
        }
        if (!is_array($result)) {
            return $this->res($id, 500, "Internal Server Error", [
                "x-worker-error-class" => "app_contract_error",
            ]);
        }
        return $result;
    }

    /** @param array<string,mixed> $req */
    private function dispatchRequestResult(array $req): mixed
    {
        $id = (string) ($req["id"] ?? "");
        $envelope = $this->normalizeRequestEnvelope($req);
        $method = strtoupper((string) ($envelope["method"] ?? "GET"));
        $path = (string) ($envelope["path"] ?? "/");
        $query = $this->readAssocMap($envelope, "query");
        $body = (string) ($envelope["body"] ?? "");

        try {
            $appHandler = $this->loadAppHandler();
            if ($appHandler !== null) {
                $psrRequest = \VHttpd\Psr7Bridge::canBuildServerRequest()
                    ? \VHttpd\Psr7Bridge::buildServerRequest($envelope)
                    : null;
                $appResult = $this->dispatchLoadedApp(
                    $appHandler,
                    $psrRequest,
                    $envelope,
                );
                if ($appResult instanceof StreamResponse) {
                    return $appResult;
                }
                return $this->normalizeAppResponse($id, $appResult);
            }

            if (function_exists("vslim_handle_request")) {
                $res = vslim_handle_request($envelope);
                if (is_array($res)) {
                    return [
                        "id" => $id,
                        "status" => (int) ($res["status"] ?? 500),
                        "content_type" =>
                            (string) ($res["content_type"] ??
                                "text/plain; charset=utf-8"),
                        "headers" => [
                            "content-type" =>
                                (string) ($res["content_type"] ??
                                    "text/plain; charset=utf-8"),
                        ],
                        "body" => (string) ($res["body"] ?? ""),
                    ];
                }
            }

            if (\VHttpd\Psr7Bridge::canBuildServerRequest()) {
                $psrRequest = \VHttpd\Psr7Bridge::buildServerRequest($envelope);
                if ($psrRequest !== null) {
                    return $this->resJson($id, 200, [
                        "psr7" => true,
                        "class" => get_class($psrRequest),
                        "method" => $psrRequest->method ?? "",
                        "uri" => $psrRequest->uri ?? "",
                    ]);
                }
            }

            if ($path === "/health") {
                if ($method !== "GET") {
                    return $this->res($id, 405, "Method Not Allowed");
                }
                return $this->res($id, 200, "OK");
            }

            if (preg_match('#^/users/([^/]+)$#', $path, $m) === 1) {
                if ($method !== "GET") {
                    return $this->res($id, 405, "Method Not Allowed");
                }
                $uid = $m[1];
                return $this->resJson($id, 200, [
                    "user" => $uid,
                    "source" => "php-worker",
                    "query" => $query,
                ]);
            }

            if ($path === "/echo") {
                if ($method !== "POST") {
                    return $this->res($id, 405, "Method Not Allowed");
                }
                return $this->resJson($id, 200, [
                    "echo" => $body,
                ]);
            }

            if ($path === "/panic") {
                throw new RuntimeException("synthetic worker panic");
            }

            return $this->res($id, 404, "Not Found");
        } catch (Throwable $e) {
            $errorClass = $this->classifyThrowable($e);
            return $this->res($id, 500, "Internal Server Error", [
                "x-worker-error" => $e->getMessage(),
                "x-worker-error-class" => $errorClass,
                "x-worker-exception" => get_class($e),
            ]);
        }
    }

    /** @param resource $conn */
    private function writeStreamResponse($conn, string $id, StreamResponse $stream): void
    {
        $headers = $this->normalizeHeaderMap($stream->headers);
        if (!isset($headers["content-type"])) {
            $headers["content-type"] = $stream->contentType;
        }

        $this->writeFrame(
            $conn,
            json_encode(
                [
                    "mode" => "stream",
                    "event" => "start",
                    "id" => $id,
                    "status" => $stream->status,
                    "stream_type" => $stream->streamType,
                    "content_type" => $headers["content-type"],
                    "headers" => $headers,
                ],
                JSON_UNESCAPED_UNICODE,
            ),
        );

        try {
            foreach ($stream->chunks as $chunk) {
                $frame = [
                    "mode" => "stream",
                    "event" => "chunk",
                    "id" => $id,
                    "data" => "",
                ];
                if ($stream->streamType === "sse") {
                    if (is_array($chunk)) {
                        $frame["sse_id"] = (string) ($chunk["id"] ?? "");
                        $frame["sse_event"] = (string) ($chunk["event"] ?? "");
                        $frame["sse_retry"] = (int) ($chunk["retry"] ?? 0);
                        $frame["data"] = (string) ($chunk["data"] ?? "");
                    } else {
                        $frame["sse_event"] = "message";
                        $frame["data"] = (string) $chunk;
                    }
                } else {
                    $frame["data"] = is_array($chunk)
                        ? (string) ($chunk["data"] ?? "")
                        : (string) $chunk;
                }

                $this->writeFrame(
                    $conn,
                    json_encode($frame, JSON_UNESCAPED_UNICODE),
                );
            }
        } catch (Throwable $e) {
            $this->writeFrame(
                $conn,
                json_encode(
                    [
                        "mode" => "stream",
                        "event" => "error",
                        "id" => $id,
                        "error_class" => $this->classifyThrowable($e),
                        "error" => $e->getMessage(),
                    ],
                    JSON_UNESCAPED_UNICODE,
                ),
            );
        }

        $this->writeFrame(
            $conn,
            json_encode(
                [
                    "mode" => "stream",
                    "event" => "end",
                    "id" => $id,
                ],
                JSON_UNESCAPED_UNICODE,
            ),
        );
    }

    /**
     * @param array<string,mixed> $req
     * @return array<string,mixed>
     */
    private function normalizeRequestEnvelope(array $req): array
    {
        $method = strtoupper((string) ($req["method"] ?? "GET"));
        $path = (string) ($req["path"] ?? "/");
        $query = $this->readAssocMap($req, "query");
        $headers = $this->normalizeHeaderMap($this->readAssocMap($req, "headers"));
        $cookies = $this->readAssocMap($req, "cookies");
        $attributes = $this->readAssocMap($req, "attributes");
        $server = $this->readAssocMap($req, "server");
        $uploadedFiles = $this->readList($req, "uploaded_files");

        return [
            "method" => $method,
            "path" => $this->rebuildPath($path, $query),
            "body" => (string) ($req["body"] ?? ""),
            "scheme" => (string) ($req["scheme"] ?? "http"),
            "host" => (string) ($req["host"] ?? ""),
            "port" => (string) ($req["port"] ?? ""),
            "protocol_version" => (string) ($req["protocol_version"] ?? "1.1"),
            "remote_addr" => (string) ($req["remote_addr"] ?? ""),
            "query" => $query,
            "headers" => $headers,
            "cookies" => $cookies,
            "attributes" => $attributes,
            "server" => $server,
            "uploaded_files" => $uploadedFiles,
        ];
    }

    /** @return mixed */
    private function loadAppHandler(): mixed
    {
        if ($this->appLoaded) {
            return $this->appHandler;
        }
        $this->appLoaded = true;

        $path = $this->resolveAppBootstrapPath();
        if ($path === null || !is_file($path)) {
            return $this->appHandler = null;
        }

        clearstatcache(true, $path);
        if (function_exists('opcache_invalidate')) {
            @opcache_invalidate($path, true);
        }

        $loaded = require $path;
        if (is_callable($loaded)) {
            return $this->appHandler = $loaded;
        }
        $psr15Stack = $this->buildPsr15DispatcherFromBootstrap($loaded);
        if ($psr15Stack !== null) {
            return $this->appHandler = $psr15Stack;
        }
        if (is_object($loaded) && $this->isPsr15RequestHandler($loaded)) {
            return $this->appHandler = $loaded;
        }
        if (is_object($loaded) && $loaded instanceof VSlim\App) {
            return $this->appHandler = $loaded;
        }
        if (function_exists("vslim_httpd_app")) {
            /** @var callable $fn */
            $fn = "vslim_httpd_app";
            return $this->appHandler = $fn;
        }
        return $this->appHandler = null;
    }

    private function dispatchLoadedApp(
        mixed $appHandler,
        ?object $psrRequest,
        array $envelope,
    ): mixed {
        if ($this->isPsr15RequestHandler($appHandler)) {
            if ($psrRequest === null) {
                throw new RuntimeException(
                    "PSR-15 handler requires a PSR-7 request object",
                );
            }
            return $appHandler->handle($psrRequest);
        }
        if (is_callable($appHandler)) {
            return $psrRequest !== null
                ? $appHandler($psrRequest, $envelope)
                : $appHandler($envelope);
        }
        if (is_object($appHandler) && $appHandler instanceof VSlim\App) {
            if ($psrRequest !== null) {
                return \VHttpd\SlimPsr7Adapter::dispatch($appHandler, $psrRequest);
            }
            return $appHandler->dispatch_envelope($envelope);
        }
        throw new RuntimeException("Unsupported app bootstrap result");
    }

    private function isPsr15RequestHandler(mixed $value): bool
    {
        if (!is_object($value)) {
            return false;
        }
        return interface_exists("Psr\\Http\\Server\\RequestHandlerInterface")
            && is_a($value, "Psr\\Http\\Server\\RequestHandlerInterface");
    }

    private function isPsr15Middleware(mixed $value): bool
    {
        if (!is_object($value)) {
            return false;
        }
        return interface_exists("Psr\\Http\\Server\\MiddlewareInterface")
            && is_a($value, "Psr\\Http\\Server\\MiddlewareInterface");
    }

    /** @return list<object> */
    private function normalizePsr15Middlewares(array $items): array
    {
        $middlewares = [];
        foreach ($items as $item) {
            if ($this->isPsr15Middleware($item)) {
                $middlewares[] = $item;
            }
        }
        return $middlewares;
    }

    private function buildPsr15DispatcherFromBootstrap(mixed $loaded): ?object
    {
        if (
            !interface_exists("Psr\\Http\\Server\\RequestHandlerInterface") ||
            !interface_exists("Psr\\Http\\Server\\MiddlewareInterface") ||
            !is_array($loaded)
        ) {
            return null;
        }

        $handler = null;
        $middlewaresRaw = [];
        if (array_key_exists("handler", $loaded)) {
            $handler = $loaded["handler"];
        }
        if (array_key_exists("middlewares", $loaded) && is_array($loaded["middlewares"])) {
            $middlewaresRaw = $loaded["middlewares"];
        } else {
            foreach ($loaded as $value) {
                if ($this->isPsr15Middleware($value)) {
                    $middlewaresRaw[] = $value;
                }
                if ($handler === null && $this->isPsr15RequestHandler($value)) {
                    $handler = $value;
                }
            }
        }

        if (!$this->isPsr15RequestHandler($handler)) {
            return null;
        }
        $middlewares = $this->normalizePsr15Middlewares($middlewaresRaw);
        if ($middlewares === []) {
            return null;
        }

        return $this->createPsr15Dispatcher($handler, $middlewares);
    }

    /** @param list<object> $middlewares */
    private function createPsr15Dispatcher(object $handler, array $middlewares): object
    {
        return new class ($handler, $middlewares) implements \Psr\Http\Server\RequestHandlerInterface {
            /** @param list<object> $middlewares */
            public function __construct(
                private object $handler,
                private array $middlewares,
            ) {}

            public function handle(\Psr\Http\Message\ServerRequestInterface $request): \Psr\Http\Message\ResponseInterface
            {
                return $this->dispatch($request, 0);
            }

            public function dispatch(
                \Psr\Http\Message\ServerRequestInterface $request,
                int $index,
            ): \Psr\Http\Message\ResponseInterface {
                if ($index >= count($this->middlewares)) {
                    /** @var \Psr\Http\Server\RequestHandlerInterface $h */
                    $h = $this->handler;
                    return $h->handle($request);
                }

                /** @var \Psr\Http\Server\MiddlewareInterface $mw */
                $mw = $this->middlewares[$index];
                $next = new class ($this, $index + 1) implements \Psr\Http\Server\RequestHandlerInterface {
                    public function __construct(
                        private object $dispatcher,
                        private int $nextIndex,
                    ) {}

                    public function handle(
                        \Psr\Http\Message\ServerRequestInterface $request,
                    ): \Psr\Http\Message\ResponseInterface {
                        $dispatcher = $this->dispatcher;
                        return $dispatcher->dispatch($request, $this->nextIndex);
                    }
                };

                return $mw->process($request, $next);
            }
        };
    }

    /**
     * @param array<string,mixed> $input
     * @return array<string,string>
     */
    private function readAssocMap(array $input, string $key): array
    {
        $raw = $input[$key] ?? [];
        if (!is_array($raw)) {
            return [];
        }
        $out = [];
        foreach ($raw as $name => $value) {
            if (is_array($value)) {
                $out[(string) $name] = implode(", ", array_map("strval", $value));
            } else {
                $out[(string) $name] = (string) $value;
            }
        }
        return $out;
    }

    /**
     * @param array<string,mixed> $input
     * @return list<string>
     */
    private function readList(array $input, string $key): array
    {
        $raw = $input[$key] ?? [];
        if (!is_array($raw)) {
            return [];
        }
        return array_values(array_map("strval", $raw));
    }

    private function resolveAppBootstrapPath(): ?string
    {
        $env = getenv("VSLIM_HTTPD_APP");
        if (is_string($env) && $env !== "") {
            return $env;
        }
        if (
            $this->appBootstrapPath !== null &&
            $this->appBootstrapPath !== ""
        ) {
            return $this->appBootstrapPath;
        }
        return __DIR__ . "/app.php";
    }

    /**
     * @param mixed $result
     * @return array<string,mixed>
     */
    private function normalizeAppResponse(string $id, mixed $result): array
    {
        if (is_array($result)) {
            $headers = $this->normalizeHeaderMap(
                isset($result["headers"]) && is_array($result["headers"])
                    ? $result["headers"]
                    : [],
            );
            $body = (string) ($result["body"] ?? "");
            $contentType =
                (string) ($result["content_type"] ??
                    ($headers["content-type"] ?? "text/plain; charset=utf-8"));
            return $this->buildNormalizedResponse(
                $id,
                (int) ($result["status"] ?? 200),
                $body,
                $headers,
                $contentType,
            );
        }

        if (is_string($result)) {
            return $this->res($id, 200, $result);
        }

        if (is_object($result) && $result instanceof VSlim\Response) {
            $headers = [];
            if (function_exists("vslim_response_headers")) {
                $headers = $this->normalizeHeaderMap((array) vslim_response_headers($result));
            }
            $body = (string) ($result->body ?? "");
            $contentType =
                (string) ($result->content_type ??
                    ($headers["content-type"] ?? "text/plain; charset=utf-8"));
            return $this->buildNormalizedResponse(
                $id,
                (int) ($result->status ?? 200),
                $body,
                $headers,
                $contentType,
            );
        }

        if (
            is_object($result) &&
            method_exists($result, "getStatusCode") &&
            method_exists($result, "getHeaders") &&
            method_exists($result, "getBody")
        ) {
            $status = (int) $result->getStatusCode();
            $headers = $this->normalizeHeaderMap((array) $result->getHeaders());
            $body = $this->stringifyBody($result->getBody());
            $contentType =
                (string) ($headers["content-type"] ??
                    "text/plain; charset=utf-8");
            return $this->buildNormalizedResponse(
                $id,
                $status,
                $body,
                $headers,
                $contentType,
            );
        }

        return $this->res($id, 500, "Internal Server Error", [
            "x-worker-error" => "Unsupported app response type",
            "x-worker-error-class" => "app_contract_error",
        ]);
    }

    /**
     * @param array<string,mixed> $headers
     * @return array<string,string>
     */
    private function normalizeHeaderMap(array $headers): array
    {
        $out = [];
        foreach ($headers as $name => $value) {
            $key = strtolower((string) $name);
            if (is_array($value)) {
                $out[$key] = implode(", ", array_map("strval", $value));
            } else {
                $out[$key] = (string) $value;
            }
        }
        return $out;
    }

    private function classifyThrowable(Throwable $e): string
    {
        if (
            $e instanceof TypeError
            || $e instanceof InvalidArgumentException
            || $e instanceof LogicException
        ) {
            return "app_contract_error";
        }
        return "worker_runtime_error";
    }

    private function stringifyBody(mixed $body): string
    {
        if (is_string($body)) {
            return $body;
        }
        if (is_object($body)) {
            if (method_exists($body, "rewind")) {
                try {
                    $body->rewind();
                } catch (Throwable) {
                }
            }
            if (method_exists($body, "getContents")) {
                return (string) $body->getContents();
            }
            if (method_exists($body, "__toString")) {
                return (string) $body;
            }
        }
        return (string) $body;
    }

    /**
     * @param array<string,string> $headers
     * @return array<string,mixed>
     */
    private function buildNormalizedResponse(
        string $id,
        int $status,
        string $body,
        array $headers,
        string $contentType,
    ): array {
        if (!isset($headers["content-type"])) {
            $headers["content-type"] = $contentType;
        }
        if (!isset($headers["content-length"])) {
            $headers["content-length"] = (string) strlen($body);
        }
        return [
            "id" => $id,
            "status" => $status,
            "content_type" => $headers["content-type"],
            "headers" => $headers,
            "body" => $body,
        ];
    }

    /** @param array<string,mixed> $query */
    private function rebuildPath(string $path, array $query): string
    {
        if ($query === [] || str_contains($path, "?")) {
            return $path;
        }
        return $path . "?" . http_build_query($query);
    }

    /**
     * @param array<string,string> $headers
     * @return array<string,mixed>
     */
    private function res(
        string $id,
        int $status,
        string $body,
        array $headers = [],
    ): array {
        return [
            "id" => $id,
            "status" => $status,
            "headers" => $headers + [
                "content-type" => "text/plain; charset=utf-8",
            ],
            "body" => $body,
        ];
    }

    /**
     * @param array<string,mixed> $data
     * @return array<string,mixed>
     */
    private function resJson(string $id, int $status, array $data): array
    {
        return [
            "id" => $id,
            "status" => $status,
            "headers" => ["content-type" => "application/json; charset=utf-8"],
            "body" => json_encode($data, JSON_UNESCAPED_UNICODE),
        ];
    }

    /** @param resource $conn */
    private function readFrame($conn): ?string
    {
        $header = $this->readExactly($conn, 4);
        if ($header === null) {
            return null;
        }
        $len = unpack("Nlen", $header);
        $size = (int) ($len["len"] ?? 0);
        if ($size <= 0 || $size > 16 * 1024 * 1024) {
            return null;
        }
        return $this->readExactly($conn, $size);
    }

    /** @param resource $conn */
    private function writeFrame($conn, string $payload): void
    {
        $header = pack("N", strlen($payload));
        fwrite($conn, $header . $payload);
    }

    /** @param resource $conn */
    private function readExactly($conn, int $len): ?string
    {
        $buf = "";
        while (strlen($buf) < $len) {
            $chunk = fread($conn, $len - strlen($buf));
            if ($chunk === "" || $chunk === false) {
                return null;
            }
            $buf .= $chunk;
        }
        return $buf;
    }

    private function prepareSocketPath(): void
    {
        @mkdir(dirname($this->socketPath), 0777, true);
        if (file_exists($this->socketPath)) {
            @unlink($this->socketPath);
        }
    }
}

function parseSocketFromArgv(array $argv): string
{
    for ($i = 1; $i < count($argv); $i++) {
        if ($argv[$i] === "--socket" && isset($argv[$i + 1])) {
            return (string) $argv[$i + 1];
        }
        if (str_starts_with((string) $argv[$i], "--socket=")) {
            return substr((string) $argv[$i], 9);
        }
    }
    return "/tmp/vphp_worker.sock";
}
