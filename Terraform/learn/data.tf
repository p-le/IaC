data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "ple.terraform.state"
    key    = "dev/vpc-simple/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "template_file" "user_data" {
  template = "init.tpl"
}
