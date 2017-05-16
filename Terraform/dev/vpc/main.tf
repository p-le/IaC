provider "aws" {
  region = "ap-northeast-1"
  profile = "devops"
}

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"
  enable_dns_hostnames = true

  tags {
    Name = "terraform-api-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "terraform-api-gw"
  }
}

resource "aws_subnet" "public" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.public_subnet_cidr_block}"
  availability_zone = "ap-northeast-1a"

  tags {
    Name = "terraform-api-public-subnet"
  }

  depends_on = ["aws_internet_gateway.gw"]
}


resource "aws_subnet" "public_2" {
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "${var.public_2_subnet_cidr_block}"
  availability_zone = "ap-northeast-1c"

  tags {
    Name = "terraform-api-public-subnet_2"
  }

  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_security_group" "api_sg" {
  name        = "api_sg"
  vpc_id      = "${aws_vpc.main.id}"
  description = "Accept SSH to backend Instance from anyone"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2712
    to_port     = 2712
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = ["aws_subnet.public"]
  tags {
    Name = "terraform-api-sg"
  }
}

resource "aws_security_group" "api_elb_sg" {
  name        = "api_elb_sg"
  vpc_id      = "${aws_vpc.main.id}"
  description = "Accept Connect to ELB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "terraform-api-elb-sg"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "terraform-api-public-rt"
  }
}

resource "aws_route_table" "public_2" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "terraform-api-public-rt-2"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id = "${aws_subnet.public.id}"
  route_table_id ="${aws_route_table.public.id}"
}

resource "aws_route_table_association" "public_2" {
  subnet_id = "${aws_subnet.public_2.id}"
  route_table_id ="${aws_route_table.public_2.id}"
}

resource "aws_iam_role" "s3" {
  name = "s3_role"
  assume_role_policy = "${file("s3role.json")}"
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "s3_policy"
  role = "${aws_iam_role.s3.id}"
  policy = "${file("rolepolicy.json")}"
}
resource "aws_iam_instance_profile" "s3" {
  name = "s3"
  role = "${aws_iam_role.s3.name}"
}

resource "aws_instance" "backend" {
  ami = "ami-5de0433c"
  instance_type = "t2.micro"
  key_name = "devops"
  subnet_id = "${aws_subnet.public.id}"
  user_data       = "${file("userdata.sh")}"
  iam_instance_profile = "${aws_iam_instance_profile.s3.id}"
  vpc_security_group_ids = ["${aws_security_group.api_sg.id}"]
  associate_public_ip_address = true
  
  tags {
    Name = "terraform-api-instance"
  }
}

resource "aws_instance" "backend_2" {
  ami = "ami-5de0433c"
  instance_type = "t2.micro"
  key_name = "devops"
  user_data       = "${file("userdata.sh")}"
  iam_instance_profile = "${aws_iam_instance_profile.s3.id}"
  subnet_id = "${aws_subnet.public_2.id}"
  vpc_security_group_ids = ["${aws_security_group.api_sg.id}"]
  associate_public_ip_address = true
  
  tags {
    Name = "terraform-api-instance_2"
  }
}

resource "aws_vpc_endpoint" "frontend_s3" {
  vpc_id = "${aws_vpc.main.id}"
  service_name = "com.amazonaws.ap-northeast-1.s3"
}

resource "aws_vpc_endpoint_route_table_association" "frontend-s3" {
  vpc_endpoint_id = "${aws_vpc_endpoint.frontend_s3.id}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_vpc_endpoint_route_table_association" "frontend-s3-2" {
  vpc_endpoint_id = "${aws_vpc_endpoint.frontend_s3.id}"
  route_table_id = "${aws_route_table.public_2.id}"
}

resource "aws_elb" "external" {
  name = "terraform-api-elb"

  listener {
    instance_port = 2712
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:2712/health"
    interval = 30
  }

  security_groups = ["${aws_security_group.api_elb_sg.id}"]
  instances = ["${aws_instance.backend.id}", "${aws_instance.backend_2.id}"]
  subnets = ["${aws_subnet.public.id}", "${aws_subnet.public_2.id}"]

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "terraform-api-elb"
  }

  depends_on = ["aws_subnet.public", "aws_subnet.public_2"]
}