<?php

declare(strict_types=1);

namespace VHttpd\PhpWorker;

final class StreamResponse
{
    public function __construct(
        public string $streamType,
        public iterable $chunks,
        public int $status = 200,
        public string $contentType = 'text/plain; charset=utf-8',
        public array $headers = [],
    ) {
    }

    public static function sse(iterable $events, int $status = 200, array $headers = []): self
    {
        return new self('sse', $events, $status, 'text/event-stream', $headers);
    }

    public static function text(
        iterable $chunks,
        int $status = 200,
        string $contentType = 'text/plain; charset=utf-8',
        array $headers = [],
    ): self {
        return new self('text', $chunks, $status, $contentType, $headers);
    }
}
