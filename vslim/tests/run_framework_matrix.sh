#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSER_BIN="${COMPOSER_BIN:-composer}"
WORKDIR="${FRAMEWORK_MATRIX_WORKDIR:-${ROOT}/examples}"
RUNTIME_DIR="${FRAMEWORK_MATRIX_RUNTIME_DIR:-${ROOT}/examples/.runtime/framework-matrix}"
HOST="${VHTTPD_HOST:-127.0.0.1}"
START_PORT="${FRAMEWORK_MATRIX_START_PORT:-19910}"
HTTPD_BIN="${ROOT}/httpd/vhttpd"
EXT_SO="${ROOT}/vslim.so"
WORKER_ENTRY="${ROOT}/httpd/php-worker.php"

if ! command -v php >/dev/null 2>&1; then
  echo "php not found"
  exit 2
fi
if ! command -v "${COMPOSER_BIN}" >/dev/null 2>&1; then
  echo "composer not found (COMPOSER_BIN=${COMPOSER_BIN})"
  exit 2
fi
if ! command -v curl >/dev/null 2>&1; then
  echo "curl not found"
  exit 2
fi

mkdir -p "${WORKDIR}" "${RUNTIME_DIR}"

wait_ready() {
  local host="$1"
  local port="$2"
  local max_tries=120
  local i=0
  while [ "${i}" -lt "${max_tries}" ]; do
    if curl --noproxy '*' -sS "http://${host}:${port}/health" >/dev/null 2>&1; then
      return 0
    fi
    i=$((i + 1))
    sleep 0.2
  done
  return 1
}

assert_route() {
  local case_name="$1"
  local url="$2"
  local expected_status="$3"
  local expected_header="$4"
  local expected_body="$5"
  local hdr_file="$6"
  local body_file="$7"

  local status
  status="$(curl --noproxy '*' -sS -D "${hdr_file}" -o "${body_file}" -w '%{http_code}' "${url}")"
  if [ "${status}" != "${expected_status}" ]; then
    echo "[${case_name}] unexpected status for ${url}: got=${status} expected=${expected_status}"
    echo "--- headers ---"
    cat "${hdr_file}"
    echo "--- body ---"
    cat "${body_file}"
    exit 1
  fi
  if ! grep -qi "^x-framework: ${expected_header}" "${hdr_file}"; then
    echo "[${case_name}] missing x-framework=${expected_header} for ${url}"
    echo "--- headers ---"
    cat "${hdr_file}"
    exit 1
  fi
  if ! grep -Fq "${expected_body}" "${body_file}"; then
    echo "[${case_name}] body mismatch for ${url}"
    echo "--- body ---"
    cat "${body_file}"
    exit 1
  fi
}

write_symfony_app() {
  local app_path="$1"
cat >"${app_path}" <<'PHP'
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
        $routes->add('symfony_hello', new Route('/symfony/hello/{name}', [
            '_controller' => static function (Request $request, string $name): Response {
                return new Response('symfony:' . $name, 200, ['x-framework' => 'symfony']);
            },
        ]));
        $routes->add('symfony_meta', new Route('/symfony/meta', [
            '_controller' => static function (Request $request): Response {
                return new JsonResponse([
                    'framework' => 'symfony',
                    'trace' => (string) $request->query->get('trace_id', ''),
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
PHP
}

write_laravel_app() {
  local app_path="$1"
cat >"${app_path}" <<'PHP'
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
            return new JsonResponse([
                'framework' => 'laravel',
                'trace' => (string) $request->query('trace_id', (string) $request->query('_trace_id_from_envelope', '')),
            ], 200, ['x-framework' => 'laravel']);
        });

        $psr17 = new Psr17Factory();
        $httpFoundationFactory = new HttpFoundationFactory();
        $psrHttpFactory = new PsrHttpFactory($psr17, $psr17, $psr17, $psr17);
    }

    $symfonyRequest = $httpFoundationFactory->createRequest($request);
    $illuminateRequest = Request::createFromBase($symfonyRequest);
    $traceId = '';
    if (isset($envelope['query']) && is_array($envelope['query'])) {
        $traceId = (string) ($envelope['query']['trace_id'] ?? '');
    }
    if ($traceId !== '') {
        $illuminateRequest->query->set('_trace_id_from_envelope', $traceId);
    }
    $illuminateResponse = $router->dispatch($illuminateRequest);

    return $psrHttpFactory->createResponse($illuminateResponse);
};
PHP
}

run_case() {
  local case_name="$1"
  local route_hello="$2"
  local route_meta="$3"
  local framework_header="$4"
  local expected_meta_body="$5"
  local port="$6"

  local case_dir="${WORKDIR}/${case_name}"
  local app_path="${case_dir}/app.php"
  local run_dir="${RUNTIME_DIR}/${case_name}"
  local worker_socket="${run_dir}/worker.sock"
  local pid_file="${run_dir}/vhttpd.pid"
  local event_log="${run_dir}/vhttpd.events.ndjson"
  local stdout_log="${run_dir}/vhttpd.stdout.log"
  local worker_cmd="${run_dir}/worker.sh"
  local hdr_file="${run_dir}/headers.txt"
  local body_file="${run_dir}/body.txt"

  if [ ! -d "${case_dir}" ]; then
    echo "[${case_name}] example project not found: ${case_dir}"
    exit 1
  fi
  if [ ! -f "${case_dir}/composer.json" ]; then
    echo "[${case_name}] missing composer.json: ${case_dir}/composer.json"
    exit 1
  fi
  if [ ! -f "${app_path}" ]; then
    echo "[${case_name}] missing app.php: ${app_path}"
    exit 1
  fi

  rm -rf "${run_dir}"
  mkdir -p "${run_dir}"
  pushd "${case_dir}" >/dev/null

  "${COMPOSER_BIN}" install --no-interaction --no-progress --prefer-dist >/dev/null

  cat >"${worker_cmd}" <<EOF
#!/usr/bin/env bash
set -euo pipefail
export VSLIM_HTTPD_APP="${app_path}"
exec php -d extension="${EXT_SO}" "${WORKER_ENTRY}" --socket "${worker_socket}"
EOF
  chmod +x "${worker_cmd}"

  "${HTTPD_BIN}" \
    --host "${HOST}" \
    --port "${port}" \
    --pid-file "${pid_file}" \
    --event-log "${event_log}" \
    --worker-socket "${worker_socket}" \
    --worker-autostart 1 \
    --worker-cmd "${worker_cmd}" \
    >"${stdout_log}" 2>&1 &
  local vhttpd_pid=$!

  cleanup_case() {
    if [ -f "${pid_file}" ]; then
      kill "$(cat "${pid_file}")" >/dev/null 2>&1 || true
    fi
    kill "${vhttpd_pid}" >/dev/null 2>&1 || true
    wait "${vhttpd_pid}" >/dev/null 2>&1 || true
  }
  trap cleanup_case RETURN

  if ! wait_ready "${HOST}" "${port}"; then
    echo "[${case_name}] vhttpd not ready"
    cat "${stdout_log}" || true
    exit 1
  fi

  assert_route "${case_name}" \
    "http://${HOST}:${port}${route_hello}?trace_id=${case_name}" \
    "200" "${framework_header}" "${framework_header}" \
    "${hdr_file}" "${body_file}"

  assert_route "${case_name}" \
    "http://${HOST}:${port}${route_meta}?trace_id=${case_name}" \
    "200" "${framework_header}" "${expected_meta_body}" \
    "${hdr_file}" "${body_file}"

  echo "case=${case_name}"
  echo "url=http://${HOST}:${port}${route_hello}"
  echo "ok"

  trap - RETURN
  cleanup_case
  popd >/dev/null
}

echo "[framework-matrix] workdir=${WORKDIR}"
echo "[framework-matrix] composer=${COMPOSER_BIN}"

make -C "${ROOT}" build >/dev/null
make -C "${ROOT}" vhttpd >/dev/null

run_case \
  "symfony" \
  "/symfony/hello/nova" \
  "/symfony/meta" \
  "symfony" \
  "\"trace\":\"symfony\"" \
  "${START_PORT}"

run_case \
  "laravel" \
  "/laravel/hello/nova" \
  "/laravel/meta" \
  "laravel" \
  "\"framework\":\"laravel\"" \
  "$((START_PORT + 1))"

echo "[framework-matrix] all cases passed"
