<?php

declare(strict_types=1);

use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Psr\Http\Server\MiddlewareInterface;
use Psr\Http\Server\RequestHandlerInterface;

final class TestPsr15StackBody
{
    public function __construct(private string $content) {}

    public function __toString(): string
    {
        return $this->content;
    }
}

final class TestPsr15FinalHandler implements RequestHandlerInterface
{
    public function handle(ServerRequestInterface $request): ResponseInterface
    {
        $method = property_exists($request, "method") ? (string) $request->method : "GET";
        $uri = property_exists($request, "uri") ? (string) $request->uri : "/";
        $trace = property_exists($request, "query") && is_array($request->query)
            ? (string) ($request->query["trace_id"] ?? "none")
            : "none";
        $mw = property_exists($request, "attributes") && is_array($request->attributes)
            ? (string) ($request->attributes["mw"] ?? "")
            : "";

        return new TestPsr7Response(
            209,
            [
                "Content-Type" => ["text/plain; charset=utf-8"],
                "X-App" => ["psr15", "stack"],
            ],
            new TestPsr15StackBody(sprintf("stack|%s|%s|%s|%s", $method, $uri, $trace, $mw)),
        );
    }
}

final class TestPsr15MwPrefix implements MiddlewareInterface
{
    public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface
    {
        if (method_exists($request, "withAttribute")) {
            /** @var ServerRequestInterface $request */
            $request = $request->withAttribute("mw", "mw1");
        }
        return $handler->handle($request);
    }
}

final class TestPsr15MwSuffix implements MiddlewareInterface
{
    public function process(ServerRequestInterface $request, RequestHandlerInterface $handler): ResponseInterface
    {
        $current = property_exists($request, "attributes") && is_array($request->attributes)
            ? (string) ($request->attributes["mw"] ?? "")
            : "";
        if (method_exists($request, "withAttribute")) {
            /** @var ServerRequestInterface $request */
            $request = $request->withAttribute("mw", $current . "-mw2");
        }
        return $handler->handle($request);
    }
}

return [
    "middlewares" => [
        new TestPsr15MwPrefix(),
        new TestPsr15MwSuffix(),
    ],
    "handler" => new TestPsr15FinalHandler(),
];
