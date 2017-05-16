terraform {
  backend "s3" {
    bucket = "ple.terraform.state"
    key = "dev/service/one/terraform.tfstate"
    region = "ap-northeast-1"
    profile = "devops"
  }
}