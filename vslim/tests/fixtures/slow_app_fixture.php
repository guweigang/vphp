<?php

declare(strict_types=1);

return static function (array $envelope): array {
    usleep(300_000);
    return [
        'status' => 200,
        'content_type' => 'text/plain; charset=utf-8',
        'body' => 'late',
    ];
};
