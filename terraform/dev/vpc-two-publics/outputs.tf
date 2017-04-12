output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "public_subnet_id_1" {
  value = "${aws_subnet.first_public.id}"
}

output "public_subnet_id_2" {
  value = "${aws_subnet.second_public.id}"
}
