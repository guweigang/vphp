
## k6 压测示例

脚本：`k6_demo.js`

```bash
k6 run /Users/guweigang/Source/vphpext/vslim/examples/k6_demo.js
```

可选环境变量：

```bash
BASE_URL=http://127.0.0.1:19888 API_TOKEN=demo-token k6 run /Users/guweigang/Source/vphpext/vslim/examples/k6_demo.js
```

单路由压测（定位内存增长）：

```bash
# 仅 hello
BASE_URL=http://127.0.0.1:19888 ROUTE_MODE=hello k6 run /Users/guweigang/Source/vphpext/vslim/examples/k6_demo.js

# 仅 api
BASE_URL=http://127.0.0.1:19888 API_TOKEN=demo-token ROUTE_MODE=api k6 run /Users/guweigang/Source/vphpext/vslim/examples/k6_demo.js

# 仅 forms
BASE_URL=http://127.0.0.1:19888 ROUTE_MODE=forms k6 run /Users/guweigang/Source/vphpext/vslim/examples/k6_demo.js

# 仅 health
BASE_URL=http://127.0.0.1:19888 ROUTE_MODE=health k6 run /Users/guweigang/Source/vphpext/vslim/examples/k6_demo.js
```

## 性能基线（本地实测）

测试环境：

- 机器：MacBook Air M2（16 GB）
- worker：4 进程（`worker.pool_size = 4`）
- 时长：50 秒
- 脚本：`k6_demo.js`（mixed_routes 场景，30 VUs 峰值）

结果（关闭 `VSLIM_TRACE_MEM` 后）：

- `http_reqs`: `3998.71 req/s`
- `http_req_duration`: `avg 3.89ms`, `p95 7.42ms`, `p99 11.47ms`
- `http_req_failed`: `0.00%`
- `server_error_rate`: `0.00%`

说明：

- 开启 `VSLIM_TRACE_MEM` 会带来可观开销，QPS 与延迟都会变差。
- 建议线上默认关闭 trace，仅在诊断时按需打开（并设置较大的采样间隔）。
