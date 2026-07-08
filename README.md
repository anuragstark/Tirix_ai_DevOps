# Tirix AI — DevOps Repository

> [!WARNING]
> **This project is currently under active development.** Things might break, and configurations are subject to change.

**Tirix AI** is an intelligent, AI-powered web application designed to provide automated processing and insights. 

This repository contains all infrastructure as code, deployment scripts, and CI/CD pipelines to run Tirix AI on Oracle Cloud Infrastructure (OCI) Always Free tier.

## Architecture

*   **Cloud Provider:** Oracle Cloud Infrastructure (OCI)
*   **Compute (App Node):** 1x ARM Ampere A1.Flex (2 OCPU, 12GB RAM)
*   **Compute (DevOps Node):** 1x VM.Standard.E2.1.Micro (1 OCPU, 1GB RAM)
*   **Storage:** 100GB Block Volume 
*   **Object Storage:** AWS S3 (for documents)
*   **Container Orchestration:** Docker Compose
*   **Reverse Proxy:** Nginx with Let's Encrypt SSL
*   **CI/CD:** GitHub Actions (building Linux/ARM64 images via QEMU)

## Directory Structure

*   `terraform/` — OCI Infrastructure definition
*   `docker/` — Separate `app` and `devops` Docker Compose stacks
*   `nginx/` — Reverse proxy and SSL routing
*   `monitoring/` — Prometheus, Grafana, Loki, Alertmanager configs
*   `scripts/` — Server provisioning, backup to S3, and deploy scripts
*   `.github/workflows/` — Automated build and deployment pipeline
*   `docs/` — Detailed setup instructions

## Deployment Workflow

This DevOps environment relies on GitHub Actions for Continuous Integration and Continuous Deployment (CI/CD).
*   **Trigger:** The deployment pipeline is triggered externally from pushes to the main private application repository.
*   **Build Process:** The pipeline builds Linux/ARM64 Docker images using QEMU and pushes them to the container registry.
*   **Server Rollout:** The updated containers are then automatically pulled, deployed, and restarted on the OCI production environment.



