.PHONY: all build ext vhttpd serve test psr-matrix framework-matrix clean

BREW_PATH ?= /opt/homebrew
DISABLED_WARNINGS := -Wno-pointer-to-int-cast -Wno-incompatible-pointer-types -Wno-initializer-overrides
PHP_INC := $(shell php-config --includes)
PHP_LDFLAGS := $(shell php-config --ldflags)
PHP_LIBS := $(shell php-config --libs | sed 's/-lzip//g')
EXT_C := $(firstword $(wildcard vphp_ext_*.c))
ROOT := $(CURDIR)
VHTTPD_ROOT ?= $(abspath $(ROOT)/../vhttpd)
SRC_DIR := $(VHTTPD_ROOT)/src
VHTTPD_BIN := $(VHTTPD_ROOT)/vhttpd
VHTTPD_PORT ?= 19881
VHTTPD_HOST ?= 127.0.0.1
VHTTPD_PID_FILE ?= /tmp/vslim_vhttpd.pid
VHTTPD_EVENT_LOG ?= /tmp/vslim_vhttpd.events.ndjson
VSLIM_WORKER_SOCKET ?= /tmp/vslim_worker.sock
VSLIM_WORKER_CMD := php -d extension=$(ROOT)/vslim.so $(VHTTPD_ROOT)/php/php-worker.php --socket $(VSLIM_WORKER_SOCKET)

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

vhttpd:
	v -o $(VHTTPD_BIN) $(SRC_DIR)

serve: build vhttpd
	$(VHTTPD_BIN) \
		--host $(VHTTPD_HOST) \
		--port $(VHTTPD_PORT) \
		--pid-file $(VHTTPD_PID_FILE) \
		--event-log $(VHTTPD_EVENT_LOG) \
		--worker-socket $(VSLIM_WORKER_SOCKET) \
		--worker-autostart 1 \
		--worker-cmd '$(VSLIM_WORKER_CMD)'

test: build
	@./run_tests.sh

psr-matrix:
	@./tests/run_psr_matrix.sh

framework-matrix:
	@./tests/run_framework_matrix.sh

clean:
	rm -f vslim.so $(VHTTPD_BIN)
