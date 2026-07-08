# ─────────────────────────────────────────────────────────────
# Tirix AI — OCI Compute Module
# ARM Ampere A1.Flex instance with cloud-init provisioning
# ─────────────────────────────────────────────────────────────

# ── Fetch latest Oracle Linux 9 ARM image ───────────────────
data "oci_core_images" "oracle_linux" {
  compartment_id           = var.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "9"
  shape                    = var.vm_shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"

  filter {
    name   = "display_name"
    values = ["^Oracle-Linux-9\\..*-aarch64-.*$"]
    regex  = true
  }
}

# ── Cloud-Init Script ──────────────────────────────────────
data "cloudinit_config" "server" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = templatefile("${path.module}/templates/cloud-init.sh", {
      project_name  = var.project_name
      deploy_user   = var.deploy_user
      ssh_pub_key   = var.ssh_public_key
    })
  }
}

# ── ARM Instance ───────────────────────────────────────────
resource "oci_core_instance" "app_server" {
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  display_name        = "${var.project_name}-app-server"
  shape               = var.vm_shape

  shape_config {
    ocpus         = var.vm_ocpus
    memory_in_gbs = var.vm_memory_gb
  }

  source_details {
    source_type             = "image"
    source_id               = data.oci_core_images.oracle_linux.images[0].id
    boot_volume_size_in_gbs = var.boot_volume_size_gb
  }

  create_vnic_details {
    subnet_id        = var.subnet_id
    display_name     = "${var.project_name}-vnic"
    assign_public_ip = true
    hostname_label   = var.project_name
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
    user_data           = data.cloudinit_config.server.rendered
  }

  freeform_tags = var.tags

  # Prevent accidental destruction
  lifecycle {
    prevent_destroy = false # Set to true in production after first deploy
  }
}
