variable "vpc_cidr_block" {
  type    = "string"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr_block_1" {
  type    = "string"
  default = "10.0.0.0/24"
}

variable "public_subnet_cidr_block_2" {
  type    = "string"
  default = "10.0.1.0/24"
}
