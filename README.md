# docker-surfshark-qbittorrent

## Adapted from [https://github.com/ilteoood/docker-surfshark](https://github.com/ilteoood/docker-surfshark)

Docker container with qBittorrent and OpenVPN client preconfigured for SurfShark

This is a [multi-arch](https://medium.com/gft-engineering/docker-why-multi-arch-images-matters-927397a5be2e) image, updated automatically thanks to [GitHub Actions](https://github.com/features/actions).

Its purpose is to provide a bittorrent client using [SurfShark VPN](https://surfshark.com/). 

The link is established using the [OpenVPN](https://openvpn.net/) client and qbittorrent software.

## Configuration

The container is configurable using different environment variables:

| Name | Mandatory | Description |
|------|-----------|-------------|
|SURFSHARK_USER|Yes|Username provided by SurfShark|
|SURFSHARK_PASSWORD|Yes|Password provided by SurfShark|
|SURFSHARK_COUNTRY|No|The country, supported by SurfShark, in which you want to connect. Should use 2 letter country code in small letters|
|SURFSHARK_CITY|No|The city of the country in which you want to connect. Use 3 letter city code in small letters|
|SURFSHARK_CONFIGS_ENDPOINT|No|The endpoint to be used to donwload Surfshark's configuration zip|
|OPENVPN_OPTS|No|Any additional options for OpenVPN|
|CONNECTION_TYPE|No|The connection type that you want to use: tcp, udp|
|LAN_NETWORK|No|Lan network used to access the web ui of attached containers. Can be comma seperated for multiple subnets Comment out or leave blank: example 192.168.1.0/24|
|CREATE_TUN_DEVICE|No|Creates the TUN device, useful for NAS users|
|ENABLE_MASQUERADE|No|Masquerade NAT allows you to translate multiple IP addresses to another single IP address.|
|ENABLE_SOCKS_SERVER|No|Control whether the SOCKS server for the VPN is run or not (default: do not run)|
|OVPN_CONFIGS|No|Manually provide the path used to read the "Surfshark_Config.zip" file (contains Surshark's OpenVPN configuration files)
|ENABLE_KILL_SWITCH|No|Enable the kill-switch functionality

`SURFSHARK_USER` and `SURFSHARK_PASSWORD` are provided at [this page](https://my.surfshark.com/vpn/manual-setup/main/openvpn).

<p align="center">
    <img src="https://user-images.githubusercontent.com/12913436/180714205-095e891e-4636-43c2-918c-5379f075d993.png" alt="SurfShark credentials"/>
</p>

## Execution

You can run this image using [Docker compose](https://docs.docker.com/compose/) and the [sample file](./docker-compose.yml) provided.  

```yaml
services:
  surfshark:
    image: gathecageorge/docker-surfshark-qbittorrent
    # build: 
    #   context: .
    #   dockerfile: Dockerfile
    environment:
      - SURFSHARK_USER=${SURFSHARK_USER}
      - SURFSHARK_PASSWORD=${SURFSHARK_PASSWORD}
      - SURFSHARK_COUNTRY=${SURFSHARK_COUNTRY:-}
      - SURFSHARK_CITY=${SURFSHARK_CITY:-}
      - CONNECTION_TYPE=${CONNECTION_TYPE:-udp}
      - LAN_NETWORK=${LAN_NETWORK:-}
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun
    ports:
      - 8080:8080
    restart: unless-stopped
    dns:
      - 1.1.1.1
```

Or you can use the standard `docker run` command.

```sh
sudo docker run -it --cap-add=NET_ADMIN --device /dev/net/tun --name CONTAINER_NAME -e SURFSHARK_USER=YOUR_SURFSHARK_USER -e SURFSHARK_PASSWORD=YOUR_SURFSHARK_PASSWORD gathecageorge/docker-surfshark-qbittorrent
```


## Provide OpenVPN Configs Manually

Sometimes the startup script fails to download OpenVPN configs file from Surfshark's website, possibly due to the DDoS protection on it.


To avoid it, you can provide your own `Surfshark_Config.zip` file, downloading it from [here](https://my.surfshark.com/vpn/api/v1/server/configurations).

Then, you **must** make the `zip` available inside the container, using a [bind mount](https://docs.docker.com/storage/bind-mounts/) or a [volume](https://docs.docker.com/storage/volumes/).

Finally, you **must** set the `OVPN_CONFIGS` environment variable.
