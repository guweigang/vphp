# vphpx poold Protocol (Draft v0)

Transport:

- Unix domain socket (default: `/run/vphpx/poold.sock`)
- Frame: `4-byte big-endian length` + `JSON payload`

## Request

```json
{
  "id": "req-001",
  "op": "exec",
  "pool": "redis_main",
  "driver": "redis",
  "args": {
    "cmd": "GET",
    "key": "user:42"
  },
  "timeout_ms": 800
}
```

## Response

```json
{
  "id": "req-001",
  "ok": true,
  "status": "ok",
  "result": {
    "value": "..."
  },
  "error": "",
  "meta": {
    "latency_us": 230
  }
}
```

## Core ops

- `health`
- `stats`
- `exec`
- `pipeline`

## Error model

- `bad_request`
- `pool_not_found`
- `pool_exhausted`
- `backend_timeout`
- `backend_error`

