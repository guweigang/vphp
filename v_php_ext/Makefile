.PHONY: all build test clean

# 默认目标：构建扩展
all: build

# 构建 .so 扩展
build:
	v -path ".:..:@vlib" run build.v

# 运行测试
test: build
	@./run_tests.sh

# 清理所有生成产物
clean:
	rm -f vphp_ext_*.c php_bridge.c php_bridge.h bridge.v v_php_ext.so
