#!/usr/bin/env bash
set -euo pipefail

echo "[02] Zone2 (infra interne logique): internal-only placeholder service"

apt-get install -y socat

# Simple internal service listening ONLY on localhost:9000
cat > /usr/local/bin/internal_service.sh <<'EOF'
#!/usr/bin/env bash
while true; do
  echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nInternal service OK (localhost only)\n" \
    | socat - TCP-LISTEN:9000,bind=127.0.0.1,reuseaddr,fork >/dev/null 2>&1
done
EOF
chmod +x /usr/local/bin/internal_service.sh

cat > /etc/systemd/system/internal.service <<'EOF'
[Unit]
Description=Internal-only Service (Zone2)
After=network.target

[Service]
ExecStart=/usr/local/bin/internal_service.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now internal.service

echo "[02] Done. Test on server: curl http://127.0.0.1:9000"
