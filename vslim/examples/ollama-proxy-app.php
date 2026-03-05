<?php
declare(strict_types=1);

/**
 * Ollama stream proxy demo for vhttpd/php-worker.
 *
 * Endpoints:
 * - GET  /ollama/health
 * - GET  /ollama/text?prompt=...&model=...
 * - GET  /ollama/sse?prompt=...&model=...
 * - POST /ollama/text   (JSON body supported)
 * - POST /ollama/sse    (JSON body supported)
 *
 * Env:
 * - OLLAMA_CHAT_URL (default: http://127.0.0.1:11434/api/chat)
 * - OLLAMA_MODEL (default: qwen2.5:7b-instruct)
 * - OLLAMA_API_KEY (optional Bearer token for cloud endpoints)
 */

/**
 * @param array<string,mixed> $envelope
 * @return array{method:string,path:string,query:array<string,string>,body:string}
 */
function ollama_req(mixed $request, array $envelope): array
{
    $src = is_array($request) ? $request : $envelope;
    $method = strtoupper((string) ($src['method'] ?? 'GET'));
    $pathWithQuery = (string) ($src['path'] ?? '/');
    $path = (string) (parse_url($pathWithQuery, PHP_URL_PATH) ?? '/');
    $query = is_array($src['query'] ?? null) ? $src['query'] : [];
    $body = (string) ($src['body'] ?? '');
    return [
        'method' => $method,
        'path' => $path,
        'query' => $query,
        'body' => $body,
    ];
}

/**
 * @return array{prompt:string,model:string,messages:array<int,array<string,string>>}
 */
function ollama_payload(array $req): array
{
    $query = $req['query'];
    $rawBody = $req['body'];
    $jsonBody = json_decode($rawBody, true);
    if (!is_array($jsonBody)) {
        $jsonBody = [];
    }

    $prompt = trim((string) ($query['prompt'] ?? ($jsonBody['prompt'] ?? 'Tell me a short demo story.')));
    $model = trim((string) ($query['model'] ?? ($jsonBody['model'] ?? getenv('OLLAMA_MODEL') ?: 'qwen2.5:7b-instruct')));

    $messages = $jsonBody['messages'] ?? null;
    if (!is_array($messages) || $messages === []) {
        $messages = [
            ['role' => 'user', 'content' => $prompt],
        ];
    }

    return [
        'prompt' => $prompt,
        'model' => $model,
        'messages' => $messages,
    ];
}

/**
 * @return array{ok:bool,stream:resource|null,error:string,status:int,headers:array<int,string>}
 */
function ollama_open_stream(array $payload): array
{
    $url = (string) (getenv('OLLAMA_CHAT_URL') ?: 'http://127.0.0.1:11434/api/chat');
    $apiKey = trim((string) (getenv('OLLAMA_API_KEY') ?: ''));

    $reqBody = json_encode([
        'model' => $payload['model'],
        'stream' => true,
        'messages' => $payload['messages'],
    ], JSON_UNESCAPED_UNICODE);
    if (!is_string($reqBody)) {
        return [
            'ok' => false,
            'stream' => null,
            'error' => 'failed to encode request payload',
            'status' => 500,
            'headers' => [],
        ];
    }

    $headers = [
        'Content-Type: application/json',
        'Accept: application/x-ndjson',
    ];
    if ($apiKey !== '') {
        $headers[] = 'Authorization: Bearer ' . $apiKey;
    }

    $ctx = stream_context_create([
        'http' => [
            'method' => 'POST',
            'header' => implode("\r\n", $headers) . "\r\n",
            'content' => $reqBody,
            'timeout' => 300,
            'ignore_errors' => true,
        ],
    ]);

    $fp = @fopen($url, 'r', false, $ctx);
    if (!is_resource($fp)) {
        return [
            'ok' => false,
            'stream' => null,
            'error' => 'failed to open upstream stream: ' . $url,
            'status' => 502,
            'headers' => [],
        ];
    }

    $lastHeaders = function_exists('http_get_last_response_headers')
        ? http_get_last_response_headers()
        : null;
    $respHeaders = is_array($lastHeaders) ? $lastHeaders : [];
    $status = 200;
    if (isset($respHeaders[0]) && preg_match('/\s(\d{3})\s/', (string) $respHeaders[0], $m) === 1) {
        $status = (int) $m[1];
    }

    if ($status < 200 || $status >= 300) {
        $err = trim((string) stream_get_contents($fp));
        fclose($fp);
        return [
            'ok' => false,
            'stream' => null,
            'error' => $err !== '' ? $err : ('upstream status ' . $status),
            'status' => $status,
            'headers' => $respHeaders,
        ];
    }

    return [
        'ok' => true,
        'stream' => $fp,
        'error' => '',
        'status' => $status,
        'headers' => $respHeaders,
    ];
}

/**
 * @return Generator<int,string>
 */
function ollama_text_chunks($stream): Generator
{
    try {
        while (!feof($stream)) {
            $line = fgets($stream);
            if ($line === false) {
                break;
            }
            $line = trim($line);
            if ($line === '') {
                continue;
            }
            $row = json_decode($line, true);
            if (!is_array($row)) {
                continue;
            }
            $piece = (string) ($row['message']['content'] ?? ($row['response'] ?? ''));
            if ($piece !== '') {
                yield $piece;
            }
            if (!empty($row['done'])) {
                break;
            }
        }
    } finally {
        if (is_resource($stream)) {
            fclose($stream);
        }
    }
}

/**
 * @return Generator<int,array<string,mixed>>
 */
function ollama_sse_events($stream): Generator
{
    $i = 0;
    try {
        while (!feof($stream)) {
            $line = fgets($stream);
            if ($line === false) {
                break;
            }
            $line = trim($line);
            if ($line === '') {
                continue;
            }
            $row = json_decode($line, true);
            if (!is_array($row)) {
                continue;
            }
            $piece = (string) ($row['message']['content'] ?? ($row['response'] ?? ''));
            if ($piece !== '') {
                $i++;
                yield [
                    'id' => 'tok-' . $i,
                    'event' => 'token',
                    'retry' => 1000,
                    'data' => $piece,
                ];
            }
            if (!empty($row['done'])) {
                yield [
                    'id' => 'done-' . ($i + 1),
                    'event' => 'done',
                    'retry' => 1000,
                    'data' => 'done',
                ];
                break;
            }
        }
    } finally {
        if (is_resource($stream)) {
            fclose($stream);
        }
    }
}

return static function (mixed $request, array $envelope = []): array|WorkerStreamResponse {
    $req = ollama_req($request, $envelope);
    if ($req['path'] === '/ollama/health') {
        return [
            'status' => 200,
            'content_type' => 'text/plain; charset=utf-8',
            'body' => 'OK',
        ];
    }

    $isText = $req['path'] === '/ollama/text';
    $isSse = $req['path'] === '/ollama/sse';
    if (!$isText && !$isSse) {
        return [
            'status' => 404,
            'content_type' => 'application/json; charset=utf-8',
            'body' => json_encode([
                'error' => 'Not Found',
                'hint' => 'Use /ollama/text or /ollama/sse',
            ], JSON_UNESCAPED_UNICODE),
        ];
    }

    if (!in_array($req['method'], ['GET', 'POST'], true)) {
        return [
            'status' => 405,
            'content_type' => 'text/plain; charset=utf-8',
            'body' => 'Method Not Allowed',
        ];
    }

    $payload = ollama_payload($req);
    $upstream = ollama_open_stream($payload);
    if (!$upstream['ok']) {
        return [
            'status' => ($upstream['status'] >= 400 ? $upstream['status'] : 502),
            'content_type' => 'application/json; charset=utf-8',
            'body' => json_encode([
                'error' => 'Upstream stream failed',
                'detail' => $upstream['error'],
                'model' => $payload['model'],
                'url' => (string) (getenv('OLLAMA_CHAT_URL') ?: 'http://127.0.0.1:11434/api/chat'),
            ], JSON_UNESCAPED_UNICODE),
        ];
    }

    if ($isText) {
        return vhttpd_stream_text(
            ollama_text_chunks($upstream['stream']),
            200,
            'text/plain; charset=utf-8',
            ['x-upstream' => 'ollama']
        );
    }

    return vhttpd_stream_sse(
        ollama_sse_events($upstream['stream']),
        200,
        ['x-upstream' => 'ollama']
    );
};
