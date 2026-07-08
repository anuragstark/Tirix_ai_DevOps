
# Network Module — Variables


variable "compartment_id" {
  description = "OCI Compartment OCID"
  type        = string
}

variable "project_name" {
  description = "Project name prefix for resource naming"
  type        = string
  default     = "tirixai"
}

variable "vcn_cidr" {
  description = "CIDR block for the VCN"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "dns_label" {
  description = "DNS label for the VCN"
  type        = string
  default     = "tirixai"
}

variable "ssh_allowed_cidr" {
  description = "CIDR block allowed to SSH (restrict to your IP for security)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "tags" {
  description = "Freeform tags for all resources"
  type        = map(string)
  default = {
    project     = "tirixai"
    managed_by  = "terraform"
    environment = "production"
  }
}
