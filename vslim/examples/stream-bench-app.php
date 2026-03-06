<?php
declare(strict_types=1);

/**
 * Deterministic stream benchmark app (no model dependency).
 *
 * Endpoints:
 * - GET /bench/health
 * - GET /bench/stream?mode=sse|text&tokens=80&interval_ms=5&chunk_size=24
 */
return static function (mixed $request, array $envelope = []): array|WorkerStreamResponse {
    $src = is_array($request) ? $request : $envelope;
    $pathWithQuery = (string) ($src['path'] ?? '/');
    $path = (string) (parse_url($pathWithQuery, PHP_URL_PATH) ?? '/');
    $query = is_array($src['query'] ?? null) ? $src['query'] : [];
    $method = strtoupper((string) ($src['method'] ?? 'GET'));

    if ($path === '/bench/health') {
        return [
            'status' => 200,
            'content_type' => 'text/plain; charset=utf-8',
            'body' => 'OK',
        ];
    }

    if ($path !== '/bench/stream') {
        return [
            'status' => 404,
            'content_type' => 'text/plain; charset=utf-8',
            'body' => 'Not Found',
        ];
    }

    if ($method !== 'GET') {
        return [
            'status' => 405,
            'content_type' => 'text/plain; charset=utf-8',
            'body' => 'Method Not Allowed',
        ];
    }

    $mode = strtolower((string) ($query['mode'] ?? 'sse'));
    $tokens = max(1, min(5000, (int) ($query['tokens'] ?? 80)));
    $intervalMs = max(0, min(1000, (int) ($query['interval_ms'] ?? 5)));
    $chunkSize = max(1, min(4096, (int) ($query['chunk_size'] ?? 24)));
    $payload = str_repeat('x', $chunkSize);

    if ($mode === 'text') {
        $chunks = (function () use ($tokens, $intervalMs, $payload): Generator {
            for ($i = 1; $i <= $tokens; $i++) {
                if ($intervalMs > 0) {
                    usleep($intervalMs * 1000);
                }
                yield sprintf("%05d:%s\n", $i, $payload);
            }
        })();

        return vhttpd_stream_text(
            $chunks,
            200,
            'text/plain; charset=utf-8',
            ['x-bench-stream' => 'text']
        );
    }

    $events = (function () use ($tokens, $intervalMs, $payload): Generator {
        for ($i = 1; $i <= $tokens; $i++) {
            if ($intervalMs > 0) {
                usleep($intervalMs * 1000);
            }
            yield [
                'id' => 'tok-' . $i,
                'event' => 'token',
                'retry' => 1000,
                'data' => sprintf("%05d:%s", $i, $payload),
            ];
        }
        yield [
            'id' => 'done',
            'event' => 'done',
            'retry' => 1000,
            'data' => 'done',
        ];
    })();

    return vhttpd_stream_sse($events, 200, ['x-bench-stream' => 'sse']);
};
