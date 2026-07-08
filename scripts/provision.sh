#!/bin/bash

# Provisioning Script
# Run this once on the Oracle VM after SSHing in.

set -e

STACK=$1

if [ -z "$STACK" ]; then
    echo "Usage: $0 [app|devops]"
    exit 1
fi

if [ "$STACK" = "app" ]; then
    echo "==> Configuring Block Volume Mounting for App Node"
    BLOCK_DEVICE="/dev/sdb"
    if lsblk $BLOCK_DEVICE > /dev/null 2>&1; then
        FSTYPE=$(blkid -o value -s TYPE $BLOCK_DEVICE || true)
        if [ -z "$FSTYPE" ]; then
            echo "Formatting $BLOCK_DEVICE to ext4..."
            sudo mkfs.ext4 $BLOCK_DEVICE
        fi
        echo "Mounting $BLOCK_DEVICE to /opt/tirixai..."
        sudo mkdir -p /opt/tirixai
        if ! grep -q "$BLOCK_DEVICE" /etc/fstab; then
            echo "$BLOCK_DEVICE /opt/tirixai ext4 defaults,noatime,_netdev 0 2" | sudo tee -a /etc/fstab
        fi
        sudo mount -a
    else
        echo "WARNING: Block device $BLOCK_DEVICE not found."
    fi
fi

echo "==> Creating Directory Structure for $STACK..."
if [ "$STACK" = "app" ]; then
    sudo mkdir -p /opt/tirixai/{postgres,redis,qdrant,ollama,uploads,mlflow,nginx/conf.d,letsencrypt,portainer}
    sudo chown -R 70:70 /opt/tirixai/postgres
    sudo chown -R 999:999 /opt/tirixai/redis
else
    sudo mkdir -p /opt/tirixai/{grafana,prometheus,loki,alertmanager,tempo}
    sudo chown -R 1000:1000 /opt/tirixai/grafana
    sudo chown -R 65534:65534 /opt/tirixai/prometheus
fi

echo "==> Copying configs..."
sudo cp -r /home/deploy/Tirix_ai_DevOps/monitoring /opt/tirixai/
if [ "$STACK" = "app" ]; then
    sudo cp -r /home/deploy/Tirix_ai_DevOps/nginx/* /opt/tirixai/nginx/ || true
fi

echo "==> Done. Ready to run deploy.sh"
