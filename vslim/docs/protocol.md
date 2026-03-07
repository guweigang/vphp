# VSlim / vhttpd Worker Protocol

This document defines the stable transport contract between:

- `vhttpd` data plane
- `php-worker` (Composer/runtime bridge)
- `vslim` request dispatcher

## Request Envelope (data -> worker)

Required fields:

- `method` (string)
- `path` (string, includes query in URI form when available)

Optional fields (recommended):

- `body` (string)
- `scheme` (string)
- `host` (string)
- `port` (string)
- `protocol_version` (string)
- `remote_addr` (string)
- `headers` (`array<string,string>`)
- `cookies` (`array<string,string>`)
- `query` (`array<string,string>`)
- `attributes` (`array<string,string>`)
- `server` (`array<string,string>`)
- `uploaded_files` (`string[]`)

Example:

```php
[
  'method' => 'GET',
  'path' => '/users/42?trace_id=demo',
  'body' => '',
  'scheme' => 'https',
  'host' => 'example.test',
  'port' => '443',
  'protocol_version' => '1.1',
  'remote_addr' => '127.0.0.1',
  'headers' => ['x-request-id' => 'req-1', 'x-trace-id' => 'trace-1'],
  'cookies' => ['sid' => 'cookie-1'],
  'query' => ['trace_id' => 'demo'],
  'attributes' => [],
  'server' => [],
  'uploaded_files' => [],
]
```

## Response Envelope (worker -> data)

Normalized worker response shape:

- `id` (string)
- `status` (int)
- `content_type` (string)
- `headers` (`array<string,string>`)
- `body` (string)

`php-worker` normalizes app return values (`VSlim\Response`, `array`, PSR-7 response, string) to this shape.

## VSlim `dispatch_envelope_map(...)` shape

When using map-style dispatch (`map<string,string>`):

- `status` (stringified integer)
- `body` (string)
- `content_type` (string)
- `headers_<lowercase-name>` (string, for each response header)

Examples:

- `headers_content-type`
- `headers_x-request-id`
- `headers_x-trace-id`
- `headers_x-vhttpd-trace-id`

## Header propagation rules

If route/handler does not override them, VSlim propagates:

- request id: `x-request-id`
- trace id: `x-trace-id`
- vhttpd trace id mirror: `x-vhttpd-trace-id`

These headers are available both in:

- `dispatch_request(...)` / `dispatch_envelope(...)` response headers
- `dispatch_envelope_map(...)` as `headers_*` fields

## Contract tests

Current protocol contract is guarded by tests:

- `tests/test_vslim_dispatch_envelope_map_headers.phpt`
- `tests/test_vslim_worker_envelope_map.phpt`
