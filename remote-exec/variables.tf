variable "ami" {}
variable "key_name" {}
variable "ssh_key_file" {}
variable "db_security_group_id" {}
variable "db_subnet_group_name" {}
variable "db_name" {}
variable "db_password" {}
variable "region" {
  default = "ap-northeast-1"
}
