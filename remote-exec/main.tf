provider "aws" {
  region = "${var.region}"
}

resource "aws_db_instance" "default" {
  identifier = "wp-mysql"
  allocated_storage = 5
  engine = "mysql"
  engine_version = "5.6.22"
  instance_class = "db.t2.micro"
  # general purpose SSD
  storage_type = "gp2"
  username = "${var.db_username}"
  password = "${var.db_password}"
  backup_retention_period = 0
  vpc_security_group_ids = ["${var.db_security_group_id}"]
  db_subnet_group_name = "${var.db_subnet_group_name}"
}

resource "aws_instance" "web" {
  instance_type = "t2.micro"
  ami = "${var.ami}"
  key_name = "${var.key_name}"
  security_groups = ["Web"]

  provisioner "file" {
    source = "prepareWordPress.sql"
    destination = "/home/ec2-user/prepareWordPress.sql"
    connection {
      user = "ec2-user"
      key_file = "${var.ssh_key_file}"
    }
  }

  provisioner "remote-exec" {
    inline = [
    "sudo yum install php php-mysql php-gd php-mbstring -y",
    "sudo yum install mysql -y",
    "wget -O /tmp/wordpress-4.1-ja.tar.gz https://ja.wordpress.org/wordpress-4.1-ja.tar.gz",
    "sudo tar zxf /tmp/wordpress-4.1-ja.tar.gz -C /opt",
    "sudo ln -s /opt/wordpress /var/www/html/",
    "sudo chown -R apache:apache /opt/wordpress",
    "sudo chkconfig httpd on",
    "sudo killall -9 httpd",
    "sudo rm -f /var/lock/subsys/httpd",
    "sudo service httpd start",
    "sudo service httpd status",
    "mysql -u root -p${var.db_password} -h ${aws_db_instance.default.address} < /home/ec2-user/prepareWordPress.sql"
    ]
    connection {
      user = "ec2-user"
      key_file = "${var.ssh_key_file}"
    }
  }
}
