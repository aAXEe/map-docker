This is the image we're using for our map at http://map.openseamap.org.
It is based on [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker).
The Dockerfile is based on [raumzeitlabor/mediawiki-docker](https://github.com/raumzeitlabor/mediawiki-docker).

The image comes without a
default installation. The webserver serves files from  `/data`.

# Requirements

This container is intended to be run behind a reverse-proxy and thus comes with an SSL
webserver configuration.
It is prepared to use [raumzeitlabor/nginx-proxy](https://github.com/raumzeitlabor/nginx-proxy).

# Setup

## config files
copy config file to docker host:
```
mkdir -p /var/lib/online-chart/
cp online_chart.ini /var/lib/online-chart/online_chart.ini
```

## Development

a) You can use `docker-compose` for the container startup and link the `/data` volume
to an local clone of [OpenSeaMap/online_chart](https://github.com/OpenSeaMap/online_chart).
See [aAXEe/server-alpha-docker](https://github.com/aAXEe/server-alpha-docker)
for an `docker-compose.yml`.

b) You can instruct the container to clone [OpenSeaMap/online_chart](https://github.com/OpenSeaMap/online_chart)
during startup:
```
docker run --rm=true --publish=8080:80 --env=GIT_REPO=https://github.com/OpenSeaMap/online_chart.git openseamap/map-docker:master
```

## Production

To set up this container, simply copy the `map.service` file to
`/etc/systemd/system` and run `systemctl daemon-reload`, followed by `systemctl
start map.service`.

The service unit will then take care of creating the container:

* `map-web`: The application container that houses an nginx webserver
and php5-fpm. It clones the online_chart git at startup.

To pull a new image from the docker hub:
```
systemctl reload map.service
```
