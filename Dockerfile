## Build stage - Build cadvisor from latest source
FROM golang:alpine as builder

RUN apk update && apk add --no-cache git && \
    apk add --no-cache make && \
    apk add --no-cache bash && \
    apk add --no-cache gcc && \
    apk add --no-cache libc-dev 

RUN mkdir -p $GOPATH/src/github.com/google/cadvisor && \
    git clone --branch v0.34.0 --depth 1 https://github.com/google/cadvisor.git $GOPATH/src/github.com/google/cadvisor
WORKDIR $GOPATH/src/github.com/google/cadvisor
RUN make build

## Run stage - Install dependencies and copy cadvisor from builder
FROM alpine

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL maintainer="John Belisle" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.name="cadvisor" \
  org.label-schema.description="Containerized, multiarch version of cadvisor.  Compatible with all Raspberry Pi models (armv6 + armv7) and linux/amd64." \
  org.label-schema.version=$VERSION \
  org.label-schema.url="https://github.com/jmb12686/docker-cadvisor" \
  org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.vcs-url="https://github.com/jmb12686/docker-cadvisor" \
  org.label-schema.vendor="jmb12686" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.docker.cmd="sudo docker run \
  --volume=/var/run/docker.sock:/var/run/docker.sock:ro \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  jmb12686/cadvisor:latest"

RUN apk --no-cache add libc6-compat device-mapper findutils && \
    apk --no-cache add thin-provisioning-tools --repository http://dl-3.alpinelinux.org/alpine/edge/main/ && \
    echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf && \
    rm -rf /var/cache/apk/*

COPY --from=builder go/src/github.com/google/cadvisor/cadvisor /usr/bin/cadvisor

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --quiet --tries=1 --spider http://localhost:8080/healthz || exit 1

ENTRYPOINT ["/usr/bin/cadvisor", "-logtostderr"]
