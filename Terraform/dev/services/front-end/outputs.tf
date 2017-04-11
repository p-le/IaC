output "elb_dbs_name" {
  value = "${aws_elb.main.dns_name}"
}
