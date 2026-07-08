
# Root Module — Outputs


output "public_ip" {
  description = "Public IP of the application server"
  value       = module.compute.public_ip
}

output "ssh_command" {
  description = "SSH command to connect to the server"
  value       = "ssh opc@${module.compute.public_ip}"
}

output "deploy_ssh_command" {
  description = "SSH command to connect as deploy user"
  value       = "ssh deploy@${module.compute.public_ip}"
}

output "devops_public_ip" {
  description = "Public IP of the DevOps server"
  value       = module.devops_vm.public_ip
}

output "devops_private_ip" {
  description = "Private IP of the DevOps server"
  value       = module.devops_vm.private_ip
}

output "app_private_ip" {
  description = "Private IP of the App server"
  value       = module.compute.private_ip
}
