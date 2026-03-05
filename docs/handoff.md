# Handoff (2026-03-05)

## 1) Current Goal
- Stabilize and productize `vphp + vslim + vhttpd`.
- Keep boundaries clear:
  - `vphp`: generic bridge/runtime interop
  - `vslim`: framework/runtime layer
  - `vhttpd`: `veb`-based server and worker transport

## 2) Recent Key Commits (latest first)
- `3238931` Use examples projects for matrix runs and ignore temp dirs
- `fec193b` Add framework examples and matrix runner scripts
- `881f321` Add vhttpd worker PSR bridge and failure coverage
- `182b0d6` Refactor VSlim runtime and route core
- `c1503cc` Enhance vphp interop and ZVal conversion APIs
- `0d9585d` Add request ID/SSE and worker streaming tests
- `2b6fa26` Add worker streaming protocol and passthrough mode

## 3) What Was Finished
- `vhttpd` aligned with `veb.request_id` and `veb.sse`.
- Worker protocol extended from one-shot response to stream frames:
  - `start / chunk / error / end`
  - `stream_type=sse` and non-SSE passthrough mode.
- `php-worker.php` supports `WorkerStreamResponse`:
  - `WorkerStreamResponse::sse(...)`
  - `WorkerStreamResponse::text(...)`
- Added/updated tests for:
  - request id + SSE
  - worker timeout/error classification
  - PSR-7/PSR-15 worker path
  - worker streaming
- Added runnable framework examples:
  - `vslim/examples/laravel`
  - `vslim/examples/symfony`
  - `vslim/examples/wordpress`
- Matrix scripts now use `examples/*` projects instead of `vslim/.tmp`.

## 4) Current Repo State
- Working tree clean (`git status` empty).
- Temp/runtime paths are ignored by `vslim/.gitignore`:
  - `.tmp/`
  - `examples/.runtime/`
  - `examples/*/vendor/`

## 5) Most Useful Commands
- Build/test vphp extension:
```bash
make -C /Users/guweigang/Source/vphpext/v_php_ext test
```

- Build/test vslim extension:
```bash
make -C /Users/guweigang/Source/vphpext/vslim test
```

- Start vhttpd with worker:
```bash
make -C /Users/guweigang/Source/vphpext/vslim serve
```

- Example demos:
```bash
make -C /Users/guweigang/Source/vphpext/vslim demo-vslim
make -C /Users/guweigang/Source/vphpext/vslim demo-symfony
make -C /Users/guweigang/Source/vphpext/vslim demo-laravel
VSLIM_WP_ROOT=/abs/path/to/wordpress make -C /Users/guweigang/Source/vphpext/vslim demo-wordpress
```

- Matrix checks:
```bash
bash /Users/guweigang/Source/vphpext/vslim/tests/run_psr_matrix.sh
bash /Users/guweigang/Source/vphpext/vslim/tests/run_framework_matrix.sh
```

## 6) Suggested Next Work
- Add true non-SSE chunked semantics verification test (network-enabled env).
- Add one end-to-end AI token streaming demo app in `vslim/examples`.
- Tighten docs:
  - transport contract versioning
  - stream frame schema
  - production deployment notes.

## 7) How To Continue In A New Thread
- Start with:
  - read this file only: `docs/handoff.md`
  - then inspect `git log --oneline -n 10`
- Prompt template:
  - “Ignore old chat history. Use `docs/handoff.md` + current repo state only.”
