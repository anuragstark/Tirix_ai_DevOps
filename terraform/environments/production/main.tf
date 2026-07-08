
# Tirix AI — OCI Production Environment Root Module


terraform {
  required_version = ">= 1.5.0"
  
  backend "s3" {
    bucket = "tirixai-terraform-state"
    key    = "production/terraform.tfstate"
    region = "us-east-1"
    # DynamoDB table for state locking
    dynamodb_table = "tirixai-tf-lock" 
  }

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# ── Data Sources ─────────────────────────────────────────────
# Fetch the list of Availability Domains in the region
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# ── Modules ──────────────────────────────────────────────────

module "network" {
  source           = "../../modules/network"
  compartment_id   = var.compartment_id
  project_name     = var.project_name
  vcn_cidr         = "10.0.0.0/16"
  subnet_cidr      = "10.0.1.0/24"
  ssh_allowed_cidr = var.ssh_allowed_cidr
  tags             = var.tags
}

module "compute" {
  source              = "../../modules/compute"
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  subnet_id           = module.network.subnet_id
  project_name        = var.project_name
  vm_shape            = "VM.Standard.A1.Flex"
  vm_ocpus            = 2
  vm_memory_gb        = 12
  boot_volume_size_gb = 50
  ssh_public_key      = var.ssh_public_key
  deploy_user         = "deploy"
  tags                = var.tags
}

module "storage" {
  source              = "../../modules/storage"
  compartment_id      = var.compartment_id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  project_name        = var.project_name
  instance_id         = module.compute.instance_id
  volume_size_gb      = 100
  tags                = var.tags
}
