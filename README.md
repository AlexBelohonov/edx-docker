# edx-ginkgo-docker
A dockerized version of Open edX running `open-release/ginkgo.master` version.
(Only LMS and Studio for now)

### Requirements:

```
docker (version 17.09 or higher)
docker-compose (version 1.17.1 or higher)

### Installation

Run the following commands in order:

1. `make build.base`
2. `make build.edxapp`
3. `make clone`
4. `make provision`
5. `docker-compose stop`
6. `make up`

Note: if you want to build your own images rename `karacic/<image_name>` with `<username>/<image_name>`
in the Makefile.

### Bug reporting

I would very much appreciate any bug reports, so if you find a bug please [open an issue](https://github.com/vkaracic/edx-ginkgo-docker/issues/new) for it.