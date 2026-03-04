.PHONY: all build ext test clean

BREW_PATH ?= /opt/homebrew
DISABLED_WARNINGS := -Wno-pointer-to-int-cast -Wno-incompatible-pointer-types -Wno-initializer-overrides
PHP_INC := $(shell php-config --includes)
PHP_LDFLAGS := $(shell php-config --ldflags)
PHP_LIBS := $(shell php-config --libs | sed 's/-lzip//g')
EXT_C := $(firstword $(wildcard vphp_ext_*.c))

all: build

build:
	v -path ".:..:@vlib" run build.v

ext:
	@if [ -z "$(EXT_C)" ]; then \
		echo "Error: no transpiled extension C file found (expected vphp_ext_*.c)."; \
		exit 1; \
	fi
	C_INCLUDE_PATH="$(BREW_PATH)/include/cjson" \
	gcc -shared -fPIC $(DISABLED_WARNINGS) -DCOMPILE_DL_VSLIM=1 \
		-I$(BREW_PATH)/include -L$(BREW_PATH)/lib -lcjson \
		-DcJSON_GetErrorPos=cJSON_GetErrorPtr \
		$(PHP_INC) $(EXT_C) php_bridge.c ../vphp/v_bridge.c -o vslim.so \
		-I../vphp $(PHP_LDFLAGS) $(PHP_LIBS) -undefined dynamic_lookup -fvisibility=default

test: build
	@./run_tests.sh

clean:
	rm -f vslim.so
