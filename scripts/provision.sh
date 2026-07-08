#!/bin/bash
# ─────────────────────────────────────────────────────────────
# Provisioning Script
# Run this once on the Oracle VM after SSHing in.
# ─────────────────────────────────────────────────────────────

set -e

echo "==> Configuring Block Volume Mounting"

# Find the 100GB block volume (usually /dev/sdb on OCI)
# You can verify with `lsblk`
BLOCK_DEVICE="/dev/sdb"

if lsblk $BLOCK_DEVICE > /dev/null 2>&1; then
    # Check if already formatted
    FSTYPE=$(blkid -o value -s TYPE $BLOCK_DEVICE || true)
    
    if [ -z "$FSTYPE" ]; then
        echo "Formatting $BLOCK_DEVICE to ext4..."
        sudo mkfs.ext4 $BLOCK_DEVICE
    else
        echo "$BLOCK_DEVICE is already formatted ($FSTYPE)."
    fi

    echo "Mounting $BLOCK_DEVICE to /opt/tirixai..."
    sudo mkdir -p /opt/tirixai
    
    # Add to fstab if not present
    if ! grep -q "$BLOCK_DEVICE" /etc/fstab; then
        echo "$BLOCK_DEVICE /opt/tirixai ext4 defaults,noatime,_netdev 0 2" | sudo tee -a /etc/fstab
    fi

    sudo mount -a
else
    echo "WARNING: Block device $BLOCK_DEVICE not found. Is it attached?"
fi

echo "==> Creating Directory Structure..."
sudo mkdir -p /opt/tirixai/{postgres,redis,qdrant,ollama,grafana,prometheus,loki,uploads,mlflow,nginx/conf.d,letsencrypt}

echo "==> Setting Permissions..."
sudo chown -R 1000:1000 /opt/tirixai/grafana
sudo chown -R 65534:65534 /opt/tirixai/prometheus
sudo chown -R 70:70 /opt/tirixai/postgres
sudo chown -R 999:999 /opt/tirixai/redis

echo "==> Cloning or copying configs..."
# Assuming you cloned Tirix_ai_DevOps repo into /home/deploy/Tirix_ai_DevOps
sudo cp -r /home/deploy/Tirix_ai_DevOps/nginx/* /opt/tirixai/nginx/
sudo cp -r /home/deploy/Tirix_ai_DevOps/monitoring /opt/tirixai/
sudo cp /home/deploy/Tirix_ai_DevOps/docker/docker-compose.prod.yml /opt/tirixai/docker-compose.yml

echo "==> Logging into GHCR..."
echo "Please run: docker login ghcr.io -u YOUR_GITHUB_USER -p YOUR_PAT"

echo "==> Done. Ready to run deploy.sh"
