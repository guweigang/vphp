
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
