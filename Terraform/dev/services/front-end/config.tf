terraform {
  backend "s3" {
    bucket  = "ple.terraform.state"
    key     = "dev/services/front-end/terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "devops"
  }
}
