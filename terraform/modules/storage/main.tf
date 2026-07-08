# ─────────────────────────────────────────────────────────────
# Tirix AI — OCI Storage Module
# Persistent block volume for Databases, Qdrant, and uploads
# ─────────────────────────────────────────────────────────────

# ── Block Volume ────────────────────────────────────────────
resource "oci_core_volume" "data" {
  compartment_id      = var.compartment_id
  availability_domain = var.availability_domain
  display_name        = "${var.project_name}-data-volume"
  size_in_gbs         = var.volume_size_gb
  
  # Higher performance setting (Balanced)
  vpus_per_gb         = 10 

  freeform_tags = var.tags
}

# ── Block Volume Attachment ─────────────────────────────────
resource "oci_core_volume_attachment" "data_attach" {
  attachment_type = "paravirtualized"
  instance_id     = var.instance_id
  volume_id       = oci_core_volume.data.id
  display_name    = "${var.project_name}-data-attach"
  
  # Optional: depends_on might be needed if instance boots slowly
  depends_on      = [var.instance_id]
}
