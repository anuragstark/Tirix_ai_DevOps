# ─────────────────────────────────────────────────────────────
# Storage Module — Variables
# ─────────────────────────────────────────────────────────────

variable "compartment_id" {
  description = "OCI Compartment OCID"
  type        = string
}

variable "availability_domain" {
  description = "The Availability Domain for the block volume"
  type        = string
}

variable "project_name" {
  description = "Project name prefix for resource naming"
  type        = string
}

variable "instance_id" {
  description = "OCID of the compute instance to attach the volume to"
  type        = string
}

variable "volume_size_gb" {
  description = "Size of the block volume in GB"
  type        = number
  default     = 100
}

variable "tags" {
  description = "Freeform tags for resources"
  type        = map(string)
  default     = {}
}
