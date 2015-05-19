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

resource "aws_subnet" "public-c" {
  availability_zone = "ap-northeast-1c"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.1.51.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "WP-PublicSubnet-C"
  }
}

resource "aws_subnet" "private-c" {
  availability_zone = "ap-northeast-1c"
  vpc_id = "${aws_vpc.main.id}"
  cidr_block = "10.1.55.0/24"

  tags {
    Name = "WP-PrivateSubnet-C"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "WP-InternetGateway"
  }
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "vpc-WordPress"
  }
}

resource "aws_main_route_table_association" "a" {
    vpc_id = "${aws_vpc.main.id}"
    route_table_id = "${aws_route_table.r.id}"
}

resource "aws_security_group" "app" {
  name = "WP-Web-DMZ"
  description = "WordPress Web APP Security Group"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "WP-Web-DMZ"
  }
}

resource "aws_security_group" "db" {
  name = "WP-DB"
  description = "WordPress MySQL Security Group"
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "WP-DB"
  }
}
 
resource "aws_security_group_rule" "ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.app.id}"
}

resource "aws_security_group_rule" "web" {
  type = "ingress"
  from_port = 80 
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.app.id}"
}

resource "aws_security_group_rule" "all" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.app.id}"
}

resource "aws_security_group_rule" "db" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.app.id}"

  security_group_id = "${aws_security_group.db.id}"
}

resource "aws_db_subnet_group" "main" {
  name = "wp-dbsubnet"
  description = "WordPress DB Subnet"
  subnet_ids = ["${aws_subnet.private-a.id}", "${aws_subnet.private-c.id}"]
}

resource "aws_db_instance" "default" {
  identifier = "wp-mysql"
  allocated_storage = 5
  engine = "mysql"
  engine_version = "5.6.22"
  instance_class = "db.t2.micro"
  # general purpose SSD
  storage_type = "gp2"
  username = "${var.db_name}"
  password = "${var.db_password}"
  backup_retention_period = 0
  vpc_security_group_ids = ["${aws_security_group.db.id}"]
  db_subnet_group_name = "${aws_db_subnet_group.main.name}"
}

resource "aws_instance" "web" {
  ami = "${var.ami}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.public-a.id}"
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.app.id}"]
  key_name = "${var.key_name}"
  tags {
    Name = "WP-WebAPP"
  }
}
