<?php
declare(strict_types=1);

/**
 * WordPress bridge demo for vhttpd/php-worker.
 *
 * Required env:
 * - VSLIM_WP_ROOT=/abs/path/to/wordpress
 */

return static function ($requestOrEnvelope, array $envelope = []): array {
    $payload = is_array($requestOrEnvelope) ? $requestOrEnvelope : $envelope;

    $wpRoot = getenv('VSLIM_WP_ROOT');
    if (!is_string($wpRoot) || $wpRoot === '') {
        throw new RuntimeException('VSLIM_WP_ROOT is required for wordpress demo');
    }
    $wpLoad = rtrim($wpRoot, '/') . '/wp-load.php';
    if (!is_file($wpLoad)) {
        throw new RuntimeException('wp-load.php not found: ' . $wpLoad);
    }

    if (!defined('WP_USE_THEMES')) {
        define('WP_USE_THEMES', false);
    }
    require_once $wpLoad;

    $path = (string)($payload['path'] ?? '/');
    $pathOnly = strtok($path, '?');
    $query = [];
    if (isset($payload['query']) && is_array($payload['query'])) {
        $query = $payload['query'];
    } elseif (str_contains($path, '?')) {
        parse_str((string)parse_url($path, PHP_URL_QUERY), $query);
    }

    if ($pathOnly === '/wordpress/meta') {
        return [
            'status' => 200,
            'content_type' => 'application/json; charset=utf-8',
            'headers' => [
                'x-framework' => 'wordpress',
            ],
            'body' => wp_json_encode([
                'framework' => 'wordpress',
                'home' => function_exists('home_url') ? home_url('/') : '',
                'site_name' => function_exists('get_bloginfo') ? get_bloginfo('name') : '',
                'trace' => (string)($query['trace_id'] ?? ''),
            ]),
        ];
    }

    if (preg_match('#^/wordpress/post/(\d+)$#', (string)$pathOnly, $m) === 1) {
        $postId = (int)$m[1];
        $post = function_exists('get_post') ? get_post($postId) : null;
        if (!$post) {
            return [
                'status' => 404,
                'content_type' => 'application/json; charset=utf-8',
                'headers' => [
                    'x-framework' => 'wordpress',
                ],
                'body' => wp_json_encode([
                    'error' => 'post_not_found',
                    'post_id' => $postId,
                ]),
            ];
        }

        return [
            'status' => 200,
            'content_type' => 'application/json; charset=utf-8',
            'headers' => [
                'x-framework' => 'wordpress',
            ],
            'body' => wp_json_encode([
                'id' => (int)$post->ID,
                'slug' => (string)$post->post_name,
                'title' => function_exists('get_the_title') ? (string)get_the_title($post->ID) : '',
                'status' => (string)$post->post_status,
            ]),
        ];
    }

    return [
        'status' => 404,
        'content_type' => 'text/plain; charset=utf-8',
        'headers' => [
            'x-framework' => 'wordpress',
        ],
        'body' => 'Not Found',
    ];
};
