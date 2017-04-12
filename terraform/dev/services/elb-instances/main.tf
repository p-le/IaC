provider "aws" {
  region  = "ap-northeast-1"
  profile = "devops"
}

resource "aws_elb" "main" {
  name = "terraform-elb"

  availability_zones = [
    "${data.aws_avilability_zones.availability.names[0]}",
    "${data.aws_avilability_zones.availability.names[1]}",
  ]

  subnets = [
    "${data.terraform_remote_state.vpc.public_subnet_id_1}",
    "${data.terraform_remote_state.vpc.public_subnet_id_2}",
  ]

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  cross_zone_load_balancing   = true
  connection_draining         = true
  connection_draining_timeout = 400
  idle_timeout                = 400

  tags {
    Name = "terraform-elb"
  }
}
