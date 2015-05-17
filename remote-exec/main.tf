provider "aws" {
  region = "${var.region}"
}

resource "aws_instance" "web" {
  instance_type = "t2.micro"
  ami = "${var.ami}"
  key_name = "${var.key_name}"
  security_groups = ["Web"]
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
    "sudo service httpd status"
    ]
    connection {
      user = "ec2-user"
      key_file = "${var.ssh_key_file}"
    }
  }
}
