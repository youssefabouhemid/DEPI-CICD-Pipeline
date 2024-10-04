#!/bin/bash

# Update the system and install necessary packages
sudo apt-get update -y
sudo apt-get install -y curl

# Install k3s
curl -sfL https://get.k3s.io | sh -

# Set up permissions on the k3s.yaml configuration file
sudo chmod 644 /etc/rancher/k3s/k3s.yaml

# Set KUBECONFIG environment variable for Helm and kubectl to access k3s cluster
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Add Helm repo for NGINX Ingress Controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install NGINX Ingress Controller via Helm
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --set controller.publishService.enabled=true