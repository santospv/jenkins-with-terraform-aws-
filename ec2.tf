data "aws_ami" "ubuntu" {
   most_recent = "true"
   filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
   }
   filter {
      name = "virtualization-type"
      values = ["hvm"]
   }

   owners = ["099720109477"]
}
resource "aws_instance" "jenkins_server" {
   ami = data.aws_ami.ubuntu.id
   subnet_id = aws_subnet.public_subnet.id
   instance_type = "t2.micro"
   vpc_security_group_ids = [aws_security_group.security_group.id]
   key_name               = "santospv"
   associate_public_ip_address = true 
   tags = {
      Name = "jenkins_server"
   }
}
resource "null_resource" "name" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./santospv.pem")
    host        = aws_instance.jenkins_server.public_ip
  }
  provisioner "file" {
    source      = "./install_jenkins.sh"
    destination = "/tmp/install_jenkins.sh"
  }

  provisioner "remote-exec" {
    inline = [
        "sudo chmod +x /tmp/install_jenkins.sh",
        "sh /tmp/install_jenkins.sh",
    ]
  }
  depends_on = [aws_instance.jenkins_server]
}
output "website_url" {
  value     = join ("", ["http://", aws_instance.jenkins_server.public_dns, ":", "8080"])
}