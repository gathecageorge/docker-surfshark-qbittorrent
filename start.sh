#!/bin/sh
set -e

# Start Gluetun VPN service (non-blocking)
/gluetun-entrypoint &

# Wait until VPN is connected
echo "Waiting for VPN to connect..."
while ! ip link show tun0 >/dev/null 2>&1; do
  echo "Waiting for VPN connection to start qBittorrent ......"
  sleep 1
done
echo "VPN is up!"

# Start qBittorrent
echo "Starting qBittorrent..."
exec qbittorrent-nox --webui-port=8080 --profile=/config

