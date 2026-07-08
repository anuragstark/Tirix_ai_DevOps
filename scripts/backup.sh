#!/bin/bash
# ─────────────────────────────────────────────────────────────
# Backup Script
# Dumps PostgreSQL and syncs to AWS S3
# Run via Cron (e.g. 0 3 * * * /opt/tirixai/backup.sh)
# ─────────────────────────────────────────────────────────────

set -e

# Load prod env vars
source /opt/tirixai/.env.prod

DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_DIR="/opt/tirixai/backups/tmp"
S3_URI="s3://${AWS_S3_BUCKET_NAME}/database_backups"

mkdir -p $BACKUP_DIR

echo "==> Dumping PostgreSQL..."
docker compose -f /opt/tirixai/docker-compose.yml exec -T postgres pg_dump -U platform platform > $BACKUP_DIR/platform_$DATE.sql
docker compose -f /opt/tirixai/docker-compose.yml exec -T postgres pg_dump -U platform mlflow > $BACKUP_DIR/mlflow_$DATE.sql

echo "==> Compressing..."
gzip $BACKUP_DIR/*.sql

echo "==> Uploading to S3..."
# AWS CLI must be installed on host or run via docker container
docker run --rm \
    -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
    -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
    -v $BACKUP_DIR:/backups \
    amazon/aws-cli s3 sync /backups $S3_URI/

echo "==> Cleaning up local tmp..."
rm -rf $BACKUP_DIR

echo "==> Backup complete!"
