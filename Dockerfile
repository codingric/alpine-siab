FROM alpine:3.21.3
LABEL org.opencontainers.image.authors="ricardo@salinas.id.au"

# Add s6-overlay
ENV S6_OVERLAY_VERSION=v2.2.0.3 \
    GO_DNSMASQ_VERSION=1.0.7

RUN apk add --update --no-cache bind-tools curl libcap bash net-tools openssl pwgen && \ 
	apk upgrade --available && \
	curl -sSL https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-amd64.tar.gz | tar xfz - -C /  && \
	curl -sSL https://github.com/janeczku/go-dnsmasq/releases/download/${GO_DNSMASQ_VERSION}/go-dnsmasq-min_linux-amd64 -o /bin/go-dnsmasq && \
	chmod +x /bin/go-dnsmasq && \
	addgroup go-dnsmasq && \
	adduser -D -g "" -s /bin/sh -G go-dnsmasq go-dnsmasq && \
	setcap CAP_NET_BIND_SERVICE=+eip /bin/go-dnsmasq && \
	rm -rf /var/cache/apk/*

COPY root /

ENTRYPOINT ["/init"]
CMD []

ENV SIAB_USERCSS="Normal:+/etc/shellinabox/options-enabled/00_White-On-Black.css,Reverse:-/etc/shellinabox/options-enabled/00+Black-on-White.css;Colors:+/etc/shellinabox/options-enabled/01+Color-Terminal.css,Monochrome:-/etc/shellinabox/options-enabled/01_Monochrome.css" \
  SIAB_PORT=4200 \
  SIAB_ADDUSER=true \
  SIAB_USER=hacker \
  SIAB_USERID=1337 \
  SIAB_GROUP=hacker \
  SIAB_GROUPID=1337 \
  SIAB_PASSWORD=compass \
  SIAB_SHELL=/bin/bash \
  SIAB_HOME=/home/hacker \
  SIAB_SUDO=false \
  SIAB_SSL=true \
  SIAB_SERVICE=/:LOGIN \
  SIAB_PKGS=none \
  SIAB_SCRIPT=none

# ENV SIAB_USERCSS="Normal:+/etc/shellinabox/options-enabled/00+Black-on-White.css,Reverse:-/etc/shellinabox/options-enabled/00_White-On-Black.css;Colors:+/etc/shellinabox/options-enabled/01+Color-Terminal.css,Monochrome:-/etc/shellinabox/options-enabled/01_Monochrome.css"

# Add the files
ADD root /

RUN apk add --update bash openssl curl sudo screen && \
	rm -rf /var/cache/apk/* && \
	adduser -D -H -h /home/shellinabox shellinabox && \
	mkdir /var/lib/shellinabox && \
	chmod +s /bin/su

# Expose the ports for nginx
EXPOSE 80
