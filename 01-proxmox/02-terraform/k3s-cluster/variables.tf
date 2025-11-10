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

variable "name" { 
  type = string
}

variable "clone_from" {
  type = string
  default = ""
}

variable "clone_id" {
  type = number
  default = -1
}

variable "sshkeys" {
  type = string
  default = ""
}

variable "node_count" { 
  type = number
  default = 1
}

variable "target_node" { 
  type = string 
  default = ""
}

variable "storage" {
  type = string
  default = "local-lvm"
}

variable "cpu_cores" {
  type = number
  default = 2
}

variable "memory" {
  type = number
  default = 4096
}

variable "disk_size" {
  description = "Disk size in GiB"
  type = string
  default = "32G"
}
