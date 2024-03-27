FROM golang:1-alpine AS build

ARG VERSION="0.26.1"
ARG CHECKSUM="cebf1dec32f3552065fb0224f100d24f638f33a876fa6f039c4da7af4e4aef0e"

ADD https://github.com/prometheus/statsd_exporter/archive/v$VERSION.tar.gz /tmp/statsd_exporter.tar.gz

RUN [ "$(sha256sum /tmp/statsd_exporter.tar.gz | awk '{print $1}')" = "$CHECKSUM" ] && \
    apk add bash ca-certificates curl make && \
    tar -C /tmp -xf /tmp/statsd_exporter.tar.gz && \
    mkdir -p /go/src/github.com/prometheus && \
    mv /tmp/statsd_exporter-$VERSION /go/src/github.com/prometheus/statsd_exporter && \
    cd /go/src/github.com/prometheus/statsd_exporter && \
      make build

RUN mkdir -p /rootfs/bin && \
      cp /go/src/github.com/prometheus/statsd_exporter/statsd_exporter /rootfs/bin/ && \
    mkdir -p /rootfs/etc && \
      echo "nogroup:*:10000:nobody" > /rootfs/etc/group && \
      echo "nobody:*:10000:10000:::" > /rootfs/etc/passwd && \
    mkdir -p /rootfs/etc/ssl/certs && \
      cp /etc/ssl/certs/ca-certificates.crt /rootfs/etc/ssl/certs/


FROM scratch

COPY --from=build --chown=10000:10000 /rootfs /

USER 10000:10000
EXPOSE 9102/tcp 9125/tcp 9125/udp
ENTRYPOINT ["/bin/statsd_exporter"]
