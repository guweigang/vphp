# vhttpd / php-worker Failure & Timeout Model

本文档定义链路故障时的统一语义，避免不同 app/framework 出现不一致行为。

## Error Classes

1. Transport Error
- 定义：`vhttpd` 与 worker 通讯失败（socket 断开、协议损坏、读写失败）
- 默认返回：`502 Bad Gateway`

2. Worker Runtime Error
- 定义：worker 内部异常、bootstrap 失败、未捕获 Throwable
- 默认返回：`500 Internal Server Error`

3. App Contract Error
- 定义：app 返回非预期类型，无法归一为 response
- 默认返回：`500 Internal Server Error`

4. Timeout
- 定义：worker 在限定时间内未返回可解析响应
- 默认返回：`504 Gateway Timeout`

## Response Envelope on Failure

最小约定（无论错误来源）：

```php
[
    'status' => 500, // or 502/504
    'content_type' => 'text/plain; charset=utf-8',
    'headers' => [
        'x-vhttpd-error-class' => 'worker_runtime_error',
        'x-vhttpd-trace-id' => '...',
    ],
    'body' => 'Internal Server Error',
]
```

说明：

- `vhttpd` transport 失败时会设置 `x-vhttpd-error-class` / `x-vhttpd-trace-id`
- worker 归一失败时会设置：
  - `x-worker-error-class`（例如 `worker_runtime_error` / `app_contract_error`）
  - `x-worker-exception`（PHP 异常类名，如 `RuntimeException` / `TypeError`）

## Timeout Semantics

- 维度：
  - connect timeout（连 worker）
  - read timeout（等 worker 响应）
  - global request timeout（端到端上限）
- 建议默认值（首版）：
  - connect: 200ms
  - read: 3s（`vhttpd --worker-read-timeout-ms 3000`）
  - global: 5s
- 超时后：
  - 立刻返回 504
  - 记录结构化事件（包含 path/method/trace_id/duration_ms）

## Exception Mapping (Worker Side)

- 未捕获 Throwable -> 500
- `TypeError` / `InvalidArgumentException` / `LogicException` -> `app_contract_error`
- 其他 Throwable -> `worker_runtime_error`
- bootstrap 无法加载 callable/app -> 500
- PSR-7 bridge 构建失败 -> 500
- response normalize 失败 -> 500

## Observability Fields

每条失败日志至少包含：

- `trace_id`
- `request_id`（若有）
- `method`
- `path`
- `status`
- `error_class`
- `error_message`（生产可脱敏）
- `duration_ms`

## Non-Goals (当前阶段)

- 不做自动重试（避免非幂等请求副作用）
- 不在 `vhttpd` 层做业务级 fallback
- 不在失败场景透传 PHP 栈到客户端
