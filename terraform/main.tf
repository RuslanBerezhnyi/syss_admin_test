resource "docker_network" "sysadmin-net" {
  name = "sysadmin-net"
}

resource "docker_volume" "web-data" {
  name = "web-data"
}

resource "docker_container" "php" {
  name  = "sysadmin-infra_php"
  image = "php:8.2-fpm"
  networks_advanced {
    name = docker_network.sysadmin-net.name
  }
  volumes {
    volume_name    = docker_volume.web-data.name
    container_path = "/var/www/html"
  }
}

resource "docker_container" "nginx" {
  name  = "sysadmin-infra_nginx"
  image = "nginx:latest"
  networks_advanced {
    name = docker_network.sysadmin-net.name
  }
  ports {
    internal = 80
    external = var.host_port
  }
  volumes {
    volume_name    = docker_volume.web-data.name
    container_path = "/var/www/html"
  }
  depends_on = [docker_container.php]
}
