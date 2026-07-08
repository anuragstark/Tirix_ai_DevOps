# ─────────────────────────────────────────────────────────────
# Storage Module — Outputs
# ─────────────────────────────────────────────────────────────

output "volume_id" {
  description = "OCID of the block volume"
  value       = oci_core_volume.data.id
}
