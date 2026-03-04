<?php

declare(strict_types=1);

require_once __DIR__ . "/psr7_bridge.php";

/**
 * PHP Worker for vhttpd proxy mode.
 *
 * Protocol:
 * - request:  [4-byte big-endian length][json payload]
 * - response: [4-byte big-endian length][json payload]
 *
 * Usage:
 *   php httpd/php-worker.php --socket /tmp/vphp_worker.sock
 */

final class PhpWorker
{
    private string $socketPath;
    private ?string $appBootstrapPath;
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
            $conn = @stream_socket_accept($this->server, -1);
            if (!is_resource($conn)) {
                continue;
            }
            $this->handleConnection($conn);
        }
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

            $res = $this->dispatchRequest($req);
            $this->writeFrame($conn, json_encode($res, JSON_UNESCAPED_UNICODE));
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
        $envelope = $this->normalizeRequestEnvelope($req);
        $method = strtoupper((string) ($envelope["method"] ?? "GET"));
        $path = (string) ($envelope["path"] ?? "/");
        $query = $this->readAssocMap($envelope, "query");
        $body = (string) ($envelope["body"] ?? "");

        try {
            $appHandler = $this->loadAppHandler();
            if ($appHandler !== null) {
                $psrRequest = VHttpdPsr7Bridge::canBuildServerRequest()
                    ? VHttpdPsr7Bridge::buildServerRequest($envelope)
                    : null;
                $appResult = $this->dispatchLoadedApp(
                    $appHandler,
                    $psrRequest,
                    $envelope,
                );
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

            if (VHttpdPsr7Bridge::canBuildServerRequest()) {
                $psrRequest = VHttpdPsr7Bridge::buildServerRequest($envelope);
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
            return $this->res($id, 500, "Internal Server Error", [
                "x-worker-error" => $e->getMessage(),
            ]);
        }
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
        if (is_object($loaded) && $loaded instanceof VSlimApp) {
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
        if (is_callable($appHandler)) {
            return $psrRequest !== null
                ? $appHandler($psrRequest, $envelope)
                : $appHandler($envelope);
        }
        if (is_object($appHandler) && $appHandler instanceof VSlimApp) {
            if ($psrRequest !== null) {
                require_once __DIR__ . "/vslim_psr7_adapter.php";
                return VSlimPsr7Adapter::dispatch($appHandler, $psrRequest);
            }
            return $appHandler->dispatch_envelope($envelope);
        }
        throw new RuntimeException("Unsupported app bootstrap result");
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

        if (is_object($result) && $result instanceof VSlimResponse) {
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

$socketPath = parseSocketFromArgv($_SERVER["argv"] ?? []);
if (!defined("VSLIM_HTTPD_WORKER_NOAUTO")) {
    $worker = new PhpWorker($socketPath);
    $worker->run();
}
