#!/bin/bash

cat << 'EOF' > /etc/rc.local
#!/bin/bash
exit 0
EOF

chmod +x /etc/rc.local
# Cria o serviço systemd para compatibilidade com rc.local
cat << 'EOF' > /etc/systemd/system/rc-local.service
[Unit]
Description=/etc/rc.local Compatibility
ConditionPathExists=/etc/rc.local
After=network.target

[Service]
Type=forking
ExecStart=/etc/rc.local
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable rc-local
systemctl start rc-local
# Mostra o status para confirmar que tudo está funcionando
systemctl status rc-local --no-pager
