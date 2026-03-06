<?php
declare(strict_types=1);

return static function (mixed $request, array $envelope = []): \VHttpd\PhpWorker\StreamResponse|array {
    $path = (string) ($envelope["path"] ?? "/");

    if (str_starts_with($path, "/stream/sse")) {
        $events = (function () use ($envelope): iterable {
            $rid = (string) (($envelope["headers"]["x-request-id"] ?? "") ?: "no-rid");
            yield [
                "id" => $rid . "-1",
                "event" => "ping",
                "data" => json_encode(["seq" => 1, "request_id" => $rid], JSON_UNESCAPED_UNICODE),
            ];
            yield [
                "id" => $rid . "-2",
                "event" => "ping",
                "data" => json_encode(["seq" => 2, "request_id" => $rid], JSON_UNESCAPED_UNICODE),
            ];
        })();
        return \VHttpd\PhpWorker\StreamResponse::sse($events, 200, [
            "x-stream-source" => "php-worker",
        ]);
    }

    if (str_starts_with($path, "/stream/text")) {
        $chunks = (function (): iterable {
            yield "chunk-a\n";
            yield "chunk-b\n";
        })();
        return \VHttpd\PhpWorker\StreamResponse::text(
            $chunks,
            200,
            "text/plain; charset=utf-8",
            ["x-stream-source" => "php-worker"],
        );
    }

    return [
        "status" => 404,
        "content_type" => "text/plain; charset=utf-8",
        "body" => "Not Found",
    ];
};

