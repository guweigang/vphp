<?php
declare(strict_types=1);

/**
 * VSlim demo app:
 * - routing + group + named route + reverse url
 * - middleware/before/after hooks
 * - request input helpers
 * - container + class/service handler resolution
 * - custom not-found / error handlers
 *
 * Run self test:
 *   php -d extension=./vslim.so vslim/examples/demo_app.php --self-test
 *
 * Serve with PHP built-in server:
 *   php -d extension=./vslim.so -S 127.0.0.1:8088 vslim/examples/demo_app.php
 */

require_once __DIR__ . '/vendor/autoload.php';

use VHttpd\SlimPsr7Adapter;

if (!class_exists('DemoUserService', false)) {
    final class DemoUserService
    {
        public function find(string $id): array
        {
            return [
                'id' => $id,
                'name' => 'user-' . $id,
                'role' => ((int)$id % 2 === 0) ? 'admin' : 'member',
            ];
        }

        public function save(string $id, string $method, array $payload): array
        {
            return [
                'id' => $id,
                'method' => strtoupper($method),
                'payload' => $payload,
                'updated' => true,
            ];
        }
    }
}

if (!class_exists('DemoUserController', false)) {
    final class DemoUserController
    {
        public function __construct(private DemoUserService $svc) {}

    public function show(VSlim\Request $req): array
    {
        return [
            'status' => 200,
            'content_type' => 'application/json; charset=utf-8',
                'body' => json_encode([
                    'ok' => true,
                    'from' => 'container-controller',
                    'user' => $this->svc->find($req->param('id')),
                    'trace' => $req->query('trace_id') ?: '',
                ], JSON_UNESCAPED_UNICODE),
            ];
        }

    public function update(VSlim\Request $req): array
    {
        return [
            'status' => 200,
            'content_type' => 'application/json; charset=utf-8',
                'body' => json_encode([
                    'ok' => true,
                    'from' => 'container-controller',
                    'result' => $this->svc->save($req->param('id'), $req->method, $req->all_inputs()),
                ], JSON_UNESCAPED_UNICODE),
            ];
        }
    }
}

if (!class_exists('DemoAutoPing', false)) {
    final class DemoAutoPing
    {
        public function __invoke(VSlim\Request $req): string
        {
            return 'auto-ping:' . $req->param('id');
        }
    }
}

function build_demo_app(): VSlim\App
{
    $app = new VSlim\App();

    $container = $app->container();
    $container->set(DemoUserService::class, new DemoUserService());
    /** @var DemoUserService $svc */
    $svc = $container->get(DemoUserService::class);
    $container->set(DemoUserController::class, new DemoUserController($svc));

    $app->set_base_path('/demo');

    $app->set_not_found_handler(function (VSlim\Request $req) {
        return [
            'status' => 404,
            'content_type' => 'application/json; charset=utf-8',
            'body' => json_encode([
                'ok' => false,
                'error' => 'not_found',
                'path' => $req->path,
            ], JSON_UNESCAPED_UNICODE),
        ];
    });

    $app->set_error_handler(function (VSlim\Request $req, string $message, int $status) {
        return [
            'status' => $status,
            'content_type' => 'application/json; charset=utf-8',
            'body' => json_encode([
                'ok' => false,
                'error' => 'runtime',
                'status' => $status,
                'message' => $message,
                'path' => $req->path,
            ], JSON_UNESCAPED_UNICODE),
        ];
    });

    $app->get('/', function () {
        return [
            'status' => 200,
            'content_type' => 'application/json; charset=utf-8',
            'body' => json_encode([
                'name' => 'vslim-demo',
                'routes' => 'GET /health, GET /hello/:name, POST /forms/echo, GET /api/users/:id',
            ], JSON_UNESCAPED_UNICODE),
        ];
    });

    $app->get('/health', fn () => 'ok');

    $app->get('/hello/:name', function (VSlim\Request $req) {
        return 'hello ' . $req->param('name');
    });

    $app->post('/forms/echo', function (VSlim\Request $req) {
        return [
            'status' => 200,
            'content_type' => 'application/json; charset=utf-8',
            'body' => json_encode([
                'ok' => true,
                'body_format' => $req->body_format(),
                'query' => $req->query_params(),
                'parsed_body' => $req->parsed_body(),
                'inputs' => $req->all_inputs(),
                'uploaded_files' => $req->uploaded_files(),
                'content_type' => $req->content_type(),
            ], JSON_UNESCAPED_UNICODE),
        ];
    });

    $app->get('/auto/:id', DemoAutoPing::class);

    $api = $app->group('/api');
    $api->get_named('api.users.show', '/users/:id', [DemoUserController::class, 'show']);
    $api->map(['PUT', 'PATCH'], '/users/:id', [DemoUserController::class, 'update']);

    $app->get('/links', function () use ($app) {
        return [
            'status' => 200,
            'content_type' => 'application/json; charset=utf-8',
            'body' => json_encode([
                'user_42' => $app->url_for('api.users.show', ['id' => '42']),
                'user_42_abs' => $app->url_for_abs('api.users.show', ['id' => '42'], 'https', 'example.local'),
            ], JSON_UNESCAPED_UNICODE),
        ];
    });

    $app->get('/broken', function () {
        return fopen('php://memory', 'r');
    });

    return $app;
}

function build_request_from_globals(): VSlim\Request
{
    $req = new VSlim\Request();
    $method = $_SERVER['REQUEST_METHOD'] ?? 'GET';
    $uri = $_SERVER['REQUEST_URI'] ?? '/';
    $body = file_get_contents('php://input') ?: '';

    $headers = [];
    foreach ($_SERVER as $k => $v) {
        if (!is_string($v)) {
            continue;
        }
        if (str_starts_with($k, 'HTTP_')) {
            $name = strtolower(str_replace('_', '-', substr($k, 5)));
            $headers[$name] = $v;
        }
    }
    if (isset($_SERVER['CONTENT_TYPE']) && is_string($_SERVER['CONTENT_TYPE'])) {
        $headers['content-type'] = $_SERVER['CONTENT_TYPE'];
    }

    $serverMap = [];
    foreach ($_SERVER as $k => $v) {
        if (is_scalar($v)) {
            $serverMap[(string)$k] = (string)$v;
        }
    }

    $req->construct($method, $uri, $body);
    $req->set_headers($headers);
    $req->set_cookies($_COOKIE);
    $req->set_server($serverMap);
    $req->set_remote_addr((string)($_SERVER['REMOTE_ADDR'] ?? ''));
    $req->set_scheme((!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http');
    $req->set_host((string)($_SERVER['HTTP_HOST'] ?? 'localhost'));

    return $req;
}

function emit_response(VSlim\Response $res): void
{
    http_response_code($res->status);
    foreach ($res->headers() as $name => $value) {
        if ($name === '') {
            continue;
        }
        header($name . ': ' . $value, true);
    }
    echo $res->body;
}

function run_self_test(): void
{
    $app = build_demo_app();

    $r1 = $app->dispatch('GET', '/hello/codex?trace_id=demo');
    echo "GET /hello/codex => {$r1->status} {$r1->body} | x-demo-app={$r1->header('x-demo-app')} | x-trace-id={$r1->header('x-trace-id')}\n";

    $r2 = $app->dispatch('GET', '/api/users/7?token=demo-token');
    echo "GET /api/users/7 => {$r2->status} {$r2->body}\n";

    $r3 = $app->dispatch_body('POST', '/forms/echo?token=demo', 'name=neo&city=shanghai');
    echo "POST /forms/echo => {$r3->status} {$r3->body}\n";

    $r4 = $app->dispatch('GET', '/links');
    echo "GET /links => {$r4->status} {$r4->body}\n";

    $r5 = $app->dispatch('GET', '/missing');
    echo "GET /missing => {$r5->status} {$r5->body}\n";

    $r6 = $app->dispatch('GET', '/broken');
    echo "GET /broken => {$r6->status} {$r6->body}\n";
}

function demo_app_handler(): callable
{
    $unauthorized = static fn (): array => [
        'status' => 401,
        'content_type' => 'application/json; charset=utf-8',
        'headers' => ['content-type' => 'application/json; charset=utf-8'],
        'body' => json_encode(['ok' => false, 'error' => 'unauthorized'], JSON_UNESCAPED_UNICODE),
    ];

    $tokenFromPath = static function (string $rawPath): string {
        $query = parse_url($rawPath, PHP_URL_QUERY);
        if (!is_string($query) || $query === '') {
            return '';
        }
        parse_str($query, $params);
        $token = $params['token'] ?? '';
        return is_string($token) ? $token : '';
    };

    return static function (mixed $request, array $envelope = []) use ($unauthorized, $tokenFromPath): array {
        static $app = null;
        if (!$app instanceof VSlim\App) {
            $app = build_demo_app();
        }

        if ($envelope !== []) {
            $path = (string)($envelope['path'] ?? '/');
            if (str_starts_with($path, '/api') && $tokenFromPath($path) !== 'demo-token') {
                return $unauthorized();
            }
            if (method_exists($app, 'dispatch_envelope_map')) {
                /** @var array{status:string,body:string,content_type:string} $map */
                $map = $app->dispatch_envelope_map($envelope);
                return [
                    'status' => (int) ($map['status'] ?? '500'),
                    'content_type' => (string) ($map['content_type'] ?? 'text/plain; charset=utf-8'),
                    'headers' => [
                        'content-type' => (string) ($map['content_type'] ?? 'text/plain; charset=utf-8'),
                    ],
                    'body' => (string) ($map['body'] ?? ''),
                ];
            }
            return normalize_worker_response($app->dispatch_envelope($envelope));
        }

        if (is_object($request)) {
            return normalize_worker_response(SlimPsr7Adapter::dispatch($app, $request));
        }

        if (is_array($request)) {
            $path = (string)($request['path'] ?? '/');
            if (str_starts_with($path, '/api') && $tokenFromPath($path) !== 'demo-token') {
                return $unauthorized();
            }
            if (method_exists($app, 'dispatch_envelope_map')) {
                /** @var array{status:string,body:string,content_type:string} $map */
                $map = $app->dispatch_envelope_map($request);
                return [
                    'status' => (int) ($map['status'] ?? '500'),
                    'content_type' => (string) ($map['content_type'] ?? 'text/plain; charset=utf-8'),
                    'headers' => [
                        'content-type' => (string) ($map['content_type'] ?? 'text/plain; charset=utf-8'),
                    ],
                    'body' => (string) ($map['body'] ?? ''),
                ];
            }
            return normalize_worker_response($app->dispatch_envelope($request));
        }

        return [
            'status' => 500,
            'content_type' => 'text/plain; charset=utf-8',
            'body' => 'No request payload available',
        ];
    };
}

function normalize_worker_response(VSlim\Response $res): array
{
    return [
        'status' => $res->status,
        'content_type' => $res->content_type,
        'headers' => $res->headers(),
        'body' => $res->body,
    ];
}

if (realpath((string)($_SERVER['SCRIPT_FILENAME'] ?? '')) !== __FILE__) {
    return demo_app_handler();
}

if (!extension_loaded('vslim')) {
    fwrite(STDERR, "vslim extension is not loaded\n");
    exit(1);
}

if (PHP_SAPI === 'cli' && in_array('--self-test', $argv ?? [], true)) {
    run_self_test();
    exit(0);
}

if (PHP_SAPI === 'cli' && !isset($_SERVER['REQUEST_METHOD'])) {
    echo "Usage:\n";
    echo "  php -d extension=./vslim.so vslim/examples/demo_app.php --self-test\n";
    echo "  php -d extension=./vslim.so -S 127.0.0.1:8088 vslim/examples/demo_app.php\n";
    exit(0);
}

$app = build_demo_app();
$response = $app->dispatch_request(build_request_from_globals());
emit_response($response);
