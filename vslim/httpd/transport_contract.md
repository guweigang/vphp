# vhttpd Worker Transport Contract

This document defines the wire-level contract between:

- `vhttpd` (`vslim/httpd/main.v`)
- `php-worker.php` (`vslim/httpd/php-worker.php`)

It covers contract versioning, frame schema, and production deployment notes.

## Contract Versioning

Current transport contract version: **`v1`**

`v1` guarantees:

- worker request envelope is JSON, sent in length-prefixed frames
- one-shot response shape uses `id/status/headers/body`
- streaming response shape uses `mode=stream` with `start/chunk/error/end` events

Compatibility rules:

- additive fields are allowed and should be ignored by older peers
- existing field meanings must not change within `v1`
- removing or renaming required fields is a breaking change (`v2+`)
- old `*_json` envelope fields are not supported in `v1`

## Framing (Socket Wire Format)

Each message is written as:

1. 4-byte big-endian unsigned length (`N`)
2. UTF-8 JSON payload of exactly that length

Implementation guardrail:

- max frame size: `16 MiB` (`> 16 * 1024 * 1024` is rejected)

## Request Envelope Schema (`vhttpd -> php-worker`)

Canonical request payload:

```json
{
  "id": "trace-...",
  "method": "GET",
  "path": "/users/42?trace_id=worker",
  "body": "",
  "scheme": "https",
  "host": "example.test",
  "port": "443",
  "protocol_version": "1.1",
  "remote_addr": "127.0.0.1",
  "query": {"trace_id": "worker"},
  "headers": {"content-type": "application/json", "x-request-id": "req-..."},
  "cookies": {"sid": "cookie-7"},
  "attributes": {},
  "server": {
    "host": "example.test",
    "port": "443",
    "remote_addr": "127.0.0.1",
    "method": "GET",
    "url": "/users/42?trace_id=worker"
  },
  "uploaded_files": []
}
```

Notes:

- `path` remains canonical request target.
- `headers` are lower-cased at the boundary.
- `query` is carried separately to avoid reparsing.
- `uploaded_files` is reserved for later hydration.

## One-Shot Response Schema (`php-worker -> vhttpd`)

Normal non-stream response:

```json
{
  "id": "trace-...",
  "status": 200,
  "headers": {
    "content-type": "text/plain; charset=utf-8",
    "content-length": "2"
  },
  "body": "OK"
}
```

`content_type` may also be present for compatibility, but `vhttpd` currently reads content type from `headers["content-type"]`.

## Stream Frame Schema (`php-worker -> vhttpd`)

Streaming starts when first decoded frame is:

```json
{
  "mode": "stream",
  "event": "start",
  "id": "trace-...",
  "status": 200,
  "stream_type": "sse",
  "content_type": "text/event-stream",
  "headers": {"content-type": "text/event-stream"}
}
```

Then zero or more chunk frames:

```json
{
  "mode": "stream",
  "event": "chunk",
  "id": "trace-...",
  "data": "partial token"
}
```

SSE chunk extension fields:

```json
{
  "mode": "stream",
  "event": "chunk",
  "id": "trace-...",
  "sse_id": "evt-1",
  "sse_event": "message",
  "sse_retry": 1000,
  "data": "hello"
}
```

Optional stream error frame:

```json
{
  "mode": "stream",
  "event": "error",
  "id": "trace-...",
  "error_class": "worker_runtime_error",
  "error": "message"
}
```

Terminal frame:

```json
{
  "mode": "stream",
  "event": "end",
  "id": "trace-..."
}
```

Behavior notes:

- `stream_type=sse` (or `content_type` starting with `text/event-stream`) maps to true SSE output.
- other stream types are passthrough chunk output with `x-vhttpd-stream-mode: passthrough`.
- for `HEAD` requests, body chunks are not written to the client.

## Production Deployment Notes

Recommended baseline:

- run `vhttpd` and worker on the same host via Unix socket (`--worker-socket`)
- set explicit worker read timeout (`--worker-read-timeout-ms`) per SLO
- persist event log (`--event-log`) to durable storage for correlation
- keep worker autostart only for simple deployments; use process supervision in production
- always propagate and log `x-request-id` / `x-vhttpd-trace-id`

Operational tips:

- classify and alert on `x-vhttpd-error-class` (`timeout`, `transport_error`)
- classify and alert on worker headers (`x-worker-error-class`)
- keep payloads bounded; avoid very large single frames
- isolate worker bootstrap/config by setting `VSLIM_HTTPD_APP`

Rollout guidance:

- treat stream mode as opt-in app behavior (return `WorkerStreamResponse`)
- validate both one-shot and stream paths in smoke tests before promotion
- when evolving schema, add fields first and keep old readers tolerant
