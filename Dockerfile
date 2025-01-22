FROM alpine:latest
WORKDIR /vpn

ENV SURFSHARK_USER= \
    SURFSHARK_PASSWORD= \
    SURFSHARK_COUNTRY= \
    SURFSHARK_CITY= \
    SURFSHARK_CONFIGS_ENDPOINT=https://my.surfshark.com/vpn/api/v1/server/configurations \
    OPENVPN_OPTS= \
    CONNECTION_TYPE=tcp \
    LAN_NETWORK= \
    CREATE_TUN_DEVICE= \
    ENABLE_MASQUERADE= \
    ENABLE_SOCKS_SERVER= \
    OVPN_CONFIGS= \
    ENABLE_KILL_SWITCH=true

HEALTHCHECK --interval=60s --timeout=10s --start-period=30s CMD curl -s https://api.surfshark.com/v1/server/user | grep '"secured":true'

COPY startup.sh .
COPY sockd.conf /etc/
COPY sockd.sh .
RUN apk add --update --no-cache \
    qbittorrent-nox \
    openvpn \
    wget \
    unzip \
    coreutils \
    curl \
    ufw \
    dante-server \
  && mkdir -p /config /downloads \
  && chmod +x ./startup.sh \
  && chmod +x ./sockd.sh

EXPOSE 8080

ENTRYPOINT [ "./startup.sh" ]
