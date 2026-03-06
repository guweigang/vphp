<?php

declare(strict_types=1);

if (class_exists(\VHttpd\Manager::class) && !class_exists('VHttpd\\VHttpdManager', false)) {
    class_alias(\VHttpd\Manager::class, 'VHttpd\\VHttpdManager');
}
if (class_exists(\VHttpd\Psr7Bridge::class) && !class_exists('VHttpd\\VHttpdPsr7Bridge', false)) {
    class_alias(\VHttpd\Psr7Bridge::class, 'VHttpd\\VHttpdPsr7Bridge');
}
if (class_exists(\VHttpd\SlimPsr7Adapter::class) && !class_exists('VHttpd\\VSlimPsr7Adapter', false)) {
    class_alias(\VHttpd\SlimPsr7Adapter::class, 'VHttpd\\VSlimPsr7Adapter');
}
if (class_exists(\VHttpd\Manager::class) && !class_exists('VHttpdManager', false)) {
    class_alias(\VHttpd\Manager::class, 'VHttpdManager');
}
if (class_exists(\VHttpd\Psr7Bridge::class) && !class_exists('VHttpdPsr7Bridge', false)) {
    class_alias(\VHttpd\Psr7Bridge::class, 'VHttpdPsr7Bridge');
}
if (class_exists(\VHttpd\SlimPsr7Adapter::class) && !class_exists('VSlimPsr7Adapter', false)) {
    class_alias(\VHttpd\SlimPsr7Adapter::class, 'VSlimPsr7Adapter');
}
if (class_exists(\VHttpd\PhpWorker\Server::class) && !class_exists('VHttpd\\PhpWorker\\PhpWorker', false)) {
    class_alias(\VHttpd\PhpWorker\Server::class, 'VHttpd\\PhpWorker\\PhpWorker');
}
if (class_exists(\VHttpd\PhpWorker\Server::class) && !class_exists('PhpWorker', false)) {
    class_alias(\VHttpd\PhpWorker\Server::class, 'PhpWorker');
}
if (class_exists(\VHttpd\PhpWorker\StreamResponse::class) && !class_exists('VHttpd\\PhpWorker\\WorkerStreamResponse', false)) {
    class_alias(\VHttpd\PhpWorker\StreamResponse::class, 'VHttpd\\PhpWorker\\WorkerStreamResponse');
}
if (class_exists(\VHttpd\PhpWorker\StreamResponse::class) && !class_exists('WorkerStreamResponse', false)) {
    class_alias(\VHttpd\PhpWorker\StreamResponse::class, 'WorkerStreamResponse');
}
