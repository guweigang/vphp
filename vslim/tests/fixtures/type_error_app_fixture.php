<?php
declare(strict_types=1);

return static function (string $mustBeString): array {
    return [
        'status' => 200,
        'content_type' => 'text/plain; charset=utf-8',
        'body' => $mustBeString,
    ];
};
