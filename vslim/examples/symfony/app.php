<?php
declare(strict_types=1);

require_once __DIR__ . '/vendor/autoload.php';

use Nyholm\Psr7\Factory\Psr17Factory;
use Psr\Http\Message\ServerRequestInterface;
use Symfony\Bridge\PsrHttpMessage\Factory\HttpFoundationFactory;
use Symfony\Bridge\PsrHttpMessage\Factory\PsrHttpFactory;
use Symfony\Component\EventDispatcher\EventDispatcher;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Controller\ArgumentResolver;
use Symfony\Component\HttpKernel\Controller\ControllerResolver;
use Symfony\Component\HttpKernel\HttpKernel;
use Symfony\Component\Routing\Exception\ResourceNotFoundException;
use Symfony\Component\Routing\Matcher\UrlMatcher;
use Symfony\Component\Routing\RequestContext;
use Symfony\Component\Routing\Route;
use Symfony\Component\Routing\RouteCollection;

return static function (ServerRequestInterface $request, array $envelope = []): object {
    static $kernel = null;
    static $matcher = null;
    static $httpFoundationFactory = null;
    static $psrHttpFactory = null;

    if ($kernel === null) {
        $routes = new RouteCollection();
        $routes->add('hello', new Route('/symfony/hello/{name}', [
            '_controller' => static function (Request $request, string $name): Response {
                return new Response('symfony:' . $name, 200, ['x-framework' => 'symfony']);
            },
        ]));
        $routes->add('meta', new Route('/symfony/meta', [
            '_controller' => static function (Request $request): Response {
                return new JsonResponse([
                    'framework' => 'symfony',
                    'trace' => (string) $request->query->get('trace_id', ''),
                    'path' => $request->getPathInfo(),
                ], 200, ['x-framework' => 'symfony']);
            },
        ]));

        $matcher = new UrlMatcher($routes, new RequestContext());
        $kernel = new HttpKernel(new EventDispatcher(), new ControllerResolver(), null, new ArgumentResolver());

        $psr17 = new Psr17Factory();
        $httpFoundationFactory = new HttpFoundationFactory();
        $psrHttpFactory = new PsrHttpFactory($psr17, $psr17, $psr17, $psr17);
    }

    $symfonyRequest = $httpFoundationFactory->createRequest($request);
    $matcher->getContext()->fromRequest($symfonyRequest);

    try {
        $attributes = $matcher->match($symfonyRequest->getPathInfo());
        $symfonyRequest->attributes->add($attributes);
        $symfonyResponse = $kernel->handle($symfonyRequest);
    } catch (ResourceNotFoundException) {
        $symfonyResponse = new Response('Not Found', 404, ['x-framework' => 'symfony']);
    }

    return $psrHttpFactory->createResponse($symfonyResponse);
};
