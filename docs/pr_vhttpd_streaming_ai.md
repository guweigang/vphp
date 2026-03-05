# PR: vhttpd Streaming Contract + AI Demo + Worker Streaming Fix

## Summary

This PR consolidates 5 commits that stabilize worker streaming and add a practical AI streaming demo path:

1. `a3605bd` Document vhttpd worker transport contract
2. `0b50d01` Add AI streaming demo and passthrough build fix
3. `505a193` Add streaming demo tests and unix-socket-aware skip
4. `14f5341` Fix worker streaming transfer over veb takeover
5. `47859a4` Add compact handoff doc for new threads

Scope:

- formalize worker transport contract/versioning
- add runnable AI token streaming demo app
- fix streaming behavior under current `veb` takeover semantics
- improve test safety in environments where Unix domain sockets are unavailable
- keep handoff context concise for follow-up threads

## Problem Statement

`vhttpd` worker streaming paths (`text` passthrough and `sse`) were unstable in practice under the current `veb` behavior:

- streaming responses could appear empty
- SSE requests could fail with connection reset behavior in client probes

In addition, transport contract details were scattered and not versioned explicitly.

## Root Cause (Streaming)

Under takeover mode, relying on `send_response_to_client(..., '')` in stream paths could emit `Content-Length: 0`.
That conflicts with progressive body streaming semantics.

## Solution

### 1. Transport Contract Documentation

Added:

- `vslim/httpd/transport_contract.md`

Includes:

- contract versioning rules (`v1`)
- frame format (4-byte length-prefixed JSON)
- request/response schema
- stream frame schema (`start/chunk/error/end`)
- production deployment notes

Also linked in:

- `vslim/httpd/README.md`

### 2. AI Streaming Demo

Added:

- `vslim/examples/ai-stream-app.php`

Provides endpoints:

- `GET /ai/stream?prompt=...` -> `stream_type=text`
- `GET /ai/sse?prompt=...` -> `stream_type=sse`

Integrated into demo tooling:

- `vslim/examples/run_demo.sh` (`ai` case)
- `vslim/Makefile` (`demo-ai`)
- `vslim/examples/README.md` usage docs

### 3. Streaming Transport Fix in vhttpd

Updated:

- `vslim/httpd/main.v`

Key changes:

- stream paths now write HTTP stream headers/body explicitly
- passthrough mode uses `Transfer-Encoding: chunked`
- SSE mode writes SSE lines directly to client connection
- avoids `Content-Length: 0` behavior on streaming paths

### 4. Tests

Added:

- `vslim/tests/test_ai_stream_demo_app.phpt`

Updated:

- `vslim/tests/test_httpd_worker_streaming.phpt`
  - adds Unix-socket capability probe
  - skips cleanly when Unix sockets are unavailable
  - adds non-SSE chunked semantics assertions for text stream path

### 5. Handoff

Added:

- `docs/handoff.md`

## Verification Commands

### Local/unit-style checks

```bash
php -l /Users/guweigang/Source/vphpext/vslim/examples/ai-stream-app.php
cd /Users/guweigang/Source/vphpext/vslim
TEST_PHP_EXECUTABLE="$(which php)" php ../v_php_ext/run-tests.php -q --show-all -d extension=./vslim.so tests/test_ai_stream_demo_app.phpt
```

Expected:

- syntax check passes
- `test_ai_stream_demo_app.phpt` passes

### Host end-to-end demo

```bash
make -C /Users/guweigang/Source/vphpext/vslim demo-ai
```

Expected:

- `/ai/stream` prints token chunks
- `/ai/sse` prints SSE events with `id/event/data/retry`
- no connection reset at demo end

### Optional streaming PHPT (environment dependent)

```bash
cd /Users/guweigang/Source/vphpext/vslim
TEST_PHP_EXECUTABLE="$(which php)" php ../v_php_ext/run-tests.php -q --show-all -d extension=./vslim.so tests/test_httpd_worker_streaming.phpt
```

Notes:

- test may skip where Unix sockets are blocked/restricted

## Risks / Tradeoffs

1. Manual stream header/body writing in `main.v` is lower-level and more sensitive to future `veb` internals than pure helper-based response APIs.
2. Chunked/text stream behavior depends on client compatibility with `Transfer-Encoding: chunked`.
3. SSE path currently closes connection explicitly after stream end; intermediaries/proxies should be validated in production topology.
4. `test_httpd_worker_streaming.phpt` now intentionally skips on environments without Unix sockets, which can hide regressions there unless CI has at least one socket-capable runner.

## Rollback Plan

- Revert `14f5341` first if streaming transport regression appears.
- Keep docs/tests commits for traceability, then selectively revert demo wiring if needed.

## Impacted Files

- `docs/handoff.md`
- `vslim/httpd/transport_contract.md`
- `vslim/httpd/README.md`
- `vslim/httpd/main.v`
- `vslim/examples/ai-stream-app.php`
- `vslim/examples/README.md`
- `vslim/examples/run_demo.sh`
- `vslim/Makefile`
- `vslim/tests/test_ai_stream_demo_app.phpt`
- `vslim/tests/test_httpd_worker_streaming.phpt`
