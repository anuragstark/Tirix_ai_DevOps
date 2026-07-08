
# Compute Module — Variables


variable "compartment_id" {
  description = "OCI Compartment OCID"
  type        = string
}

variable "availability_domain" {
  description = "The Availability Domain to provision the instance in"
  type        = string
}

variable "subnet_id" {
  description = "The OCID of the subnet to attach the instance to"
  type        = string
}

variable "project_name" {
  description = "Project name prefix for resource naming"
  type        = string
}

variable "vm_shape" {
  description = "The shape of the instance"
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "vm_ocpus" {
  description = "Number of OCPUs for the Ampere instance"
  type        = number
  default     = 2
}

variable "vm_memory_gb" {
  description = "Amount of memory in GB for the Ampere instance"
  type        = number
  default     = 12
}

variable "boot_volume_size_gb" {
  description = "Size of the boot volume in GB"
  type        = number
  default     = 50
}

variable "ssh_public_key" {
  description = "Public SSH key for opc user access"
  type        = string
}

variable "deploy_user" {
  description = "Username for the deploy user"
  type        = string
  default     = "deploy"
}

variable "tags" {
  description = "Freeform tags for resources"
  type        = map(string)
  default     = {}
}
