#!/bin/bash
sudo apt-get update
sudo apt-get install -y curl apt-transport-https ca-certificates gnupg ufw
sudo ufw disable

#Install kubectl through google-cli
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get update
sudo apt-get install -y google-cloud-cli
sudo apt-get update
sudo apt-get install -y kubectl

#Install k3s in server mode
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server --token 12345 --node-ip=192.168.56.110 --flannel-iface=eth1" sh -s

sleep 15

#Setup config for kubectl
sudo chmod 644 /etc/rancher/k3s/k3s.yaml
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> /home/vagrant/.bashrc
echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> /home/vagrant/.profile

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.3/deploy/static/provider/cloud/deploy.yaml
