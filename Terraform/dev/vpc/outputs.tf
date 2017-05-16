output "instance_dns" {
  value = "${aws_instance.backend.public_dns}"
}
output "instance_ip" {
  value = "${aws_instance.backend.public_ip}"
}

output "instance_dns-2" {
  value = "${aws_instance.backend_2.public_dns}"
}
output "instance_ip-2" {
  value = "${aws_instance.backend_2.public_ip}"
}

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