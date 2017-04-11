data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "ple.terraform.state"
    key    = "dev/vpc/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

data "aws_availability_zones" "all" {
  state = "available"
}
