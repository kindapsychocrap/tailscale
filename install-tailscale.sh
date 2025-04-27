# install-tailscale.sh
#!/usr/bin/env bash
set -euo pipefail

# Default to specified or latest stable version
TAILSCALE_VERSION=${TAILSCALE_VERSION:-1.82.5}
TS_FILE="tailscale_${TAILSCALE_VERSION}_amd64.tgz"

# Download and unpack
wget -q "https://pkgs.tailscale.com/stable/${TS_FILE}" \
  && tar xzf "${TS_FILE}" --strip-components=1

# Install binaries
cp tailscale tailscaled /render/

# Prepare state directories
mkdir -p /var/run/tailscale /var/cache/tailscale /var/lib/tailscale
