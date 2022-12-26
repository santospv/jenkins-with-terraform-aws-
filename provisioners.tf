resource "null_resource" "jenkins" {
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
        "exit"
    ]
  }
  depends_on = [aws_instance.jenkins_server]
}

resource "null_resource" "docker" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./santospv.pem")
    host        = aws_instance.jenkins_server.public_ip
  }
  provisioner "remote-exec" {
    inline = [
        "curl -fsSL https://get.docker.com | bash",
        "sudo usermod -aG docker jenkins",
        "sudo systemctl restart jenkins",
        "exit"
    ]
  }
  depends_on = [null_resource.jenkins]
}

resource "null_resource" "kubectl" {
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./santospv.pem")
    host        = aws_instance.jenkins_server.public_ip
  }
  provisioner "file" {
    source      = "./install_kubectl.sh"
    destination = "/tmp/install_kubectl.sh"
  }

  provisioner "remote-exec" {
    inline = [
        "sudo chmod +x /tmp/install_kubectl.sh",
        "sh /tmp/install_kubectl.sh",
    ]
  }
  depends_on = [null_resource.docker]
}
