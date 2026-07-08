#!/bin/bash

# SSL Setup Script
# Generates Let's Encrypt certificates using Certbot webroot


DOMAIN="tirixai.com"
EMAIL="admin@tirixai.com"

# Ensure Nginx is running (even with default config) so the webroot challenge can be served
docker compose -f /opt/tirixai/docker-compose.yml up -d nginx

# Generate Certs
sudo certbot certonly --webroot -w /opt/tirixai/nginx/certbot -d $DOMAIN -d www.$DOMAIN --email $EMAIL --agree-tos --no-eff-email

# The certs will be generated in /etc/letsencrypt/live/$DOMAIN/
# Nginx docker container mounts /etc/letsencrypt directly so it will see them

echo "==> Reloading Nginx to pick up new certificates..."
docker compose -f /opt/tirixai/docker-compose.yml exec nginx nginx -s reload

echo "==> Setting up cron for auto-renewal..."
(crontab -l 2>/dev/null; echo "0 0 1 * * certbot renew --post-hook 'docker compose -f /opt/tirixai/docker-compose.yml exec nginx nginx -s reload'") | crontab -

echo "==> SSL Setup Complete."
