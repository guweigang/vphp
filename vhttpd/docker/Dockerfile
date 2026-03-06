FROM php:8.5.3-cli-bookworm AS builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    build-essential \
    pkg-config \
    make \
    libcjson-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth=1 https://github.com/vlang/v /opt/v \
    && make -C /opt/v \
    && ln -sf /opt/v/v /usr/local/bin/v

WORKDIR /app
COPY . /app

# Build vslim extension and vhttpd binary for Linux runtime.
RUN make -C /app/vslim build \
    && gcc -shared -fPIC \
      -Wno-pointer-to-int-cast -Wno-incompatible-pointer-types -Wno-initializer-overrides \
      -DCOMPILE_DL_VSLIM=1 \
      -DcJSON_GetErrorPos=cJSON_GetErrorPtr \
      $(php-config --includes) \
      /app/vslim/vphp_ext_vslim.c \
      /app/vslim/php_bridge.c \
      /app/vphp/v_bridge.c \
      -o /app/vslim/vslim.so \
      -I/app/vphp \
      $(php-config --ldflags) \
      $(php-config --libs | sed 's/-lzip//g') \
      -lcjson -fvisibility=default \
    && make -C /app/vhttpd vhttpd

FROM php:8.5.3-cli-bookworm

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcjson1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app/vhttpd/vhttpd /app/vhttpd/vhttpd
COPY --from=builder /app/vhttpd/config /app/vhttpd/config
COPY --from=builder /app/vhttpd/docker/config /app/vhttpd/docker/config
COPY --from=builder /app/vhttpd/examples /app/vhttpd/examples
COPY --from=builder /app/vhttpd/php /app/vhttpd/php
COPY --from=builder /app/vslim/vslim.so /app/vslim/vslim.so

EXPOSE 19881 19981

ENTRYPOINT ["/app/vhttpd/vhttpd"]
CMD ["--config", "/app/vhttpd/docker/config/hello.toml"]
