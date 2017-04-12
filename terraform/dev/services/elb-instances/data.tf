data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "ple.terraform.tfstate"
    key    = "dev/vpc-two-publics/terraform.tfstate"
    region = "ap-northeast-1"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}
