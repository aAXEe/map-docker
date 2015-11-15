This is the image we're using for our map at http://map.openseamap.org.
It is based on [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker).
The Dockerfile is based on [raumzeitlabor/mediawiki-docker](https://github.com/raumzeitlabor/mediawiki-docker).

The files are pulled from github by default (https://github.com/OpenSeaMap/online_chart).

The image comes with a
default installation housed in `/data`.

### Requirements

This container requires a running, linked mysql instance, e.g.
[raumzeitlabor/mysql-docker](https://github.com/raumzeitlabor/mysql-docker). It
is intended to be run behind a reverse-proxy and thus comes with an SSL
webserver configuration.
It is prepared to use [raumzeitlabor/nginx-proxy](https://github.com/raumzeitlabor/nginx-proxy).

### Setup

To set up this container, simply copy the `map.service` file to
`/etc/systemd/system` and run `systemctl daemon-reload`, followed by `systemctl
start map.service`.

The service unit will then take care of creating the container:

* `map-web`: The application container that houses an nginx webserver,
and php5-fpm. It clones the online_chart git at startup
