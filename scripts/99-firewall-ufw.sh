#!/usr/bin/env bash
set -euo pipefail

SSH_PORT="${SSH_PORT:-22}"
EXO_PORTS="${EXO_PORTS:-4242:4250}"

echo "[99] Firewall UFW: allow only required ports"

ufw --force reset
ufw default deny incoming
ufw default allow outgoing

# SSH (ideally restrict by IP later)
ufw allow "${SSH_PORT}/tcp"

# Web
ufw allow 80/tcp
ufw allow 443/tcp

# Exos TCP ports range (4242-4250 by default)
ufw allow "${EXO_PORTS}/tcp"

ufw --force enable
ufw status verbose

echo "[99] Done. Only SSH/Web/Exo ports should be open."
