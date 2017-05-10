provider "aws" {
  region  = "ap-northeast-1"
  profile = "devops"
}

resource "aws_instance" "test" {
  ami             = "ami-5de0433c"
  instance_type   = "t2.micro"
  subnet_id       = "${data.terraform_remote_state.vpc.subnet_id}"
  key_name        = "devops"
  user_data       = "${file("userdata.sh")}"
  security_groups = ["${data.terraform_remote_state.vpc.security_group_id}"]
  associate_public_ip_address = true

  tags {
    Name = "terraform-test-instance"
  }
}
