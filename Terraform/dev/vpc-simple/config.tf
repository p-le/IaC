terraform {
  backend "s3" {
    bucket  = "ple.terraform.state"
    key     = "dev/vpc-simple/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "devops"
  }
}
