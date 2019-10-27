# docker-cadvisor
<p align="center">
  <a href="https://hub.docker.com/r/jmb12686/docker-cadvisor/tags?page=1&ordering=last_updated"><img src="https://img.shields.io/github/v/tag/jmb12686/docker-cadvisor?label=version&style=flat-square" alt="Latest Version"></a>
  <a href="https://github.com/jmb12686/docker-cadvisor/actions"><img src="https://github.com/jmb12686/docker-cadvisor/workflows/build/badge.svg" alt="Build Status"></a>
  <a href="https://hub.docker.com/r/jmb12686/cadvisor/"><img src="https://img.shields.io/docker/stars/jmb12686/cadvisor.svg?style=flat-square" alt="Docker Stars"></a>
  <a href="https://hub.docker.com/r/jmb12686/cadvisor/"><img src="https://img.shields.io/docker/pulls/jmb12686/cadvisor.svg?style=flat-square" alt="Docker Pulls"></a>
</p>

Containerized, multiarch version of cadvisor.  Multi-stage build is used to build from official [cadvisor source code](github.com/google/cadvisor).  Designed to be usable within x86-64, armv6, and armv7 based Docker Swarm clusters.  Designed to be compatible with all Raspberry Pi models (armv6 + armv7).

## Usage

On a single node:
```bash
sudo docker run \
  --volume=/var/run/docker.sock:/var/run/docker.sock:ro \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  jmb12686/cadvisor:latest
  ```

Within a Docker Swarm compose file:
```yml
  cadvisor:
    image: jmb12686/cadvisor
    networks:
      - net
    command: -logtostderr -docker_only
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - /:/rootfs:ro
      - /var/run:/var/run
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    ports:
      - 8080:8080
    deploy:
      mode: global
      resources:
        limits:
          memory: 128M
        reservations:
          memory: 64M
```
