Dockerized Shiny Server
=======================

This is a basic Dockerfile for Shiny Server based on Ubuntu 16.04. It can be use as a base Docker image for running SolveBio apps written with Shiny.

The image is available from [Docker Hub](https://registry.hub.docker.com/u/davecap/shiny/).


## Usage

To run a container with Shiny Server, go to the directory containing your app and run:

```sh
docker run --rm -p 5000:5000 davecap/shiny
```

Shiny Server logs are written to `stdout` and can be viewed using `docker logs`. The logs for individual apps are in the `/var/log/shiny-server` directory, as described in the [Shiny Server Administrator's Guide]( http://docs.rstudio.com/shiny-server/#application-error-logs)


## Legal

> RStudio and Shiny are trademarks of RStudio, Inc.
