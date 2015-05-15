provider "aws" {
  region = "${var.region}"
}

resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
  enable_dns_hostnames = true
  tags {
    Name = "vpc-WordPress"
  }
}

resource "aws_subnet" "public-a" {
  availability_zone = "ap-northeast-1a"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.1.11.0/24"
  map_public_ip_on_launch = true
  tags {
    Name = "WP-PublicSubnet-A"
  }
}

resource "aws_subnet" "private-a" {
  availability_zone = "ap-northeast-1a"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.1.15.0/24"
  tags {
    Name = "WP-PrivateSubnet-A"
  }
}
