provider "aws" {
  region  = "ap-northeast-1"
  profile = "devops"
}

resource "aws_security_group" "test" {
  name        = "terraform-test-sg"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  description = "test"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "terraform-test-sg"
  }
}

resource "aws_instance" "test" {
  ami             = "ami-1bfdb67c"
  instance_type   = "t2.micro"
  subnet_id       = "${data.terraform_remote_state.vpc.public_subnet_id}"
  key_name        = "devops"
  user_data       = "${data.template_file.user_data.rendered}"
  security_groups = ["${aws_security_group.test.id}"]

  tags {
    Name = "terraform-test-instance"
  }
}
