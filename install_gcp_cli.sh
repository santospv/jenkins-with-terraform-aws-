#!/bin/bash
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-cli
sudo apt-get install google-cloud-sdk-gke-gcloud-auth-plugin
gcloud auth activate-service-account --key-file=/tmp/instserviceaccount.json
gcloud components install kubectl
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
gcloud container clusters get-credentials pvs-devops-iac-gke --zone us-south1-c --project pvs-devops-iac
sudo cat /var/lib/jenkins/secrets/initialAdminPassword