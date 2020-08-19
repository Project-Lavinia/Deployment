provider "openstack" {}

# SSH key
resource "openstack_compute_keypair_v2" "keypair" {
  name = "aj-key"
  public_key = file(var.ssh_public_key)
}

# Client servers
resource "openstack_compute_instance_v2" "web_instance" {
  region      = var.region
  count       = lookup(var.role_count, "web", 0)
  name        = "web-${count.index}"
  image_name  = var.image
  flavor_name = lookup(var.role_flavor, "web", "unknown")

  key_pair = "aj-key"
  security_groups = [
    "default",
    "${terraform.workspace}-${var.name}-ssh",
    "${terraform.workspace}-${var.name}-http",
  ]

  network {
    name = var.network
  }

  lifecycle {
    ignore_changes = [image_name]
  }

  depends_on = [
    openstack_networking_secgroup_v2.instance_ssh_access,
    openstack_networking_secgroup_v2.instance_http_access,
  ]

  metadata = {
    ssh_user            = "centos"
    prefer_ipv6         = false
    python_bin          = "/usr/bin/python3"
    my_server_role      = "web"
  }
}

# API servers
resource "openstack_compute_instance_v2" "api_instance" {
  region      = var.region
  count       = lookup(var.role_count, "api", 0)
  name        = "api-${count.index}"
  image_name  = var.image
  flavor_name = lookup(var.role_flavor, "api", "unknown")

  key_pair = "aj-key"
  security_groups = [
    "default",
    "${terraform.workspace}-${var.name}-ssh",
    "${terraform.workspace}-${var.name}-http",
    "${terraform.workspace}-${var.name}-api",
  ]

  network {
    name = var.network
  }

  lifecycle {
    ignore_changes = [image_name]
  }

  depends_on = [
    openstack_networking_secgroup_v2.instance_ssh_access,
    openstack_networking_secgroup_v2.instance_http_access,
    openstack_networking_secgroup_v2.instance_api_access,
  ]

  metadata = {
    ssh_user            = var.ssh_user
    prefer_ipv6         = false
    python_bin          = "/usr/bin/python3"
    my_server_role      = "api"
  }
}

resource "openstack_compute_instance_v2" "jenkins_instance" {
  region	= var.region
  name		= "jenkins"
  image_name	= var.image
  flavor_name	= lookup(var.role_flavor, "jenkins", "unknown")

  key_pair = "aj-key"
  security_groups = [
    "default",
    "${terraform.workspace}-${var.name}-ssh",
    "${terraform.workspace}-${var.name}-http",
  ]

  network {
    name = var.network
  }

  lifecycle {
    ignore_changes = [image_name]
  }

  depends_on = [
    openstack_networking_secgroup_v2.instance_ssh_access,
    openstack_networking_secgroup_v2.instance_http_access,
  ]

  metadata = {
    ssh_user		= var.ssh_user
    prefer_ipv6		= false
    python_bin     = "/usr/bin/python3"
    my_server_role  	= "jenkins"
  }
}

# Load balancer
resource "openstack_compute_instance_v2" "load_balancer_instance" {
  region      = var.region
  name        = "load_balancer"
  image_name  = var.image
  flavor_name = lookup(var.role_flavor, "load_balancer", "unknown")

  key_pair = "aj-key"
  security_groups = [
    "default",
    "${terraform.workspace}-${var.name}-ssh",
    "${terraform.workspace}-${var.name}-http",
  ]

  network {
    name = var.network
  }

  lifecycle {
    ignore_changes = [image_name]
  }

  depends_on = [
    openstack_networking_secgroup_v2.instance_ssh_access,
    openstack_networking_secgroup_v2.instance_http_access,
  ]

  metadata = {
    ssh_user            = "centos"
    prefer_ipv6         = false
    python_bin          = "/usr/bin/python3"
    my_server_role      = "load_balancer"
  }
}

# DNS Zone
resource "openstack_dns_zone_v2" "lavinia_no" {
    name        = "${var.zone_name}."
    email       = "ajsivesind@gmail.com"
    description = "Lavinia root zone"
}

# Volume
resource "openstack_blockstorage_volume_v2" "volume" {
  name = "jenkins"
  size = var.volume_size
}

# Attach volume
resource "openstack_compute_volume_attach_v2" "attach_vol" {
  instance_id = openstack_compute_instance_v2.jenkins_instance.id
  volume_id   = openstack_blockstorage_volume_v2.volume.id
}

# Export Terraform variable values to an Ansible var_file
resource "local_file" "ansible_vars" {
  content = <<-DOC
    # Ansible vars_file containing variable values from Terraform.
    # Generated by Terraform.

    zone_name: ${var.zone_name}

    client_urls:
      %{ for name in openstack_compute_instance_v2.web_instance.*.name ~}
- ${name}.${var.zone_name}
      %{ endfor ~}

    api_urls:
      %{ for name in openstack_compute_instance_v2.api_instance.*.name ~}
- ${name}.${var.zone_name}
      %{ endfor ~}
    DOC
  filename = "./tf_ansible_vars.yaml"
}

# Export list of client URLs
resource "local_file" "client_list" {
  content = <<-DOC
%{ for addr in openstack_compute_instance_v2.web_instance.*.access_ip_v4 ~}
${addr}
%{ endfor ~}
DOC
  filename = "./clients.txt"
}

# Export list of API URLs
resource "local_file" "api_list" {
  content = <<-DOC
%{ for addr in openstack_compute_instance_v2.api_instance.*.access_ip_v4 ~}
${addr}
%{ endfor ~}
DOC
  filename = "./apis.txt"
}