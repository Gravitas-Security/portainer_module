terraform {

  # supported version of Terraform CLI (1.x)
  required_version = "~> 1.0"

  required_providers {
    portainer = {
      source  = "portainer/portainer"
      version = ">= 1.5.1"
    }
  }
  cloud {
    organization = "gravitas-security"
    hostname     = "app.terraform.io" # Optional; defaults to app.terraform.io

    workspaces {
      tags = ["Portainer-IaC-Zone", "source:cli"]
    }
  }
}