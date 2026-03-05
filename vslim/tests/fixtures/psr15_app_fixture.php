<?php

declare(strict_types=1);

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\RequestHandlerInterface;

final class TestPsr15ResponseBody
{
    public function __construct(private string $content) {}

    public function __toString(): string
    {
        return $this->content;
    }
}

return new class implements RequestHandlerInterface {
    public function handle(ServerRequestInterface $request): ResponseInterface
    {
        $method = property_exists($request, "method")
            ? (string) $request->method
            : "GET";
        $uri = property_exists($request, "uri")
            ? (string) $request->uri
            : "/";
        $trace = property_exists($request, "query") && is_array($request->query)
            ? (string) ($request->query["trace_id"] ?? "none")
            : "none";

        $body = sprintf("psr15|%s|%s|%s", $method, $uri, $trace);

        return new TestPsr7Response(
            207,
            [
                "Content-Type" => ["text/plain; charset=utf-8"],
                "X-App" => ["psr15", "handler"],
            ],
            new TestPsr15ResponseBody($body),
        );
    }
};
