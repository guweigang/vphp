<?php
declare(strict_types=1);

require_once __DIR__ . '/vendor/autoload.php';

use Illuminate\Container\Container;
use Illuminate\Events\Dispatcher;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Routing\Router;
use Nyholm\Psr7\Factory\Psr17Factory;
use Psr\Http\Message\ServerRequestInterface;
use Symfony\Bridge\PsrHttpMessage\Factory\HttpFoundationFactory;
use Symfony\Bridge\PsrHttpMessage\Factory\PsrHttpFactory;

return static function (ServerRequestInterface $request, array $envelope = []): object {
    static $router = null;
    static $httpFoundationFactory = null;
    static $psrHttpFactory = null;

    if ($router === null) {
        $container = new Container();
        Container::setInstance($container);
        $container->bind(
            \Illuminate\Routing\Contracts\CallableDispatcher::class,
            \Illuminate\Routing\CallableDispatcher::class
        );
        $events = new Dispatcher($container);
        $router = new Router($events, $container);

        $router->get('/laravel/hello/{name}', static function (string $name): Response {
            return new Response('laravel:' . $name, 200, ['x-framework' => 'laravel']);
        });
        $router->get('/laravel/meta', static function (Request $request): JsonResponse {
            parse_str((string) $request->server('QUERY_STRING', ''), $query);
            return new JsonResponse([
                'framework' => 'laravel',
                'trace' => (string) ($query['trace_id'] ?? ''),
                'path' => $request->path(),
            ], 200, ['x-framework' => 'laravel']);
        });

        $psr17 = new Psr17Factory();
        $httpFoundationFactory = new HttpFoundationFactory();
        $psrHttpFactory = new PsrHttpFactory($psr17, $psr17, $psr17, $psr17);
    }

    $symfonyRequest = $httpFoundationFactory->createRequest($request);
    $illuminateRequest = Request::createFromBase($symfonyRequest);
    $illuminateResponse = $router->dispatch($illuminateRequest);

    return $psrHttpFactory->createResponse($illuminateResponse);
};
