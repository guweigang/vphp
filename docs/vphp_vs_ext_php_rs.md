# vphp vs ext-php-rs：Ownership 与生命周期实现对比

本文用于对齐 `vphp` 当前实现与 `ext-php-rs` 的设计差异，重点关注：

- `borrowed / owned_request / owned_persistent`
- 请求周期回收模型
- 扩展开发者心智负担
- 在 `VSlim`/`vhttpd` 常驻场景下的工程实践

## 1. 总览对比

| 维度 | vphp（当前实现） | ext-php-rs |
|---|---|---|
| 核心抽象 | `BorrowedZVal` / `RequestOwnedZVal` / `PersistentOwnedZVal` | `ZBox<T>` + `IntoZval/FromZval` trait 体系 |
| 借用值 | `BorrowedZVal` 不由 vphp 释放，交给 Zend | 借用语义由 Rust 类型系统约束，底层仍走 Zend |
| 请求级 owned | `RequestOwnedZVal` 进入 autorelease pool，`request_scope` 结束 drain | request 生命周期内自动回收（配合 hook/Drop） |
| 持久级 owned | `PersistentOwnedZVal` 从 autorelease 脱钩，需显式 `release()` | persistent 分配显式声明，通常由长期持有者 Drop/析构管理 |
| 请求边界 | 显式 `request_scope(mark/drain)`，支持嵌套 | 通过模块 builder 的 request startup/shutdown 等钩子接入 |
| 默认安全性 | 高于裸 `ZVal`，但仍有 `to_zval()` 逃生口 | 更强编译期约束（Rust trait + borrow checker） |
| 可观测性 | 内建 `runtime_counters` + `[vslim.mem]` 埋点 | 官方抽象偏通用，观测通常由扩展自行实现 |
| 适用场景 | 适合 `vhttpd + php-worker` 常驻进程的精细控制 | 适合通用 PHP 扩展开发与 Rust 生态集成 |

## 2. 生命周期语义（vphp 现状）

### 2.1 BorrowedZVal

- 来源：PHP 入参、临时读路径、借用转换。
- 释放：不由 vphp 主动释放。
- 风险：若越过调用边界缓存 borrowed 引用，会变悬空语义（禁止）。

### 2.2 RequestOwnedZVal

- 创建：`own_request_zval(z)` 或 `RequestOwnedZVal.new_*()`。
- 行为：进入 `owned_pool`，并加入 `autorelease_pool`。
- 释放：
  1. 推荐路径：`request_scope.close()` -> `autorelease_drain(mark)` 自动释放；
  2. 可选路径：显式 `release()` 提前释放。

### 2.3 PersistentOwnedZVal

- 创建：`own_persistent_zval(z)` 或 `PersistentOwnedZVal.new_*()`。
- 行为：从 `autorelease_pool` 中移除（不会被 request drain 清掉）。
- 释放：由持有者显式 `release()`（通常在 `free()`/析构中）。

> 结论：`owned_persistent` 是手动管理，不是“全局 autorelease”。

## 3. Request Cycle 回收边界（VSlim）

`VSlimApp` 的 request 入口（`dispatch_request` / `dispatch_envelope` / `dispatch_envelope_map`）均显式创建 `request_scope`，并在 `defer` 中关闭。

这意味着：

- 当前请求创建的 `owned_request` 会在请求结束时 drain；
- 嵌套 dispatch（内部再次 dispatch）可通过 mark/drain 正确分层释放；
- `active_middleware_chains` 通过 `defer` 出栈，不会跨请求残留。

## 4. 为什么 RSS 仍可能波动

即使请求上下文已释放，RSS 也可能不立即下降，常见原因：

- Zend/系统分配器保留已回收页用于后续复用；
- 短时间高频分配导致进程驻留内存上冲后缓慢回落；
- 持久对象（`owned_persistent`）本来就不会随请求释放。

因此应结合以下指标判断泄漏，而非只看单点 RSS：

- `runtime_counters.autorelease_len`
- `runtime_counters.owned_len`
- worker `served_requests` 与 `rss_kb` 斜率

## 5. 对扩展开发者的约束建议

1. 外部 API 入参默认按 `BorrowedZVal` 使用。
2. 仅在需要跨语句/跨阶段保存时，显式 clone 为 `RequestOwnedZVal`。
3. 仅在需要跨请求保存时，才升级为 `PersistentOwnedZVal`，并保证释放点。
4. 框架业务层避免裸 `ZVal` 流转；裸 `ZVal` 仅保留在 bridge 内核层。

## 6. 落地检查清单

- [ ] 每个请求入口是否有 `request_scope`。
- [ ] 是否存在把 `BorrowedZVal` 挂到全局/长生命周期容器的路径。
- [ ] 所有 `PersistentOwnedZVal` 是否有对应 `release()` 路径。
- [ ] 压测时 `autorelease_len` 是否随请求回落到稳定区间。
- [ ] 在 10k/50k/100k 请求窗口下，`owned_len` 是否出现单调增长。

## 7. 关键代码位置（本仓库）

- `vphp` 生命周期封装：`vphp/lifecycle.v`
- `ZVal` 与 autorelease/owned 逻辑：`vphp/zval.v`
- C 侧 pool 与 drain：`vphp/v_bridge.c`
- VSlim request 入口与 middleware 链：`vslim/src/php_app.v`

## 8. 参考资料

- ext-php-rs 文档：[https://docs.rs/ext-php-rs](https://docs.rs/ext-php-rs)
- ZBox 说明：[https://docs.rs/ext-php-rs/latest/ext_php_rs/boxed/struct.ZBox.html](https://docs.rs/ext-php-rs/latest/ext_php_rs/boxed/struct.ZBox.html)
- ModuleBuilder 生命周期钩子：[https://docs.rs/ext-php-rs/latest/ext_php_rs/builders/struct.ModuleBuilder.html](https://docs.rs/ext-php-rs/latest/ext_php_rs/builders/struct.ModuleBuilder.html)
