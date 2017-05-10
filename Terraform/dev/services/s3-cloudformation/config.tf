terraform {
  backend "s3" {
    bucket = "ple.terraform.state"
    key = "stage/service/s3-cloudformation/terraform.tfstate"
    region = "ap-northeast-1"
    profile = "devops"
  }
}