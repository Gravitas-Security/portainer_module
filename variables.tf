variable "stack_files_path" {
  description = "Path to the directory containing Portainer stack YAML files"
  type        = string
}

variable "gh_uname" {
  type      = string
  sensitive = true
}

variable "gh_pword" {
  type      = string
  sensitive = true
}

variable "portainer_uname" {
  type      = string
  sensitive = true
}

variable "portainer_pword" {
  type      = string
  sensitive = true
}

variable "portainer_endpoint" {
  type      = string
  sensitive = true
}

variable "group" {
  type = list(object({
    name = string
    include = object({
      login_method = list(string)
    })
  }))
  default = []
}

variable "cf_domain" {
  type    = string
  default = "domain"
}

variable "cf_account_name" {
  type = string
}