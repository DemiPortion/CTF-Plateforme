#!/usr/bin/env bash
set -euo pipefail

echo "[03] Zone3 (challenges): deploy exos + systemd template"

# Deploy exo scripts
cp -r ./exos/* /opt/platform/exos/
chown -R exo:exo /opt/platform/exos
chmod -R 750 /opt/platform/exos

# systemd template (1 exo = 1 service)
cat > /etc/systemd/system/exo@.service <<'EOF'
[Unit]
Description=CTF Exercise %i (Zone3)
After=network.target

[Service]
User=exo
WorkingDirectory=/opt/platform/exos
ExecStart=/usr/bin/python3 /opt/platform/exos/%i.py
Restart=always
RestartSec=1

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload

# Enable 2 sample exos if present
for ex in exo1 exo2; do
  if [[ -f "/opt/platform/exos/${ex}.py" ]]; then
    systemctl enable --now "exo@${ex}"
    echo "Enabled: exo@${ex}"
  fi
done

echo "[03] Done. Exos should listen on their ports."
