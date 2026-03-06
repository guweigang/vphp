<?php

declare(strict_types=1);

namespace VHttpd\PhpWorker;

final class Client
{
    public function __construct(
        private string $socketPath,
        private float $connectTimeoutSeconds = 2.0,
    ) {
    }

    /** @param array<string,mixed> $request */
    public function request(array $request): array
    {
        $uri = 'unix://' . $this->socketPath;
        $errno = 0;
        $errstr = '';
        $conn = @stream_socket_client($uri, $errno, $errstr, $this->connectTimeoutSeconds);
        if (!is_resource($conn)) {
            throw new \RuntimeException("connect_failed: {$errstr} ({$errno})");
        }

        $payload = json_encode($request, JSON_UNESCAPED_UNICODE);
        if (!is_string($payload)) {
            fclose($conn);
            throw new \RuntimeException('json_encode_failed');
        }

        self::writeFrame($conn, $payload);
        $raw = self::readFrame($conn);
        fclose($conn);

        if ($raw === null) {
            throw new \RuntimeException('empty_response');
        }

        $decoded = json_decode($raw, true);
        if (!is_array($decoded)) {
            throw new \RuntimeException('invalid_response_json');
        }
        return $decoded;
    }

    /** @param resource $conn */
    public static function writeFrame($conn, string $payload): void
    {
        fwrite($conn, pack('N', strlen($payload)) . $payload);
    }

    /** @param resource $conn */
    public static function readExactly($conn, int $len): ?string
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

    /** @param resource $conn */
    public static function readFrame($conn): ?string
    {
        $header = self::readExactly($conn, 4);
        if ($header === null) {
            return null;
        }
        $len = unpack('Nlen', $header);
        $size = (int) ($len['len'] ?? 0);
        if ($size <= 0) {
            return null;
        }
        return self::readExactly($conn, $size);
    }
}
