<?php

declare(strict_types=1);

/**
 * PHP SDK skeleton for vphpx poold sidecar.
 * Protocol implementation will be added in next milestone.
 */
final class VphpxPoolClient
{
    private string $socketPath;

    public function __construct(string $socketPath = '/run/vphpx/poold.sock')
    {
        $this->socketPath = $socketPath;
    }

    public function socketPath(): string
    {
        return $this->socketPath;
    }

    /**
     * @return array<string,mixed>
     */
    public function health(): array
    {
        return [
            'ok' => false,
            'status' => 'not_implemented',
            'socket' => $this->socketPath,
        ];
    }
}

