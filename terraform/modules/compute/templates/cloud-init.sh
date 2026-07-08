#!/bin/bash

# OCI Cloud-Init Script
# Automatically configures the fresh Oracle Linux 9 ARM instance


set -e
exec > >(tee -a /var/log/cloud-init-output.log | logger -t user-data -s 2>/dev/console) 2>&1

echo "Starting OCI VM provisioning..."

# 1. Update packages
dnf update -y

# 2. Add deploy user for CI/CD
useradd -m -s /bin/bash ${deploy_user} || echo "User ${deploy_user} already exists"
mkdir -p /home/${deploy_user}/.ssh
echo "${ssh_pub_key}" > /home/${deploy_user}/.ssh/authorized_keys
chown -R ${deploy_user}:${deploy_user} /home/${deploy_user}/.ssh
chmod 700 /home/${deploy_user}/.ssh
chmod 600 /home/${deploy_user}/.ssh/authorized_keys
echo "${deploy_user} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${deploy_user}

# 3. Disable strict default firewalld rules (Oracle default)
# We handle security via OCI Security Lists at the VCN level.
systemctl stop firewalld || true
systemctl disable firewalld || true

# 4. Install Docker & Docker Compose
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
systemctl enable --now docker

# Add users to docker group
usermod -aG docker opc
usermod -aG docker ${deploy_user}

# 5. Create Swap Space (Critical for heavy ML workloads in 12GB RAM)
# 8GB swap file
if [ ! -f /swapfile ]; then
    echo "Creating 8GB swap file..."
    fallocate -l 8G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
    
    # Optimize swappiness for servers (prefer RAM, swap when needed)
    sysctl vm.swappiness=10
    echo "vm.swappiness=10" >> /etc/sysctl.d/99-swappiness.conf
fi

echo "Provisioning complete. The block volume mounting will be handled by provision.sh later."
