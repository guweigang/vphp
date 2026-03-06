<?php

declare(strict_types=1);

namespace VHttpd\DbGateway;

final class PDOStatement
{
    /** @var array<int|string,mixed> */
    private array $bindings = [];

    /** @var list<array<string,mixed>> */
    private array $rows = [];
    private int $cursor = 0;
    private int $affectedRows = 0;
    private ?string $lastInsertId = null;

    public function __construct(
        private PDO $pdo,
        private string $sql,
    ) {
    }

    public function bindValue(int|string $param, mixed $value): bool
    {
        $this->bindings[$param] = $value;
        return true;
    }

    public function bindParam(int|string $param, mixed &$value): bool
    {
        $this->bindings[$param] = $value;
        return true;
    }

    /** @param array<int|string,mixed>|null $params */
    public function execute(?array $params = null): bool
    {
        $bindings = $params ?? $this->bindings;
        $ordered = $this->normalizeBindings($bindings);
        $this->cursor = 0;

        if ($this->pdo->isQuerySql($this->sql)) {
            $result = $this->pdo->gatewayQuery($this->sql, $ordered);
            $this->rows = $this->normalizeRows($result['rows'] ?? []);
            $this->affectedRows = (int) ($result['row_count'] ?? count($this->rows));
            $this->lastInsertId = isset($result['last_insert_id']) ? (string) $result['last_insert_id'] : null;
            return true;
        }

        $result = $this->pdo->gatewayExecute($this->sql, $ordered);
        $this->rows = [];
        $this->affectedRows = (int) ($result['affected_rows'] ?? 0);
        $this->lastInsertId = isset($result['last_insert_id']) ? (string) $result['last_insert_id'] : null;
        return true;
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

    /** @param array<int|string,mixed> $bindings
     *  @return array<int,mixed>
     */
    private function normalizeBindings(array $bindings): array
    {
        if ($bindings === []) {
            return [];
        }
        $allNumeric = true;
        foreach (array_keys($bindings) as $k) {
            if (!is_int($k)) {
                $allNumeric = false;
                break;
            }
        }
        if ($allNumeric) {
            ksort($bindings);
            return array_values($bindings);
        }

        $ordered = [];
        foreach ($bindings as $value) {
            $ordered[] = $value;
        }
        return $ordered;
    }

    /**
     * @param mixed $rows
     * @return list<array<string,mixed>>
     */
    private function normalizeRows(mixed $rows): array
    {
        if (!is_array($rows)) {
            return [];
        }
        $out = [];
        foreach ($rows as $row) {
            if (!is_array($row)) {
                continue;
            }
            $normalized = [];
            foreach ($row as $k => $v) {
                $normalized[(string) $k] = $v;
            }
            $out[] = $normalized;
        }
        return $out;
    }
}

