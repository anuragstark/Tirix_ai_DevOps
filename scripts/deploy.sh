#!/bin/bash
# ─────────────────────────────────────────────────────────────
# Deploy Script
# Pulls latest images and restarts containers gracefully
# ─────────────────────────────────────────────────────────────

set -e
cd /opt/tirixai

echo "==> Pulling latest images..."
docker compose pull

echo "==> Restarting containers..."
# Recreates containers whose images have changed
docker compose up -d

echo "==> Running Database Migrations..."
docker compose exec -T backend alembic upgrade head

echo "==> Pruning old images to save disk space..."
docker image prune -af

echo "==> Deployment successful!"
docker compose ps
