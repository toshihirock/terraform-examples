output "wordpress-endpoint" {
  value = "${aws_instance.web.public_dns}"
}

output "web-ip" {
  value = "${aws_instance.web.public_ip}"
}

output "db-address" {
  value = "${aws_db_instance.default.address}"
}
