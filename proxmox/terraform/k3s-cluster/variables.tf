variable "pm_api_url" {
  type = string
}

variable "pm_user" { type = string }

variable "pm_tls_insecure" {
  type    = bool
  default = true
}

variable "pm_password" {
  type = string
  sensitive = true
}

variable "name" { type = string }

variable "clone_from" {
  type = string
  default = ""
}

variable "sshkeys" {
  type = string
  default = ""
}

variable "node_count" { 
  type = number
  default = 1
}

variable "iso" {
  type = string
  default = ""
}

variable "target_node" { 
  type = string 
  default = ""
}

variable "storage" {
  type = string
  default = "local-lvm"
}