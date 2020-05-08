#
# Dockerfile for shadowsocks-libev (ss-local)
#

FROM alpine

ARG LIBEV_VERSION=v3.3.4

ENV SERVER_ADDR 0.0.0.0
ENV SERVER_PORT 8388
ENV PASSWORD=
ENV METHOD aes-256-gcm
ENV TIMEOUT 300
ENV LISTEN_ADDR 127.0.0.1
ENV LISTEN_PORT 1080
ENV ARGS=

RUN set -ex \
 # Build environment setup
 && apk add --no-cache --virtual .build-deps \
      autoconf \
      automake \
      build-base \
      c-ares-dev \
      libev-dev \
      libtool \
      libsodium-dev \
      linux-headers \
      mbedtls-dev \
      pcre-dev \
      git \

 # Build & install
 && mkdir -p /tmp/repo \
 && cd /tmp/repo \
 && git clone https://github.com/shadowsocks/shadowsocks-libev.git \
 && cd shadowsocks-libev \
 && git checkout "$LIBEV_VERSION" \
 && git submodule update --init --recursive \
 && ./autogen.sh \
 && ./configure --prefix=/usr --disable-documentation \
 && make install \
 && apk del .build-deps \
 # Runtime dependencies setup
 && apk add --no-cache \
      ca-certificates \
      rng-tools \
      tzdata \
      $(scanelf --needed --nobanner /usr/bin/ss-* \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u) \
 && rm -rf /tmp/repo

EXPOSE $LISTEN_PORT

ENTRYPOINT ss-local -s "$SERVER_ADDR" \
                    -p "$SERVER_PORT" \
                    -k "$PASSWORD" \
                    -m "$METHOD" \
                    -d "$DNS_ADDRS" \
                    -b "$LISTEN_ADDR" \
                    -l "$LISTEN_PORT" \
                    -t "$TIMEOUT" \
                    "$ARGS"
