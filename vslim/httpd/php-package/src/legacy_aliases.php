<?php

declare(strict_types=1);

if (!class_exists('VHttpd\\VHttpdManager', false)) {
    class_alias(\VHttpd\Manager::class, 'VHttpd\\VHttpdManager');
}
if (!class_exists('VHttpd\\VHttpdPsr7Bridge', false)) {
    class_alias(\VHttpd\Psr7Bridge::class, 'VHttpd\\VHttpdPsr7Bridge');
}
if (!class_exists('VHttpd\\VSlimPsr7Adapter', false)) {
    class_alias(\VHttpd\SlimPsr7Adapter::class, 'VHttpd\\VSlimPsr7Adapter');
}
if (!class_exists('VHttpdManager', false)) {
    class_alias(\VHttpd\Manager::class, 'VHttpdManager');
}
if (!class_exists('VHttpdPsr7Bridge', false)) {
    class_alias(\VHttpd\Psr7Bridge::class, 'VHttpdPsr7Bridge');
}
if (!class_exists('VSlimPsr7Adapter', false)) {
    class_alias(\VHttpd\SlimPsr7Adapter::class, 'VSlimPsr7Adapter');
}
