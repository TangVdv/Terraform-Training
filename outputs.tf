output "db_password" {
  value = "${random_password.mysql_password.result}"
  sensitive = true
}

output "ipaddr_db" {
  value = [for network in docker_container.db.network_data : network.ip_address]
}

output "ipaddr_nginx" {
  value = flatten([
    for container in docker_container.nginx : [
      for network in container.network_data : "${container.name} : ${network.ip_address}"
    ]
  ])
}