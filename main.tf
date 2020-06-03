provider "openstack" {
}

# SSH key
resource "openstack_compute_keypair_v2" "keypair" {
  name = "AJ-centos"
  public_key = file(var.ssh_public_key)
}

# Client servers
resource "openstack_compute_instance_v2" "web_instance" {
  region      = var.region
  count       = lookup(var.role_count, "web", 0)
  name        = "${var.region}-web-${count.index}"
  image_name  = var.image
  flavor_name = lookup(var.role_flavor, "web", "unknown")

  key_pair = "AJ-centos"
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
    ssh_user            = var.ssh_user
    prefer_ipv6         = true
    my_server_role      = "web"
  }
}

# API servers
resource "openstack_compute_instance_v2" "api_instance" {
  region      = var.region
  count       = lookup(var.role_count, "api", 0)
  name        = "${var.region}-api-${count.index}"
  image_name  = var.image
  flavor_name = lookup(var.role_flavor, "api", "unknown")

  key_pair = "AJ-centos"
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
    prefer_ipv6         = true
    my_server_role      = "api"
  }
}

resource "openstack_compute_instance_v2" "jenkins_instance" {
  region	= var.region
  count		= lookup(var.role_count, "jenkins", 0)
  name		= "${var.region}-jenkins-${count.index}"
  image_name	= var.image
  flavor_name	= lookup(var.role_flavor, "jenkins", "unknown")

  key_pair = "AJ-centos"
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
    prefer_ipv6		= true
    my_server_role  	= "jenkins"
  }
}

# Volume
resource "openstack_blockstorage_volume_v2" "volume" {
  name = "jenkins"
  size = var.volume_size
}

# Attach volume
resource "openstack_compute_volume_attach_v2" "attach_vol" {
  instance_id = openstack_compute_instance_v2.jenkins_instance[0].id
  volume_id   = openstack_blockstorage_volume_v2.volume.id
}
