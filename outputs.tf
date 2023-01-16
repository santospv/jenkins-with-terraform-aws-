output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}
output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}
output "security_group" {
  value = aws_security_group.security_group.id
}
output "website_url" {
  value     = join ("", ["http://", aws_instance.jenkins_server.public_dns, ":", "8080"])
}