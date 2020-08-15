# Variables
variable "region" {
  default = "osl"
}

variable "name" {
  default = "lavinia"
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "network" {
  default = "dualStack"
}

variable "volume_size" {
  default = 25
}

variable "zone_name" {
    default = "lavinia.no"
}

# Security group defaults 
variable "allow_ssh_from_v6" {
  type = list(string)
  default = [] 
}

variable "allow_ssh_from_v4" {
  type = list(string)
  default = []
}

variable "allow_http_from_v6" {
  type = list(string)
  default = []
}

variable "allow_http_from_v4" {
  type = list(string)
  default = []
}

variable "allow_https_from_v6" {
  type = list(string)
  default = []
}

variable "allow_https_from_v4" {
  type = list(string)
  default = []
}

variable "allow_api_from_v4" {
  type = list(string)
  default = []
}

variable "allow_api_from_v6" {
  type = list(string)
  default = []
}

variable "image" {
  default = "GOLD CentOS 8"
}

# Mapping between role and flavor
variable "role_flavor" {
  type = map(string)
  default = {
    "web" = "m1.small"
    "api"  = "m1.medium"
    "jenkins" = "m1.medium"
  }
}

# Mapping between role and number of instances (count)
variable "role_count" {
  type = map(string)
  default = {
    "web" = 1
    "api"  = 1
    "jenkins" = 1
  }
}

variable "ssh_user" {
  default = "centos"
}
