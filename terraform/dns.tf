resource "openstack_dns_recordset_v2" "web_a_record" {
    zone_id     = openstack_dns_zone_v2.lavinia_no.id
    count       = lookup(var.role_count, "web", 0)
    name        = "${openstack_compute_instance_v2.web_instance[count.index].name}.${var.zone_name}."
    type        = "A"
    records     = [ "${openstack_compute_instance_v2.web_instance[count.index].access_ip_v4}" ]
}

resource "openstack_dns_recordset_v2" "web_aaaa_record" {
    zone_id     = openstack_dns_zone_v2.lavinia_no.id
    count       = lookup(var.role_count, "web", 0)
    name        = "${openstack_compute_instance_v2.web_instance[count.index].name}.${var.zone_name}."
    type        = "AAAA"
    records     = [ "${openstack_compute_instance_v2.web_instance[count.index].access_ip_v6}" ]
}

resource "openstack_dns_recordset_v2" "api_a_record" {
    zone_id     = openstack_dns_zone_v2.lavinia_no.id
    count       = lookup(var.role_count, "api", 0)
    name        = "${openstack_compute_instance_v2.api_instance[count.index].name}.${var.zone_name}."
    type        = "A"
    records     = [ "${openstack_compute_instance_v2.api_instance[count.index].access_ip_v4}" ]
}

resource "openstack_dns_recordset_v2" "api_aaaa_record" {
    zone_id     = openstack_dns_zone_v2.lavinia_no.id
    count       = lookup(var.role_count, "api", 0)
    name        = "${openstack_compute_instance_v2.api_instance[count.index].name}.${var.zone_name}."
    type        = "AAAA"
    records     = [ "${openstack_compute_instance_v2.api_instance[count.index].access_ip_v6}" ]
}

resource "openstack_dns_recordset_v2" "jenkins_a_record" {
    zone_id     = openstack_dns_zone_v2.lavinia_no.id
    count       = 1
    name        = "${openstack_compute_instance_v2.jenkins_instance.name}.${var.zone_name}."
    type        = "A"
    records     = [ "${openstack_compute_instance_v2.jenkins_instance.access_ip_v4}" ]
}

resource "openstack_dns_recordset_v2" "jenkins_aaaa_record" {
    zone_id     = openstack_dns_zone_v2.lavinia_no.id
    count       = 1
    name        = "${openstack_compute_instance_v2.jenkins_instance.name}.${var.zone_name}."
    type        = "AAAA"
    records     = [ "${openstack_compute_instance_v2.jenkins_instance.access_ip_v6}" ]
}

resource "openstack_dns_recordset_v2" "lb_web_a_record" {
    zone_id     = openstack_dns_zone_v2.lavinia_no.id
    count       = 1
    name        = "${var.zone_name}."
    type        = "A"
    records     = [ "${openstack_compute_instance_v2.load_balancer_instance.access_ip_v4}" ]
}

resource "openstack_dns_recordset_v2" "lb_web_aaaa_record" {
    zone_id     = openstack_dns_zone_v2.lavinia_no.id
    count       = 1
    name        = "${var.zone_name}."
    type        = "AAAA"
    records     = [ "${openstack_compute_instance_v2.load_balancer_instance.access_ip_v6}" ]
}

resource "openstack_dns_recordset_v2" "lb_www_web_a_record" {
    zone_id     = openstack_dns_zone_v2.lavinia_no.id
    count       = 1
    name        = "www.${var.zone_name}."
    type        = "A"
    records     = [ "${openstack_compute_instance_v2.load_balancer_instance.access_ip_v4}" ]
}

resource "openstack_dns_recordset_v2" "lb_www_web_aaaa_record" {
    zone_id     = openstack_dns_zone_v2.lavinia_no.id
    count       = 1
    name        = "www.${var.zone_name}."
    type        = "AAAA"
    records     = [ "${openstack_compute_instance_v2.load_balancer_instance.access_ip_v6}" ]
}

resource "openstack_dns_recordset_v2" "lb_api_a_record" {
    zone_id     = openstack_dns_zone_v2.lavinia_no.id
    count       = 1
    name        = "api.${var.zone_name}."
    type        = "A"
    records     = [ "${openstack_compute_instance_v2.load_balancer_instance.access_ip_v4}" ]
}

resource "openstack_dns_recordset_v2" "lb_api_aaaa_record" {
    zone_id     = openstack_dns_zone_v2.lavinia_no.id
    count       = 1
    name        = "api.${var.zone_name}."
    type        = "AAAA"
    records     = [ "${openstack_compute_instance_v2.load_balancer_instance.access_ip_v6}" ]
}

resource "openstack_dns_recordset_v2" "lb_cert_a_record" {
    zone_id     = openstack_dns_zone_v2.lavinia_no.id
    count       = 1
    name        = "cert.${var.zone_name}."
    type        = "A"
    records     = [ "${openstack_compute_instance_v2.load_balancer_instance.access_ip_v4}" ]
}

resource "openstack_dns_recordset_v2" "lb_cert_aaaa_record" {
    zone_id     = openstack_dns_zone_v2.lavinia_no.id
    count       = 1
    name        = "cert.${var.zone_name}."
    type        = "AAAA"
    records     = [ "${openstack_compute_instance_v2.load_balancer_instance.access_ip_v6}" ]
}

resource "openstack_dns_recordset_v2" "wiki_cname_record" {
    zone_id     = openstack_dns_zone_v2.lavinia_no.id
    count       = 1
    name        = "wiki.${var.zone_name}."
    type        = "CNAME"
    records     = [ "project-lavinia.github.io." ]
}