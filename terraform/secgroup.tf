# Security group SSH + ICMP
resource "openstack_networking_secgroup_v2" "instance_ssh_access" {
  region      = var.region
  name        = "${terraform.workspace}-${var.name}-ssh"
  description = "Security group for allowing SSH and ICMP access"
}

# Security group HTTP/S
resource "openstack_networking_secgroup_v2" "instance_http_access" {
  region      = var.region
  name        = "${terraform.workspace}-${var.name}-http"
  description = "Security group for allowing HTTP access"
}

# Security group API
resource "openstack_networking_secgroup_v2" "instance_api_access" {
  region	= var.region
  name		= "${terraform.workspace}-${var.name}-api"
  description	= "Security group for allowing API access"
}

# Allow ssh from IPv4 net
resource "openstack_networking_secgroup_rule_v2" "rule_ssh_access_ipv4" {
  region            = var.region
  count             = length(var.allow_ssh_from_v4)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.allow_ssh_from_v4[count.index]
  security_group_id = openstack_networking_secgroup_v2.instance_ssh_access.id
}

# Allow ssh from IPv6 net
resource "openstack_networking_secgroup_rule_v2" "rule_ssh_access_ipv6" {
  region            = var.region
  count             = length(var.allow_ssh_from_v6)
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = var.allow_ssh_from_v6[count.index]
  security_group_id = openstack_networking_secgroup_v2.instance_ssh_access.id
}

# Allow icmp from IPv4 net
resource "openstack_networking_secgroup_rule_v2" "rule_icmp_access_ipv4" {
  region            = var.region
  count             = length(var.allow_ssh_from_v4)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = var.allow_ssh_from_v4[count.index]
  security_group_id = openstack_networking_secgroup_v2.instance_ssh_access.id
}

# Allow icmp from IPv6 net
resource "openstack_networking_secgroup_rule_v2" "rule_icmp_access_ipv6" {
  region            = var.region
  count             = length(var.allow_ssh_from_v6)
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "icmp"
  remote_ip_prefix  = var.allow_ssh_from_v6[count.index]
  security_group_id = openstack_networking_secgroup_v2.instance_ssh_access.id
}

# Allow HTTP from IPv4 net
resource "openstack_networking_secgroup_rule_v2" "rule_http_access_ipv4" {
  region            = var.region
  count             = length(var.allow_http_from_v4)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = var.allow_http_from_v4[count.index]
  security_group_id = openstack_networking_secgroup_v2.instance_http_access.id
}

# Allow HTTP from IPv6 net
resource "openstack_networking_secgroup_rule_v2" "rule_http_access_ipv6" {
  region            = var.region
  count             = length(var.allow_http_from_v6)
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = var.allow_http_from_v6[count.index]
  security_group_id = openstack_networking_secgroup_v2.instance_http_access.id
}

# Allow HTTPS from IPv4 net
resource "openstack_networking_secgroup_rule_v2" "rule_https_access_ipv4" {
  region            = var.region
  count             = length(var.allow_https_from_v4)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = var.allow_https_from_v4[count.index]
  security_group_id = openstack_networking_secgroup_v2.instance_http_access.id
}

# Allow HTTP from IPv6 net
resource "openstack_networking_secgroup_rule_v2" "rule_https_access_ipv6" {
  region            = var.region
  count             = length(var.allow_https_from_v6)
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = var.allow_https_from_v6[count.index]
  security_group_id = openstack_networking_secgroup_v2.instance_http_access.id
} 

# Allow API from IPv4 net
resource "openstack_networking_secgroup_rule_v2" "rule_api_access_ipv4" {
  region            = var.region
  count             = length(var.allow_api_from_v4)
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = var.allow_api_from_v4[count.index]
  security_group_id = openstack_networking_secgroup_v2.instance_api_access.id
}

# Allow API from IPv6 net
resource "openstack_networking_secgroup_rule_v2" "rule_api_access_ipv6" {
  region            = var.region
  count             = length(var.allow_api_from_v6)
  direction         = "ingress"
  ethertype         = "IPv6"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = var.allow_api_from_v6[count.index]
  security_group_id = openstack_networking_secgroup_v2.instance_api_access.id
}
