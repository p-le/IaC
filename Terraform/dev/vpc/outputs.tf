output "instance_dns" {
  value = "${aws_instance.backend.public_dns}"
}
output "instance_ip" {
  value = "${aws_instance.backend.public_ip}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "subnet_id" {
  value = "${aws_subnet.public.id}"
}

output "security_group_id" {
  value = "${aws_security_group.api_sg.id}"
}