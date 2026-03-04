<?php

declare(strict_types=1);

return static function (object $request, array $envelope = []): object {
    $trace = $request->query['trace_id'] ?? 'none';
    $route = $request->attributes['route'] ?? 'unset';
    $sid = $request->cookies['sid'] ?? 'missing';
    $body = sprintf(
        'app|%s|%s|%s|%s|%s',
        $request->method,
        $request->uri,
        $trace,
        $route,
        $sid,
    );
    return new TestPsr7Response(
        202,
        ['content-type' => ['text/plain; charset=utf-8'], 'x-app' => ['psr7']],
        new TestPsr7Stream($body),
    );
};
