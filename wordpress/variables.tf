variable "region" {
  default = "ap-northeast-1"
}

# rds
variable "db_username" {}
variable "db_password" {}

# ec2
variable "ami" {}
variable "key_name" {}
variable "ssh_key_file" {}
