#!/usr/bin/env bash
set -euo pipefail

# === Variables ===
ADMIN_USER="${ADMIN_USER:-admin}"
SSH_PORT="${SSH_PORT:-22}"

echo "[00] Common bootstrap: packages, users, folders, hardening"

apt-get update -y
apt-get install -y \
  git curl ufw fail2ban nginx python3 python3-venv

# --- Users (web + exo) ---
id -u web >/dev/null 2>&1 || useradd -m -s /usr/sbin/nologin web
id -u exo >/dev/null 2>&1 || useradd -m -s /usr/sbin/nologin exo

# --- Admin user (optional) ---
if ! id -u "$ADMIN_USER" >/dev/null 2>&1; then
  useradd -m -s /bin/bash "$ADMIN_USER"
  usermod -aG sudo "$ADMIN_USER" || true
  echo "Created admin user: $ADMIN_USER"
  echo "IMPORTANT: add SSH key for $ADMIN_USER in /home/$ADMIN_USER/.ssh/authorized_keys"
fi

# --- Folder layout ---
mkdir -p /opt/platform/{web,exos,scripts} /var/log/platform
chown -R web:web /opt/platform/web
chown -R exo:exo /opt/platform/exos
chmod -R 750 /opt/platform

# --- Basic SSH hardening (safe defaults) ---
# (You can adapt later; doesn't change port automatically.)
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config

systemctl enable --now fail2ban

echo "[00] Done. Next: run zone scripts + firewall."
