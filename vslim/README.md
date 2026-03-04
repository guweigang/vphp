# vslim

`vslim` 是一个独立于 `v_php_ext` 的示例扩展，用来验证一条更清晰的路线：

- `vphp` 提供 Zend binding、编译器和 runtime
- `vslim` 提供面向 PHP 开发者的 Slim-inspired 框架 API
- `vhttpd` 提供 HTTP runtime

一句话说：

> `vslim` 不是运行原版 Slim，而是做一个让 PHP 开发者心智熟悉的 V 微框架扩展。

## 当前目标

当前目录先落的是一个最小骨架：

- `VSlimApp`
- `VSlimResponse`
- `vslim_handle_request()`
- `vslim_demo_dispatch()`

它现在已经能表达一条完整边界：

- PHP 侧调用 `VSlimApp::demo()->dispatch(...)`
- 或直接调用 `vslim_handle_request()`
- 得到一个标准化响应结构

## 与 vhttpd 的交互模型

推荐的交互边界是：

```text
Client -> vhttpd -> PHP worker -> vslim -> PHP worker -> vhttpd -> Client
```

分工：

- `vhttpd`
  - 接收网络请求
  - 解析 method/path/query/body
  - 做连接管理、日志和可观测性

- PHP worker
  - 负责加载业务代码和 Composer 生态
  - 调用 `vslim_handle_request(...)` 或 `VSlim\\App`

- `vslim`
  - 负责路由匹配、请求分发、响应封装
  - 输出稳定的 `{status, body, content_type}` 结构

## 为什么这样分层

这样做的价值在于：

1. 不强行兼容原版 Slim 内部实现
2. 可以保留 PHP 生态和 userland 开发体验
3. `vhttpd` 不需要嵌入 PHP 解释器
4. `vslim` 可以逐步长成一个真正的 framework extension

说明：

- 当前第一版先使用 plain PHP class 名，优先把独立扩展骨架跑通
- 后面如果需要更强的 namespaced class 体验，可以再专门收编译器对“namespaced return object”的支持

## 当前示例路由

- `GET /health`
- `GET /hello/:name`
- `GET /meta`

## 构建与测试

```bash
cd /Users/guweigang/Source/vphpext/vslim
make build
make ext
make test
```

## 下一步建议

1. 给 `VSlim\\App` 加 middleware
2. 给 `VSlim\\Request` 建模
3. 定义 `vhttpd <-> PHP worker <-> vslim` 的标准请求/响应协议
4. 再考虑是否导出更完整的 PHP 面向对象 API
