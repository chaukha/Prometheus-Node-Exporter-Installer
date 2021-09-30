#!bin/bash
#Tat firewall
read -n 1 -r -s -p $'Bam phim bat ki de tat firewall...\n'
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/sysconfig/selinux
sed -i 's/\(^SELINUX=\).*/\SELINUX=disabled/' /etc/selinux/config
setenforce 0
systemctl stop firewalld
systemctl disable firewalld
read -n 1 -r -s -p $'Bam phim bat ki de tao user...\n'
# Tao User
useradd --no-create-home --shell /bin/false node_exporter
read -n 1 -r -s -p $'Bam phim bat ki de cai dat Node_Exporter...\n'
# Install
echo "Cai dat Wget"
sudo yum install -y wget
cd /opt
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz

tar xvf node_exporter-0.18.1.linux-amd64.tar.gz

cp node_exporter-0.18.1.linux-amd64/node_exporter /usr/local/bin
chown node_exporter:node_exporter /usr/local/bin/node_exporter

rm -rf node_exporter-0.18.1.linux-amd64*
cd -
read -n 1 -r -s -p $'Bam phim bat ki de tao Systemd...\n'
#Tao service systemd
cat <<EOF >  /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF
#systemd
systemctl daemon-reload
systemctl start node_exporter
systemctl enable node_exporter
echo "Hoan thanh, truy cap http://localhost:9100/metrics !"