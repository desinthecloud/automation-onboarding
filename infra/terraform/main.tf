terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "docker" {}

resource "docker_network" "sandbox_net" {
  name = "sandbox-${var.env_name}"
}

resource "docker_container" "db" {
  name  = "db-${var.env_name}"
  image = "postgres:16-alpine"

  env = [
    "POSTGRES_USER=appuser",
    "POSTGRES_PASSWORD=apppassword",
    "POSTGRES_DB=appdb"
  ]

  networks_advanced {
    name = docker_network.sandbox_net.name
  }
}

resource "docker_image" "app_image" {
  name = "sandbox-app:${var.env_name}"

  build {
    context    = "${path.module}/../.."
    dockerfile = "docker/Dockerfile"
  }
}

resource "docker_container" "app" {
  name  = "app-${var.env_name}"
  image = docker_image.app_image.name

  env = [
    "SANDBOX_ENV=${var.env_name}",
    "DB_HOST=db-${var.env_name}",
    "DB_USER=appuser",
    "DB_PASSWORD=apppassword",
    "DB_NAME=appdb",
  ]

  networks_advanced {
    name = docker_network.sandbox_net.name
  }

  ports {
    internal = 8080
    external = 0  # auto-assign host port
  }

  depends_on = [docker_container.db]
}
