# docker-cadvisor
Containerized, multiarch version of cadvisor.  Compatible with all Raspberry Pi models (armv6 + armv7) and linux/amd64.

## Usage
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

  ## TODO: Finish the documentation
