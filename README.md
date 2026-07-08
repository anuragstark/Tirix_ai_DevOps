# Tirix AI — DevOps Repository

This repository contains all infrastructure as code, deployment scripts, and CI/CD pipelines to run Tirix AI on Oracle Cloud Infrastructure (OCI) Always Free tier.

## Architecture

*   **Cloud Provider:** Oracle Cloud Infrastructure (OCI)
*   **Compute:** 1x ARM Ampere A1.Flex (2 OCPU, 12GB RAM)
*   **Storage:** 100GB Block Volume 
*   **Object Storage:** AWS S3 (for documents)
*   **Container Orchestration:** Docker Compose
*   **Reverse Proxy:** Nginx with Let's Encrypt SSL
*   **CI/CD:** GitHub Actions (building Linux/ARM64 images via QEMU)

## Directory Structure

*   `terraform/` — OCI Infrastructure definition
*   `docker/` — Production Docker Compose and ENV templates
*   `nginx/` — Reverse proxy and SSL routing
*   `monitoring/` — Prometheus, Grafana, Loki, Alertmanager configs
*   `scripts/` — Server provisioning, backup to S3, and deploy scripts
*   `.github/workflows/` — Automated build and deployment pipeline
*   `docs/` — Detailed setup instructions



