provider "aws" {
  region  = "ap-northeast-1"
  profile = "devops"
}

resource "aws_vpc" "main" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true

  tags {
    Name = "terraform-two-publics-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "terraform-two-publics-gw"
  }
}

resource "aws_subnet" "first_public" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_subnet_cidr_block_1}"
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-two-publics-subnet-1"
  }

  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_subnet" "second_public" {
  vpc_id                  = "${aws_vpc.main.id}"
  cidr_block              = "${var.public_subnet_cidr_block_2}"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
  map_public_ip_on_launch = true

  tags = {
    Name = "terraform-two-publics-subnet-2"
  }

  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_route_table" "first_public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "terraform-first-public-rt"
  }
}

resource "aws_route_table" "second_public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "terraform-second-public-rt"
  }
}

resource "aws_route_table_association" "first_public" {
  subnet_id      = "${aws_subnet.first_public.id}"
  route_table_id = "${aws_route_table.first_public.id}"
}

resource "aws_route_table_association" "second_public" {
  subnet_id      = "${aws_subnet.second_public.id}"
  route_table_id = "${aws_route_table.second_public.id}"
}
