provider "aws" {
  reguin  = "ap-northeast-1"
  profile = "devops"
}

resource "aws_launch_configuration" "main" {
  name            = "frontend"
  image_id        = "ami-5de0433c"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.instance.id}"]

  user_data = <<-EOF
    #!/bin/bash
  EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "main" {}

resource "aws_security_group" "instance" {
  name = "terraform_instance"

  ingress {
    from_port  = 8080
    to_port    = 8080
    protocol   = "tcp"
    cidr_block = ["0.0.0.0/0"]

    lifecycle {
      create_before_destroy = true
    }
  }
}
