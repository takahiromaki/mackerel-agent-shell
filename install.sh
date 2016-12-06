#!/bin/sh
if [$# -ne 1]; then
  echo "Not found mackerel API Key"
  exit 1
fi
set API_KEY = $1

# download
cd ~
curl -O https://mackerel.io/file/agent/tgz/mackerel-agent-latest.tar.gz
tar xfvz ~/mackerel-agent-latest.tar.gz
mv ~/mackerel-agent /etc/

# write service file
cat <<EOF > /etc/systemd/system/mackerel-agent.service
[Unit]
Description = mackerel-agent

[Service]
ExecStartPre = /etc/mackerel-agent/mackerel-agent init -apikey=$API_KEY
ExecStart = /etc/mackerel-agent/mackerel-agent --conf=/etc/mackerel-agent/mackerel-agent.conf
Type = simple
User = root
Group = root
Restart = always

[Install]
WantedBy=multi-user.target
EOF

# enable auto restart
systemctl enable mackerel-agent.service

# start service
systemctl start mackerel-agent.service

# check service status
echo "[Mackerel service status]"
systemctl status mackerel-agent.service | cat

echo "Complete!"
