<?php

namespace Demo\IncludeCase;

final class ModuleBox
{
    public function __construct(public string $name) {}

    public function describe(): string
    {
        return "box:{$this->name}";
    }
}

return [
    'mode' => 'prod',
    'driver' => 'mysql',
    'host' => '127.0.0.1',
];
