output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "subnet_id" {
  value = "${aws_subnet.public.id}"
}

output "subnet_2_id" {
  value = "${aws_subnet.public_2.id}"
}

output "security_group_id" {
  value = "${aws_security_group.api_sg.id}"
}

output "elb_dns" {
  value = "${aws_elb.external.dns_name}"
}