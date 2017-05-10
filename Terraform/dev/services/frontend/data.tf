data "terraform_remote_state" "main" {
  backend = "s3"

  config {
    bucket = "ple.terraform.state"
    key    = "stage/vpc/terraform.state"
    region = "ap-northeast-1"
  }
}