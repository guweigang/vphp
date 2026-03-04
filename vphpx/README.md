# vphpx

High-performance runtime toolkit for PHP userland, powered by V.

Positioning:

- Keep `vphp` as generic extension/bridge runtime.
- Use `vphpx` as productized toolchain:
  - API gateway / local runtime (`serve`)
  - sidecar connection pool daemon (`poold`)
  - data tooling (`data`)
  - benchmark runner (`bench`)

## Quick start

```bash
cd vphpx
v run ./cmd/vphpx/main.v --help
```

Try commands:

```bash
v run ./cmd/vphpx/main.v serve --listen 127.0.0.1:8080 --upstream http://127.0.0.1:9501
v run ./cmd/vphpx/main.v poold --socket /run/vphpx/poold.sock
v run ./cmd/vphpx/main.v data agg --in sales.csv --group-by region --sum amount
v run ./cmd/vphpx/main.v bench --scenario json_transform --iterations 20000
```

## Repo layout

- `cmd/vphpx/` CLI entry
- `core/config/` shared argument/config helpers
- `modules/serve/` gateway runtime
- `modules/poold/` sidecar pool daemon
- `modules/data/` data processing tools
- `modules/bench/` performance benchmarks
- `docs/` protocol and design docs
- `php/` PHP SDK helpers

## Status

MVP skeleton is ready. Next milestone:

1. implement `poold` unix socket server + protocol handlers
2. implement PHP SDK framed client
3. wire `serve` proxy mode with middleware chain

