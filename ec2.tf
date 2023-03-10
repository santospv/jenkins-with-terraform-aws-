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
   ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 15
    volume_type = "gp2"
    tags = {
      Name = "volume-jenkins_server"
    }
  }
   tags = {
      Name = "jenkins_server"
   }
}
