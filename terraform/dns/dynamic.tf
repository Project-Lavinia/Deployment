data "openstack_dns_zone_v2" "lavinia_no" {
    name = "${var.zone_name}."
}

resource "openstack_dns_recordset_v2" "web_a_record" {
    zone_id     = data.openstack_dns_zone_v2.lavinia_no.id
    count       = lookup(var.role_count, "web", 0)
    name        = "${openstack_compute_instance_v2.web_instance[count.index].name}.${var.zone_name}."
    type        = "A"
    records     = [ "${openstack_compute_instance_v2.web_instance[count.index].access_ip_v4}" ]
}

resource "openstack_dns_recordset_v2" "web_aaaa_record" {
    zone_id     = data.openstack_dns_zone_v2.lavinia_no.id
    count       = lookup(var.role_count, "web", 0)
    name        = "${openstack_compute_instance_v2.web_instance[count.index].name}.${var.zone_name}."
    type        = "AAAA"
    records     = [ "${openstack_compute_instance_v2.web_instance[count.index].access_ip_v6}" ]
}

resource "openstack_dns_recordset_v2" "api_a_record" {
    zone_id     = data.openstack_dns_zone_v2.lavinia_no.id
    count       = lookup(var.role_count, "api", 0)
    name        = "${openstack_compute_instance_v2.api_instance[count.index].name}.${var.zone_name}."
    type        = "A"
    records     = [ "${openstack_compute_instance_v2.api_instance[count.index].access_ip_v4}" ]
}

resource "openstack_dns_recordset_v2" "api_aaaa_record" {
    zone_id     = data.openstack_dns_zone_v2.lavinia_no.id
    count       = lookup(var.role_count, "api", 0)
    name        = "${openstack_compute_instance_v2.api_instance[count.index].name}.${var.zone_name}."
    type        = "AAAA"
    records     = [ "${openstack_compute_instance_v2.api_instance[count.index].access_ip_v6}" ]
}

resource "openstack_dns_recordset_v2" "jenkins_a_record" {
    zone_id     = data.openstack_dns_zone_v2.lavinia_no.id
    count       = lookup(var.role_count, "jenkins", 0)
    name        = "${openstack_compute_instance_v2.jenkins_instance[count.index].name}.${var.zone_name}."
    type        = "A"
    records     = [ "${openstack_compute_instance_v2.jenkins_instance[count.index].access_ip_v4}" ]
}

resource "openstack_dns_recordset_v2" "jenkins_aaaa_record" {
    zone_id     = data.openstack_dns_zone_v2.lavinia_no.id
    count       = lookup(var.role_count, "jenkins", 0)
    name        = "${openstack_compute_instance_v2.jenkins_instance[count.index].name}.${var.zone_name}."
    type        = "AAAA"
    records     = [ "${openstack_compute_instance_v2.jenkins_instance[count.index].access_ip_v6}" ]
}