# ─────────────────────────────────────────────────────────────
# Root Module — Variables
# ─────────────────────────────────────────────────────────────

variable "tenancy_ocid" {
  description = "OCI Tenancy OCID"
  type        = string
}

variable "user_ocid" {
  description = "OCI User OCID"
  type        = string
}

variable "fingerprint" {
  description = "OCI API Key Fingerprint"
  type        = string
}

variable "private_key_path" {
  description = "Path to OCI API Private Key"
  type        = string
}

variable "region" {
  description = "OCI Region (e.g., us-ashburn-1)"
  type        = string
}

variable "compartment_id" {
  description = "OCI Compartment OCID"
  type        = string
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "tirixai"
}

variable "ssh_public_key" {
  description = "Public SSH key for opc/deploy users"
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to SSH (default everywhere)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "Freeform tags for all resources"
  type        = map(string)
  default = {
    project     = "tirixai"
    environment = "production"
    managed_by  = "terraform"
  }
}
