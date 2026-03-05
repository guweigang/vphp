<?php

declare(strict_types=1);

return static function (array $envelope): array {
    throw new RuntimeException('fixture boom');
};
