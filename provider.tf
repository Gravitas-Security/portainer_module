terraform {

  # supported version of Terraform CLI (1.x)
  required_version = "~> 1.0"

  required_providers {
    portainer = {
      source  = "portainer/portainer"
      version = ">= 1.6.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "= 4.45.0"
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