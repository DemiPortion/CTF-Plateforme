#!/usr/bin/env bash
set -euo pipefail

DOMAIN="${DOMAIN:-_}"
echo "[01] Zone1 (DMZ logique): Nginx web public"

# Deploy web content
cp -r ./web/* /opt/platform/web/
chown -R web:web /opt/platform/web

# Nginx site
cat > /etc/nginx/sites-available/platform.conf <<'EOF'
server {
    listen 80;
    server_name _;

    root /opt/platform/web;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

rm -f /etc/nginx/sites-enabled/default
ln -sf /etc/nginx/sites-available/platform.conf /etc/nginx/sites-enabled/platform.conf

nginx -t
systemctl enable --now nginx
systemctl reload nginx

echo "[01] Done. Web should be reachable on port 80."
echo "Tip: later you can add HTTPS with certbot (Let's Encrypt) when domain points to VPS."
