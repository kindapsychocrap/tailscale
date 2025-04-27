# run-tailscale.sh
#!/usr/bin/env bash
set -euo pipefail

# Start the daemon in userspace mode (SOCKS5 proxy only for outbound traffic)
/render/tailscaled --tun=userspace-networking --socks5-server=localhost:1055 &
PID=$!

# Bring up Tailscale with your auth key and optional subnet routes
ADVERTISE_ROUTES=${ADVERTISE_ROUTES:-10.0.0.0/8}
until /render/tailscale up \
    --authkey="${TAILSCALE_AUTHKEY}" \
    --hostname="${RENDER_SERVICE_NAME}" \
    --advertise-routes="${ADVERTISE_ROUTES}"; do
  sleep 0.1
done

echo "Tailscale is up"

# Serve static site over Tailscale on port 8080
/render/tailscale serve --http=8080 /render/web
