# vhttpd 1.1: veb Reuse Plan

## Goal

Maximize `veb` reuse in `vhttpd` without breaking `vslim`'s runtime route model.

## Reuse Boundary

- `vhttpd` should heavily reuse `veb` for HTTP serving concerns.
- `vslim` should keep runtime route registration/dispatch in userland (PHP-driven), not compile-time `veb` routes.

This boundary is intentional:

- `veb` route annotations are compile-time.
- `vslim` routes (`App->get/group/middleware`) are runtime.

## What We Already Reuse

- route attributes with method constraints and wildcard path:
  - `@['/admin/workers'; get]`
  - `@['/:path...'; get/post/... ]`
- middleware chain (`veb.Middleware`) and `request_id` middleware
- SSE streaming helpers (`veb.sse`) plus takeover patterns
- `veb.run_at` as process entrypoint

## High-Value Reuse (P0)

1. Controller split for route domains (`register_controller`)
- target: split data plane and admin plane handlers into clearer controller structs
- benefit: cleaner ownership, easier review and test isolation

2. Route-scoped middleware (`route_use`)
- target: attach auth/token checks and observability middleware only to `/admin/*`
- benefit: avoid broad middleware side effects

3. Context lifecycle hook (`before_request`)
- target: central request pre-processing (trace propagation defaults, request shaping)
- benefit: reduce duplicated setup code in handlers

4. `Context.not_found` override
- target: unify 404 contract and logging for both data/admin plane
- benefit: stable error semantics for clients and tests

## Mid-Value Reuse (P1)

1. `veb.csrf` for admin web form endpoints (if/when UI forms exist)
- use `csrf.middleware` only on state-changing admin form routes

2. Static asset serving (`handle_static` / `mount_static_folder_at`) for optional admin UI
- keep API-only mode default

3. Host-aware routing (host attribute or host controllers)
- useful for explicit internal admin host separation in single process mode

## Selective/Optional Reuse (P2)

1. `veb.auth` integration
- use only if vhttpd owns full auth/session model
- for token-only admin API, custom lightweight middleware stays simpler

2. Template stack
- not needed for API-first mode, optional for embedded diagnostics UI

## Not Recommended

1. Replacing `vslim` runtime routing with `veb` compile-time handlers
- breaks PHP dynamic route registration model
- removes framework-level flexibility expected by PHP users

## Suggested 1.1 Execution Order

1. P0.1: controller split (`data`, `admin`, `debug`)
2. P0.2: move admin auth checks to route middleware
3. P0.3: centralized `before_request` + `not_found`
4. P1.1: optional static admin assets (behind config flag)
5. P1.2: optional CSRF middleware for admin HTML form routes

## Source Notes (from vdoc)

- `veb` docs: route attributes, route order, host routing, `register_controller`, middleware, `route_use`, `before_request`, `Context.not_found`, `Context.takeover_conn`
- `veb.sse`: `start_connection`, `SSEConnection.send_message`, `SSEMessage`
- `veb.request_id`: middleware config and generator/conditional hooks
- `veb.csrf`: route/global middleware usage and `CsrfConfig`
- `veb.auth`: generic auth model with DB-backed examples
