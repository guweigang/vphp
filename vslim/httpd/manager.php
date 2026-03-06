<?php

declare(strict_types=1);

namespace VHttpd;

final class VHttpdManager
{
    private string $bin;
    private string $host;
    private int $port;
    private string $pidFile;
    private string $eventLog;
    private string $stdoutLog;

    public function __construct(
        string $bin,
        string $host,
        int $port,
        string $pidFile,
        string $eventLog,
        string $stdoutLog
    ) {
        $this->bin = $bin;
        $this->host = $host;
        $this->port = $port;
        $this->pidFile = $pidFile;
        $this->eventLog = $eventLog;
        $this->stdoutLog = $stdoutLog;
    }

    public function start(): void
    {
        if ($this->status()) {
            return;
        }
        @mkdir(dirname($this->pidFile), 0777, true);
        @mkdir(dirname($this->eventLog), 0777, true);
        @mkdir(dirname($this->stdoutLog), 0777, true);

        $cmd = sprintf(
            '%s --host %s --port %d --pid-file %s --event-log %s >> %s 2>&1 &',
            escapeshellarg($this->bin),
            escapeshellarg($this->host),
            $this->port,
            escapeshellarg($this->pidFile),
            escapeshellarg($this->eventLog),
            escapeshellarg($this->stdoutLog)
        );
        exec($cmd);
    }

    public function stop(): void
    {
        $pid = $this->pid();
        if ($pid === null) {
            return;
        }
        exec(sprintf('kill %d >/dev/null 2>&1', $pid));
    }

    public function status(): bool
    {
        $pid = $this->pid();
        if ($pid === null) {
            return false;
        }
        exec(sprintf('kill -0 %d >/dev/null 2>&1', $pid), $out, $code);
        return $code === 0;
    }

    public function waitUntilReady(float $timeoutSeconds = 5.0): bool
    {
        $deadline = microtime(true) + $timeoutSeconds;
        while (microtime(true) < $deadline) {
            $ctx = stream_context_create(['http' => ['timeout' => 0.2]]);
            $res = @file_get_contents($this->baseUrl() . '/health', false, $ctx);
            if ($res !== false && trim($res) === 'OK') {
                return true;
            }
            usleep(100_000);
        }
        return false;
    }

    /**
     * @return array<int, array<string, mixed>>
     */
    public function events(int $limit = 50): array
    {
        if (!is_file($this->eventLog)) {
            return [];
        }
        $lines = @file($this->eventLog, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        if (!is_array($lines)) {
            return [];
        }
        $lines = array_slice($lines, -$limit);
        $rows = [];
        foreach ($lines as $line) {
            $decoded = json_decode($line, true);
            if (is_array($decoded)) {
                $rows[] = $decoded;
            }
        }
        return $rows;
    }

    public function baseUrl(): string
    {
        return sprintf('http://%s:%d', $this->host, $this->port);
    }

    private function pid(): ?int
    {
        if (!is_file($this->pidFile)) {
            return null;
        }
        $raw = trim((string) @file_get_contents($this->pidFile));
        if ($raw === '' || !ctype_digit($raw)) {
            return null;
        }
        return (int) $raw;
    }
}

if (!\class_exists('VHttpdManager', false)) {
    \class_alias(\VHttpd\VHttpdManager::class, 'VHttpdManager');
}
