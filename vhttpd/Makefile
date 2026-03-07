.PHONY: vhttpd demo-vslim demo-ai demo-symfony demo-laravel demo-wordpress psr-matrix

ROOT := $(CURDIR)
SRC_DIR := $(ROOT)/src
VHTTPD_BIN := $(ROOT)/vhttpd

build:
	v -o $(VHTTPD_BIN) $(SRC_DIR)

vhttpd:
	v -o $(VHTTPD_BIN) $(SRC_DIR)

demo-vslim:
	@$(ROOT)/examples/run_demo.sh vslim

demo-ai:
	@$(ROOT)/examples/run_demo.sh ai

demo-symfony:
	@$(ROOT)/examples/run_demo.sh symfony

demo-laravel:
	@$(ROOT)/examples/run_demo.sh laravel

demo-wordpress:
	@$(ROOT)/examples/run_demo.sh wordpress

psr-matrix:
	@$(MAKE) -C $(ROOT)/../vslim psr-matrix
