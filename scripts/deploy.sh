#!/bin/bash

# Deploy Script
# Pulls latest images and restarts containers gracefully

set -e

STACK=$1

if [ -z "$STACK" ]; then
    echo "Usage: $0 [app|devops]"
    exit 1
fi

cd /opt/tirixai

echo "==> Pulling latest images for $STACK..."
docker compose -f docker-compose.${STACK}.yml pull

if [ "$STACK" = "devops" ]; then
    echo "==> Configuring Prometheus & Promtail IPs..."
    # Ensure variables are set
    if [ -n "$APP_PRIVATE_IP" ] && [ -n "$DEVOPS_PRIVATE_IP" ]; then
        sed -i "s/__APP_PRIVATE_IP__/${APP_PRIVATE_IP}/g" /opt/tirixai/monitoring/prometheus/prometheus.yml
        sed -i "s/__DEVOPS_PRIVATE_IP__/${DEVOPS_PRIVATE_IP}/g" /opt/tirixai/monitoring/promtail/promtail-config.yml
    fi
fi

if [ "$STACK" = "app" ]; then
    echo "==> Configuring Promtail IP..."
    if [ -n "$DEVOPS_PRIVATE_IP" ]; then
        sed -i "s/__DEVOPS_PRIVATE_IP__/${DEVOPS_PRIVATE_IP}/g" /opt/tirixai/monitoring/promtail/promtail-config.yml
    fi
fi

echo "==> Restarting containers..."
docker compose -f docker-compose.${STACK}.yml up -d

if [ "$STACK" = "app" ]; then
    echo "==> Running Database Migrations..."
    docker compose -f docker-compose.app.yml exec -T backend alembic upgrade head || echo "No migrations needed or backend not ready."
fi

echo "==> Pruning old images to save disk space..."
docker image prune -af

echo "==> Deployment successful!"
docker compose -f docker-compose.${STACK}.yml ps
