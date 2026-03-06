# vhttpd PSR-7/15 Support Matrix

本文档定义 `vhttpd -> php-worker -> app` 这条链路当前能力与下一步目标。

## Scope

- `vhttpd` 负责 HTTP 接入与 envelope 转发
- `php-worker.php` 负责 app bootstrap、PSR 适配与响应归一
- `vslim` 仍是独立框架扩展，不等价于 PSR 实现本身

## PSR-7 (HTTP Message)

### Request Input (worker side)

- 当前输入契约：array envelope（method/path/query/headers/body/...）
- 当前可选桥接：`psr7_bridge.php` 将 envelope 转为 PSR-7 request 对象
- 已内置工厂检测：
  - `Nyholm\Psr7\Factory\Psr17Factory`
  - `GuzzleHttp\Psr7\HttpFactory`

### Response Output (worker side)

- app 可返回：
  - `VSlim\Response`
  - array envelope 形态
  - PSR-7 response 对象（通过 bridge 归一）
- worker 统一输出 transport envelope 给 `vhttpd`：
  - `status`
  - `content_type`
  - `headers`
  - `body`

### Compatibility Target

- 第一阶段（已完成）：Nyholm/Guzzle/Laminas(Diactoros) 可跑通
- 第二阶段（待补）：Nyholm+Symfony、Laminas 真实包回归矩阵
- 第三阶段（待补）：multipart/uploaded-files 边界一致性测试

## PSR-15 (HTTP Server Request Handlers)

### Current Status

- 已支持：bootstrap 直接返回 `Psr\Http\Server\RequestHandlerInterface`，worker 会调用 `handle($request)`
- 已支持：bootstrap 返回 middleware + handler（array 形态）时自动组装 dispatcher

### Next Delivery

- 增加更多 bootstrap 约定（例如仅 middleware 列表 + 默认 handler）并补错误提示
- 统一异常/超时行为到 `failure_model.md`

## Routing/Framework Neutrality

- `vhttpd` 不绑定 `VSlim\App`
- 默认仅依赖 PSR 请求/响应语义与 worker envelope
- `VSlimPsr7Adapter` 作为“示例桥接”，不是强制路径

## Acceptance Criteria

- 同一份 app（PSR-7/15）可在 `php-fpm + nginx` 和 `vhttpd + php-worker` 下返回一致状态码/头/body
- 支持至少 2 套 PSR-7 工厂实现 + 1 套 PSR-15 pipeline
- 基础异常场景（uncaught exception / invalid response / timeout）行为一致

## Real Package Matrix

- 回归命令：`make -C /Users/guweigang/Source/vphpext/vhttpd psr-matrix`
- 若 `composer` 不在默认 PATH，可指定：`COMPOSER_BIN=/abs/path/to/composer make -C /Users/guweigang/Source/vphpext/vhttpd psr-matrix`
- 脚本位置：`vslim/tests/run_psr_matrix.sh`
- 覆盖包：
  - `nyholm/psr7`
  - `guzzlehttp/psr7`
  - `laminas/laminas-diactoros`
