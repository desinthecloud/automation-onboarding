output "env_name" {
  value = var.env_name
}

output "app_container_name" {
  value = docker_container.app.name
}

output "db_container_name" {
  value = docker_container.db.name
}

output "network_name" {
  value = docker_network.sandbox_net.name
}
