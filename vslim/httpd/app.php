<?php

declare(strict_types=1);

require_once __DIR__ . '/vslim_psr7_adapter.php';

return static function (mixed $request, array $envelope = []): VSlim\Response|array {
    $app = VSlim\App::demo();

    if (is_object($request)) {
        return \VHttpd\SlimPsr7Adapter::dispatch($app, $request);
    }

    if (is_array($request)) {
        return vslim_handle_request($request);
    }

    if ($envelope !== []) {
        return vslim_handle_request($envelope);
    }

    return [
        'status' => 500,
        'content_type' => 'text/plain; charset=utf-8',
        'body' => 'No request payload available',
    ];
};
