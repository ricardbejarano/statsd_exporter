FROM golang:1-alpine AS build

ARG VERSION="0.23.1"
ARG CHECKSUM="bcdb24d1c0051588a14bad51ca9a6d4cb57f80ef89a2269b530d59cc6f76c0d8"

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
