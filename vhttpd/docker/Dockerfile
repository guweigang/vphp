FROM ubuntu:24.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    git \
    build-essential \
    pkg-config \
    make \
    php-cli \
    php-dev \
    php-xml \
    php-mbstring \
    php-curl \
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

EXPOSE 19881 19981

CMD ["/app/vhttpd/vhttpd", "--config", "/app/vhttpd/docker/config/hello.toml"]
