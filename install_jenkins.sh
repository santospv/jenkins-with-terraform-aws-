#!/bin/bash
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update && apt-get -y upgrade
sudo apt install -y openjdk-11-sdk
sudo apt install -y openjdk-11-jre-headless
sudo apt install -y openjdk-11-jre
sudo apt-get install -y jenkins
sudo systemctl enable jenkins
sudo systemctl start jenkins