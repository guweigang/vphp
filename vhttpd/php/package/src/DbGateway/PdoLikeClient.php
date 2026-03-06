<?php

declare(strict_types=1);

namespace VHttpd\DbGateway;

use RuntimeException;

/**
 * PDO-like client for vhttpd DB gateway over unix socket frames.
 *
 * Expected request shape:
 * - {"id":"...","op":"db.query|db.execute|db.begin|db.commit|db.rollback","args":{...}}
 *
 * Expected response shape:
 * - {"ok":true,"result":{...}}
 * - {"ok":false,"error":{"code":"...","message":"..."}}
 */
final class PdoLikeClient
{
    /** @var resource|null */
    private $conn = null;

    private ?string $txId = null;
    private ?string $lastInsertId = null;

    public function __construct(
        private string $socketPath,
        private float $connectTimeoutSeconds = 1.0,
        private float $readTimeoutSeconds = 5.0,
    ) {
    }

    public function __destruct()
    {
        $this->close();
    }

    public function connect(): void
    {
        if (is_resource($this->conn)) {
            return;
        }

        $uri = 'unix://' . $this->socketPath;
        $errno = 0;
        $errstr = '';
        $conn = @stream_socket_client($uri, $errno, $errstr, $this->connectTimeoutSeconds);
        if (!is_resource($conn)) {
            throw new RuntimeException("db_gateway_connect_failed: {$errstr} ({$errno})");
        }

        stream_set_blocking($conn, true);
        stream_set_timeout(
            $conn,
            (int) floor($this->readTimeoutSeconds),
            (int) (($this->readTimeoutSeconds - floor($this->readTimeoutSeconds)) * 1_000_000),
        );
        $this->conn = $conn;
    }

    public function close(): void
    {
        if (!is_resource($this->conn)) {
            return;
        }
        @fclose($this->conn);
        $this->conn = null;
        $this->txId = null;
    }

    public function inTransaction(): bool
    {
        return $this->txId !== null;
    }

    public function beginTransaction(): bool
    {
        if ($this->txId !== null) {
            throw new RuntimeException('transaction_already_started');
        }

        $result = $this->call('db.begin', []);
        $txId = (string) ($result['tx_id'] ?? '');
        if ($txId === '') {
            throw new RuntimeException('db_begin_missing_tx_id');
        }
        $this->txId = $txId;
        return true;
    }

    public function commit(): bool
    {
        if ($this->txId === null) {
            throw new RuntimeException('no_active_transaction');
        }
        $this->call('db.commit', ['tx_id' => $this->txId]);
        $this->txId = null;
        return true;
    }

    public function rollBack(): bool
    {
        if ($this->txId === null) {
            throw new RuntimeException('no_active_transaction');
        }
        $this->call('db.rollback', ['tx_id' => $this->txId]);
        $this->txId = null;
        return true;
    }

    public function query(string $sql, array $bindings = [], int $timeoutMs = 1000): Statement
    {
        $args = [
            'sql' => $sql,
            'bindings' => array_values($bindings),
            'timeout_ms' => $timeoutMs,
        ];
        if ($this->txId !== null) {
            $args['tx_id'] = $this->txId;
        }

        $result = $this->call('db.query', $args);
        $rows = $this->normalizeRows($result['rows'] ?? []);
        return new Statement(
            $rows,
            (int) ($result['row_count'] ?? count($rows)),
            isset($result['last_insert_id']) ? (string) $result['last_insert_id'] : null,
        );
    }

    public function execute(string $sql, array $bindings = [], int $timeoutMs = 1000): int
    {
        $args = [
            'sql' => $sql,
            'bindings' => array_values($bindings),
            'timeout_ms' => $timeoutMs,
        ];
        if ($this->txId !== null) {
            $args['tx_id'] = $this->txId;
        }

        $result = $this->call('db.execute', $args);
        $this->lastInsertId = isset($result['last_insert_id']) ? (string) $result['last_insert_id'] : null;
        return (int) ($result['affected_rows'] ?? 0);
    }

    public function lastInsertId(): ?string
    {
        return $this->lastInsertId;
    }

    public function ping(): bool
    {
        $this->call('db.ping', []);
        return true;
    }

    /** @param array<string,mixed> $args
     *  @return array<string,mixed>
     */
    private function call(string $op, array $args): array
    {
        $this->connect();

        $request = [
            'id' => sprintf('db-%d-%d', (int) (microtime(true) * 1_000_000), random_int(1000, 9999)),
            'op' => $op,
            'args' => $args,
        ];

        $this->writeFrame($request);
        $resp = $this->readFrame();

        $ok = (bool) ($resp['ok'] ?? false);
        if ($ok) {
            $result = $resp['result'] ?? [];
            return is_array($result) ? $result : [];
        }

        $err = is_array($resp['error'] ?? null) ? $resp['error'] : [];
        $code = (string) ($err['code'] ?? 'DB_GATEWAY_ERROR');
        $message = (string) ($err['message'] ?? 'db gateway call failed');
        throw new RuntimeException("{$code}: {$message}");
    }

    /** @param array<string,mixed> $payload */
    private function writeFrame(array $payload): void
    {
        if (!is_resource($this->conn)) {
            throw new RuntimeException('connection_not_open');
        }

        $json = json_encode($payload, JSON_UNESCAPED_UNICODE);
        if (!is_string($json)) {
            throw new RuntimeException('json_encode_failed');
        }

        $packet = pack('N', strlen($json)) . $json;
        $written = fwrite($this->conn, $packet);
        if (!is_int($written) || $written !== strlen($packet)) {
            $this->close();
            throw new RuntimeException('db_gateway_write_failed');
        }
    }

    /** @return array<string,mixed> */
    private function readFrame(): array
    {
        if (!is_resource($this->conn)) {
            throw new RuntimeException('connection_not_open');
        }

        $header = $this->readExactly(4);
        $lenInfo = unpack('Nlen', $header);
        $size = (int) ($lenInfo['len'] ?? 0);
        if ($size <= 0 || $size > 16 * 1024 * 1024) {
            $this->close();
            throw new RuntimeException('db_gateway_invalid_frame_size');
        }

        $raw = $this->readExactly($size);
        $decoded = json_decode($raw, true);
        if (!is_array($decoded)) {
            throw new RuntimeException('db_gateway_invalid_response_json');
        }

        return $decoded;
    }

    private function readExactly(int $len): string
    {
        if (!is_resource($this->conn)) {
            throw new RuntimeException('connection_not_open');
        }

        $buf = '';
        while (strlen($buf) < $len) {
            $chunk = fread($this->conn, $len - strlen($buf));
            if ($chunk === '' || $chunk === false) {
                $meta = stream_get_meta_data($this->conn);
                $this->close();
                if (($meta['timed_out'] ?? false) === true) {
                    throw new RuntimeException('db_gateway_read_timeout');
                }
                throw new RuntimeException('db_gateway_unexpected_eof');
            }
            $buf .= $chunk;
        }
        return $buf;
    }

    /**
     * @param mixed $rows
     * @return list<array<string,mixed>>
     */
    private function normalizeRows(mixed $rows): array
    {
        if (!is_array($rows)) {
            return [];
        }
        $out = [];
        foreach ($rows as $row) {
            if (!is_array($row)) {
                continue;
            }
            $normalized = [];
            foreach ($row as $k => $v) {
                $normalized[(string) $k] = $v;
            }
            $out[] = $normalized;
        }
        return $out;
    }
}
