<?php

declare(strict_types=1);

final class TestPsr7ResponseBody
{
    private bool $rewound = false;

    public function __construct(private string $content) {}

    public function rewind(): void
    {
        $this->rewound = true;
    }

    public function getContents(): string
    {
        return $this->content;
    }

    public function wasRewound(): bool
    {
        return $this->rewound;
    }
}

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
        ['Content-Type' => ['text/plain; charset=utf-8'], 'X-App' => ['psr7', 'bridge']],
        new TestPsr7ResponseBody($body),
    );
};
