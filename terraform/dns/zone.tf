provider "openstack" {
}

resource "openstack_dns_zone_v2" "lavinia_no" {
    name        = "${var.zone_name}."
    email       = "ajsivesind@gmail.com"
    description = "Lavinia root zone"
}