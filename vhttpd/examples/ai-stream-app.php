<?php
declare(strict_types=1);

/**
 * AI token streaming demo for vhttpd/php-worker.
 *
 * Endpoints:
 * - GET /ai/stream?prompt=...
 *   passthrough text chunks (stream_type=text)
 * - GET /ai/sse?prompt=...
 *   SSE chunks (stream_type=sse)
 */
return static function (mixed $request, array $envelope = []): array|WorkerStreamResponse {
    $req = is_array($request) ? $request : $envelope;
    $method = strtoupper((string) ($req['method'] ?? 'GET'));
    $target = (string) ($req['path'] ?? '/');
    $path = (string) (parse_url($target, PHP_URL_PATH) ?? '/');
    $query = is_array($req['query'] ?? null) ? $req['query'] : [];
    $prompt = trim((string) ($query['prompt'] ?? 'Explain vhttpd streaming'));

    if ($path === '/health') {
        return [
            'status' => 200,
            'content_type' => 'text/plain; charset=utf-8',
            'body' => 'OK',
        ];
    }

    if ($method !== 'GET') {
        return [
            'status' => 405,
            'content_type' => 'text/plain; charset=utf-8',
            'body' => 'Method Not Allowed',
        ];
    }

    if ($path === '/ai/stream') {
        $chunks = (function () use ($prompt): Generator {
            yield "AI ";
            usleep(30000);
            yield "token ";
            usleep(30000);
            yield "stream ";
            usleep(30000);
            yield "for: ";
            usleep(30000);
            yield $prompt . "\n";
        })();

        return vhttpd_stream_text(
            $chunks,
            200,
            'text/plain; charset=utf-8',
            ['x-demo' => 'ai-stream-text']
        );
    }

    if ($path === '/ai/sse') {
        $events = (function () use ($prompt): Generator {
            $tokens = ['AI', 'token', 'SSE', 'for:', $prompt];
            foreach ($tokens as $i => $token) {
                usleep(30000);
                yield [
                    'id' => 'tok-' . ($i + 1),
                    'event' => 'token',
                    'retry' => 1000,
                    'data' => $token,
                ];
            }
        })();

        return vhttpd_stream_sse($events, 200, ['x-demo' => 'ai-stream-sse']);
    }

    return [
        'status' => 404,
        'content_type' => 'application/json; charset=utf-8',
        'body' => json_encode(
            [
                'error' => 'Not Found',
                'hint' => 'Try /ai/stream or /ai/sse',
            ],
            JSON_UNESCAPED_UNICODE
        ),
    ];
};
