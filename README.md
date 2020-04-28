# docker-siaprime

[![Build Status](https://travis-ci.org/abdomi/docker-siaprime.svg?branch=master)](https://travis-ci.org/abdomi/docker-siaprime) [![Docker Pulls](https://img.shields.io/docker/pulls/abdomi/docker-siaprime.svg?maxAge=604800)](https://hub.docker.com/r/abdomi/docker-siaprime/) [![License](http://img.shields.io/:license-mit-blue.svg?style=flat-square)](LICENSE)

SiaPrime adapted version of the original Sia docker image created by mtlynch - https://github.com/mtlynch/docker-sia

## Supported Tags

* latest: The latest official binary release.
* dev: The latest dev build from the SiaPrime Gitlab source.
* 1.4.2.0


## Usage

```bash
mkdir siaprime-data
docker run \
  --detach \
  --volume $(pwd)/siaprime-data:/siaprime-data \
  --publish 127.0.0.1:4280:4280 \
  --publish 4281:4281 \
  --publish 4282:4282 \
  --name siaprime-container \
   abdomi/siaprime
```

**Important**: Never publish port 4280 to all interfaces. This is a security-sensitive API, so only expose it beyond 127.0.0.1 if you know what you're doing.

Once the container is running, you can execute spc from within the container:

```bash
$ docker exec -it siaprime-container ./spc consensus
Synced: No
Height: 2027
Progress (estimated): 99.3%
```

You can also call siad from outside the container:

```bash
$ curl -A "SiaPrime-Agent" "http://localhost:4280/consensus"
```

## More examples

For more usage examples, see the blog post, ["Fun with Sia and Docker."](https://blog.spaceduck.io/sia-docker/)
