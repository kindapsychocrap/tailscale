# Dockerfile
FROM debian:latest

WORKDIR /render

ARG TAILSCALE_VERSION
ENV TAILSCALE_VERSION=1.82.5

RUN apt-get update -qq \
    && apt-get install -qq -y --no-install-recommends \
       ca-certificates \
       wget \
       dnsutils \
       bash \
       dos2unix \
    && rm -rf /var/lib/apt/lists/*

# Configure DNS lookup
RUN echo "+search +short" > /root/.digrc

# Copy and install Tailscale CLI and daemon
COPY install-tailscale.sh /tmp/install-tailscale.sh
# Ensure Unix line endings to avoid CRLF shebang issues
RUN dos2unix /tmp/install-tailscale.sh \
    && chmod +x /tmp/install-tailscale.sh \
    && /tmp/install-tailscale.sh \
    && rm /tmp/install-tailscale.sh

# Copy startup script and web content
COPY run-tailscale.sh /render/run-tailscale.sh
COPY web /render/web
RUN chmod +x /render/run-tailscale.sh

EXPOSE 8080

CMD ["/render/run-tailscale.sh"]
