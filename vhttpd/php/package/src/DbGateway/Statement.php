<?php

declare(strict_types=1);

namespace VHttpd\DbGateway;

final class Statement
{
    /** @var list<array<string,mixed>> */
    private array $rows;
    private int $cursor = 0;

    /**
     * @param list<array<string,mixed>> $rows
     */
    public function __construct(
        array $rows,
        private int $affectedRows = 0,
        private ?string $lastInsertId = null,
    ) {
        $this->rows = array_values($rows);
    }

    /** @return array<string,mixed>|false */
    public function fetch(): array|false
    {
        if (!isset($this->rows[$this->cursor])) {
            return false;
        }
        return $this->rows[$this->cursor++];
    }

    /** @return list<array<string,mixed>> */
    public function fetchAll(): array
    {
        return $this->rows;
    }

    public function rowCount(): int
    {
        return $this->affectedRows > 0 ? $this->affectedRows : count($this->rows);
    }

    public function lastInsertId(): ?string
    {
        return $this->lastInsertId;
    }
}
