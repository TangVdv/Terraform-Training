//IMAGES
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

resource "docker_image" "mysql" {
  name = "mysql:latest"
}

//VOLUMES
resource "docker_volume" "tfapi_volume" {
  name = "tfapi_volume"
}
resource "docker_volume" "tfshow_volume" {
  name = "tfshow_volume"
}


//PASSWORD
resource "random_password" "mysql_root_password" {
  length = 16
  special = true
}
resource "random_password" "mysql_password" {
  length = 16
  special = true
}

//CONTAINERS
resource "docker_container" "db" {
  name  = "db"
  hostname = "tfdb"
  image = docker_image.mysql.image_id
  restart = "always"
  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.mysql_root_password.result}",
    "MYSQL_PASSWORD=${random_password.mysql_password.result}",
    "MYSQL_USER=user",
    "MYSQL_DATABASE=tfshow"
  ]
}

resource "docker_container" "nginx" {
    for_each = { for container in local.ngix-container : container.name => container }
    name = each.value.name
    image = docker_image.nginx.image_id
    hostname = each.value.hostname
    restart = each.value.restart
    ports {
      internal = 80
      external = each.value.external_port
    }
    env = each.value.env
    volumes {
        volume_name = each.value.volume_name
        container_path = each.value.volume_path
    }
    provisioner "local-exec" {
        command = "echo '${each.value.name} created !'"
    }
}