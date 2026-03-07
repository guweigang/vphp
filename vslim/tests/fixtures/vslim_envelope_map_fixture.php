<?php

declare(strict_types=1);

return static function (mixed $request, array $envelope = []): array {
    static $app = null;
    if (!$app instanceof VSlim\App) {
        $app = new VSlim\App();
        $app->get('/hello/:name', function (VSlim\Request $req) {
            $res = new VSlim\Response(200, 'Hello, ' . $req->param('name'), 'text/plain; charset=utf-8');
            return $res->set_header('x-app', 'map-fixture');
        });
    }

    $payload = is_array($request) ? $request : $envelope;
    if (!is_array($payload)) {
        return [
            'status' => 500,
            'content_type' => 'text/plain; charset=utf-8',
            'headers' => ['content-type' => 'text/plain; charset=utf-8'],
            'body' => 'invalid payload',
        ];
    }

    $map = $app->dispatch_envelope_map($payload);
    $headers = [];
    foreach ($map as $k => $v) {
        if (is_string($k) && str_starts_with($k, 'headers_')) {
            $name = substr($k, 8);
            if ($name !== '') {
                $headers[$name] = (string) $v;
            }
        }
    }
    if (!isset($headers['content-type'])) {
        $headers['content-type'] = (string) ($map['content_type'] ?? 'text/plain; charset=utf-8');
    }

    return [
        'status' => (int) ($map['status'] ?? '500'),
        'content_type' => (string) ($map['content_type'] ?? 'text/plain; charset=utf-8'),
        'headers' => $headers,
        'body' => (string) ($map['body'] ?? ''),
    ];
};
