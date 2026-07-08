# ─────────────────────────────────────────────────────────────
# Compute Module — Outputs
# ─────────────────────────────────────────────────────────────

output "instance_id" {
  description = "OCID of the compute instance"
  value       = oci_core_instance.app_server.id
}

output "public_ip" {
  description = "Public IP address of the instance"
  value       = oci_core_instance.app_server.public_ip
}

output "private_ip" {
  description = "Private IP address of the instance"
  value       = oci_core_instance.app_server.private_ip
}
