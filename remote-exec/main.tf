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
    "touch test.txt"
    ]
    connection {
      user = "ec2-user"
      key_file = "${var.ssh_key_file}"
    }
  }
}
