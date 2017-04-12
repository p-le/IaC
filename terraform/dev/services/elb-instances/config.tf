terraform {
  backend "s3" {
    bucket  = "ple.terraform.state"
    key     = "dev/services/elb-instances/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "devops"
  }
}
