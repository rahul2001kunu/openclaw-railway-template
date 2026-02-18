# Build openclaw from source to avoid npm packaging gaps (some dist files are not shipped).
FROM node:22-bookworm AS openclaw-build

# Dependencies needed for openclaw build
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    curl \
    python3 \
    make \
    g++ \
  && rm -rf /var/lib/apt/lists/*

# Install Bun (openclaw build uses it)
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

RUN corepack enable

WORKDIR /openclaw

# OpenClaw version control:
# - Set OPENCLAW_VERSION Railway variable to use a specific tag (e.g., v2026.2.15)
# - If not set, defaults to main branch (original behavior)
# - Can also override locally with --build-arg OPENCLAW_VERSION=<tag>
# - Modified to use rahul2001kunu/openclaw fork
ARG OPENCLAW_VERSION
RUN set -eu; \
  if [ -n "${OPENCLAW_VERSION:-}" ]; then \
    REF="${OPENCLAW_VERSION}"; \
    echo "✓ Using OpenClaw ${REF}"; \
  else \
    REF="main"; \
    echo "⚠ OPENCLAW_VERSION not set, using main branch (may be unstable)"; \
  fi; \
  git clone --depth 1 --branch "${REF}" https://github.com/rahul2001kunu/openclaw.git .

# Patch: relax version requirements for packages that may reference unpublished versions.
# Apply to all extension package.json files to handle workspace protocol (workspace:*).
RUN set -eux; \
  find ./extensions -name 'package.json' -type f | while read -r f; do \
    sed -i -E 's/"openclaw"[[:space:]]*:[[:space:]]*">=[^"]+"/"openclaw": "*"/g' "$f"; \
    sed -i -E 's/"openclaw"[[:space:]]*:[[:space:]]*"workspace:[^"]+"/"openclaw": "*"/g' "$f"; \
  done

RUN pnpm install --no-frozen-lockfile
RUN pnpm build
ENV OPENCLAW_PREFER_PNPM=1
RUN pnpm ui:install && pnpm ui:build


# Runtime image - v2 with Tailscale support (rebuild 2026-02-18)
FROM node:22-bookworm
ENV NODE_ENV=production

RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    build-essential \
    gcc \
    g++ \
    make \
    procps \
    file \
    git \
    python3 \
    pkg-config \
    sudo \
    iptables \
    gnupg \
    lsb-release \
  && rm -rf /var/lib/apt/lists/*

# Install Tailscale
RUN curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null \
  && curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list \
  && apt-get update \
  && apt-get install -y tailscale \
  && rm -rf /var/lib/apt/lists/*

# Create Tailscale state directory
RUN mkdir -p /var/lib/tailscale && chmod 755 /var/lib/tailscale

# Install Homebrew (must run as non-root user)
# Create a user for Homebrew installation, install it, then make it accessible to all users
RUN useradd -m -s /bin/bash linuxbrew \
  && echo 'linuxbrew ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER linuxbrew
RUN NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

USER root
RUN chown -R root:root /home/linuxbrew/.linuxbrew
ENV PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:${PATH}"

WORKDIR /app

# Wrapper deps
RUN corepack enable
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --prod --frozen-lockfile && pnpm store prune

# Copy built openclaw
COPY --from=openclaw-build /openclaw /openclaw

# Provide a openclaw executable
RUN printf '%s\n' '#!/usr/bin/env bash' 'exec node /openclaw/dist/entry.js "$@"' > /usr/local/bin/openclaw \
  && chmod +x /usr/local/bin/openclaw

# Install mcporter globally for MCP tool access
RUN npm install -g mcporter

# Install gogcli for Google Workspace (Gmail, Calendar, Drive)
RUN brew install steipete/tap/gogcli

COPY src ./src
COPY skills /openclaw/skills

ENV PORT=8080
EXPOSE 8080

# Start script that initializes Tailscale then runs OpenClaw
RUN printf '%s\n' \
  '#!/bin/bash' \
  'set -e' \
  '' \
  '# Start Tailscale if auth key is provided' \
  'if [ -n "$TS_AUTHKEY" ]; then' \
  '  echo "Starting Tailscale..."' \
  '  tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &' \
  '  sleep 2' \
  '  tailscale up --authkey="$TS_AUTHKEY" --hostname="${TS_HOSTNAME:-openclaw-gateway}" --accept-routes' \
  '  echo "Tailscale connected: $(tailscale ip -4 2>/dev/null || echo waiting...)"' \
  'fi' \
  '' \
  '# Start OpenClaw wrapper' \
  'exec node src/server.js' \
  > /app/start.sh && chmod +x /app/start.sh

CMD ["/app/start.sh"]
