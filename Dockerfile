# Use the Gluetun image as the base
FROM qmcgaw/gluetun:latest

# Define build arguments for User ID (PUID) and Group ID (PGID)
# These are commonly 1000 for the first non-root user
ARG PUID=1000
ARG PGID=1000
ENV PUID=${PUID}
ENV PGID=${PGID}

# 1. Install qBittorrent and utilities
# Gluetun uses Alpine Linux, so we use apk
RUN apk update && \
    apk add --no-cache qbittorrent-nox curl && \
    rm -rf /var/cache/apk/*

# 2. Setup directories and ownership for the EXISTING user
# We assume the user and group 'qbittorrent' already exist in the base image.
RUN mkdir -p /config /downloads && \
    chown -R qbittorrent:qbittorrent /config /downloads

# 3. Expose ports
# 8080 is the default WebUI port
# 6881 is the default torrent data port
EXPOSE 8080 6881/tcp 6881/udp

# 4. Copy the startup script (to be created next)
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 5. Define the command to run after the Gluetun ENTRYPOINT handles the VPN
ENTRYPOINT ["/start.sh"]
