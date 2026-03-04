<?php

declare(strict_types=1);

require_once __DIR__ . '/psr7_bridge.php';

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
    /** @var resource|null */
    private $server = null;

    public function __construct(string $socketPath)
    {
        $this->socketPath = $socketPath;
    }

    public function run(): void
    {
        $this->prepareSocketPath();
        $uri = 'unix://' . $this->socketPath;
        $errno = 0;
        $errstr = '';

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
                $this->writeFrame($conn, json_encode([
                    'id' => '',
                    'status' => 400,
                    'headers' => ['content-type' => 'text/plain; charset=utf-8'],
                    'body' => 'Bad Request: invalid JSON',
                ], JSON_UNESCAPED_UNICODE));
                continue;
            }

            $res = $this->dispatch($req);
            $this->writeFrame($conn, json_encode($res, JSON_UNESCAPED_UNICODE));
        }

        fclose($conn);
    }

    /**
     * @param array<string,mixed> $req
     * @return array<string,mixed>
     */
    private function dispatch(array $req): array
    {
        $id = (string)($req['id'] ?? '');
        $method = strtoupper((string)($req['method'] ?? 'GET'));
        $path = (string)($req['path'] ?? '/');
        $query = isset($req['query']) && is_array($req['query']) ? $req['query'] : [];
        $body = (string)($req['body'] ?? '');

        if (function_exists('vslim_handle_request')) {
            $envelope = [
                'method' => $method,
                'path' => $this->rebuildPath($path, $query),
                'body' => $body,
                'scheme' => (string)($req['scheme'] ?? 'http'),
                'host' => (string)($req['host'] ?? ''),
                'port' => (string)($req['port'] ?? ''),
                'protocol_version' => (string)($req['protocol_version'] ?? '1.1'),
                'remote_addr' => (string)($req['remote_addr'] ?? ''),
                'query_json' => json_encode($query, JSON_UNESCAPED_UNICODE),
                'headers_json' => json_encode(isset($req['headers']) && is_array($req['headers']) ? $req['headers'] : [], JSON_UNESCAPED_UNICODE),
                'cookies_json' => json_encode(isset($req['cookies']) && is_array($req['cookies']) ? $req['cookies'] : [], JSON_UNESCAPED_UNICODE),
                'attributes_json' => json_encode(isset($req['attributes']) && is_array($req['attributes']) ? $req['attributes'] : [], JSON_UNESCAPED_UNICODE),
                'server_json' => json_encode(isset($req['server']) && is_array($req['server']) ? $req['server'] : [], JSON_UNESCAPED_UNICODE),
                'uploaded_files_json' => json_encode(isset($req['uploaded_files']) && is_array($req['uploaded_files']) ? $req['uploaded_files'] : [], JSON_UNESCAPED_UNICODE),
            ];

            try {
                $res = vslim_handle_request($envelope);
                if (is_array($res)) {
                    return [
                        'id' => $id,
                        'status' => (int)($res['status'] ?? 500),
                        'content_type' => (string)($res['content_type'] ?? 'text/plain; charset=utf-8'),
                        'headers' => ['content-type' => (string)($res['content_type'] ?? 'text/plain; charset=utf-8')],
                        'body' => (string)($res['body'] ?? ''),
                    ];
                }
            } catch (Throwable $e) {
                return $this->res($id, 500, 'Internal Server Error', [
                    'x-worker-error' => $e->getMessage(),
                ]);
            }
        }

        try {
            if (VHttpdPsr7Bridge::canBuildServerRequest()) {
                $psrRequest = VHttpdPsr7Bridge::buildServerRequest([
                    'method' => $method,
                    'path' => $this->rebuildPath($path, $query),
                    'body' => $body,
                    'scheme' => (string)($req['scheme'] ?? 'http'),
                    'host' => (string)($req['host'] ?? ''),
                    'port' => (string)($req['port'] ?? ''),
                    'protocol_version' => (string)($req['protocol_version'] ?? '1.1'),
                    'remote_addr' => (string)($req['remote_addr'] ?? ''),
                    'query_json' => json_encode($query, JSON_UNESCAPED_UNICODE),
                    'headers_json' => json_encode(isset($req['headers']) && is_array($req['headers']) ? $req['headers'] : [], JSON_UNESCAPED_UNICODE),
                    'cookies_json' => json_encode(isset($req['cookies']) && is_array($req['cookies']) ? $req['cookies'] : [], JSON_UNESCAPED_UNICODE),
                    'attributes_json' => json_encode(isset($req['attributes']) && is_array($req['attributes']) ? $req['attributes'] : [], JSON_UNESCAPED_UNICODE),
                    'server_json' => json_encode(isset($req['server']) && is_array($req['server']) ? $req['server'] : [], JSON_UNESCAPED_UNICODE),
                    'uploaded_files_json' => json_encode(isset($req['uploaded_files']) && is_array($req['uploaded_files']) ? $req['uploaded_files'] : [], JSON_UNESCAPED_UNICODE),
                ]);
                if ($psrRequest !== null) {
                    return $this->resJson($id, 200, [
                        'psr7' => true,
                        'class' => get_class($psrRequest),
                        'method' => $psrRequest->method ?? '',
                        'uri' => $psrRequest->uri ?? '',
                    ]);
                }
            }

            if ($path === '/health') {
                if ($method !== 'GET') {
                    return $this->res($id, 405, 'Method Not Allowed');
                }
                return $this->res($id, 200, 'OK');
            }

            if (preg_match('#^/users/([^/]+)$#', $path, $m) === 1) {
                if ($method !== 'GET') {
                    return $this->res($id, 405, 'Method Not Allowed');
                }
                $uid = $m[1];
                return $this->resJson($id, 200, [
                    'user' => $uid,
                    'source' => 'php-worker',
                    'query' => $query,
                ]);
            }

            if ($path === '/echo') {
                if ($method !== 'POST') {
                    return $this->res($id, 405, 'Method Not Allowed');
                }
                return $this->resJson($id, 200, [
                    'echo' => $body,
                ]);
            }

            if ($path === '/panic') {
                throw new RuntimeException('synthetic worker panic');
            }

            return $this->res($id, 404, 'Not Found');
        } catch (Throwable $e) {
            return $this->res($id, 500, 'Internal Server Error', [
                'x-worker-error' => $e->getMessage(),
            ]);
        }
    }

    /** @param array<string,mixed> $query */
    private function rebuildPath(string $path, array $query): string
    {
        if ($query === []) {
            return $path;
        }
        return $path . '?' . http_build_query($query);
    }

    /**
     * @param array<string,string> $headers
     * @return array<string,mixed>
     */
    private function res(string $id, int $status, string $body, array $headers = []): array
    {
        return [
            'id' => $id,
            'status' => $status,
            'headers' => $headers + ['content-type' => 'text/plain; charset=utf-8'],
            'body' => $body,
        ];
    }

    /**
     * @param array<string,mixed> $data
     * @return array<string,mixed>
     */
    private function resJson(string $id, int $status, array $data): array
    {
        return [
            'id' => $id,
            'status' => $status,
            'headers' => ['content-type' => 'application/json; charset=utf-8'],
            'body' => json_encode($data, JSON_UNESCAPED_UNICODE),
        ];
    }

    /** @param resource $conn */
    private function readFrame($conn): ?string
    {
        $header = $this->readExactly($conn, 4);
        if ($header === null) {
            return null;
        }
        $len = unpack('Nlen', $header);
        $size = (int)($len['len'] ?? 0);
        if ($size <= 0 || $size > 16 * 1024 * 1024) {
            return null;
        }
        return $this->readExactly($conn, $size);
    }

    /** @param resource $conn */
    private function writeFrame($conn, string $payload): void
    {
        $header = pack('N', strlen($payload));
        fwrite($conn, $header . $payload);
    }

    /** @param resource $conn */
    private function readExactly($conn, int $len): ?string
    {
        $buf = '';
        while (strlen($buf) < $len) {
            $chunk = fread($conn, $len - strlen($buf));
            if ($chunk === '' || $chunk === false) {
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
        if ($argv[$i] === '--socket' && isset($argv[$i + 1])) {
            return (string)$argv[$i + 1];
        }
        if (str_starts_with((string)$argv[$i], '--socket=')) {
            return substr((string)$argv[$i], 9);
        }
    }
    return '/tmp/vphp_worker.sock';
}

$socketPath = parseSocketFromArgv($_SERVER['argv'] ?? []);
if (!defined('VSLIM_HTTPD_WORKER_NOAUTO')) {
    $worker = new PhpWorker($socketPath);
    $worker->run();
}
