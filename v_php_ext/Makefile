.PHONY: all build ext test clean

BREW_PATH ?= /opt/homebrew
DISABLED_WARNINGS := -Wno-pointer-to-int-cast -Wno-incompatible-pointer-types -Wno-initializer-overrides
PHP_INC := $(shell php-config --includes)
PHP_LDFLAGS := $(shell php-config --ldflags)
PHP_LIBS := $(shell php-config --libs | sed 's/-lzip//g')
EXT_C := $(firstword $(wildcard vphp_ext_*.c))

# 默认目标：构建扩展
all: build

# 完整构建：先跑 vphp compiler，再链接扩展
build:
	v -path ".:..:@vlib" run build.v

# 仅使用仓库中已有的生成物链接扩展
ext:
	@if [ -z "$(EXT_C)" ]; then \
		echo "Error: no transpiled extension C file found (expected vphp_ext_*.c)."; \
		exit 1; \
	fi
	C_INCLUDE_PATH="$(BREW_PATH)/include/cjson" \
	gcc -shared -fPIC $(DISABLED_WARNINGS) -DCOMPILE_DL_VPHPTEST=1 \
		-I$(BREW_PATH)/include -L$(BREW_PATH)/lib -lcjson \
		-DcJSON_GetErrorPos=cJSON_GetErrorPtr \
		$(PHP_INC) $(EXT_C) php_bridge.c ../vphp/v_bridge.c -o v_php_ext.so \
		-I../vphp $(PHP_LDFLAGS) $(PHP_LIBS) -undefined dynamic_lookup -fvisibility=default

# 运行测试
test: build
	@./run_tests.sh

# 清理所有生成产物
clean:
	rm -f v_php_ext.so
