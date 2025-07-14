# Portainer Stacks Module

This Terraform module dynamically provisions [Portainer Stacks](https://registry.terraform.io/providers/portainer/portainer/latest/docs/resources/stack) based on Docker Compose YAML files located in a specified directory.

## 📦 Overview

This module reads all `*.yml` and `*.yaml` files from a provided `stack_files_path` directory and creates one `portainer_stack` resource per file. Each stack is deployed to the specified Portainer endpoint.

This enables bulk and repeatable deployment of stacks using infrastructure-as-code, and reduces the need to manually configure Portainer.

---

## 🛠 Usage

```hcl
module "portainer_stacks" {
  source           = "./modules/portainer_stacks"
  endpoint_id      = <number>
  stack_files_path = "${path.module}/../stack_files"
}
