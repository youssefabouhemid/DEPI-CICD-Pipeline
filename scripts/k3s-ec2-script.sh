# Install k3s
curl -sfL https://get.k3s.io | sh -

# add kubeconfig for user:
export KUBECONFIG=~/.kube/config
mkdir ~/.kube
sudo k3s kubectl config view --raw > "$KUBECONFIG"
chmod 600 "$KUBECONFIG"

# set kubeconfig env variable on every remote login
echo "export KUBECONFIG=~/.kube/config" >> ~/.bashrc

# set kubectl alias = kube
echo "alias kube=kubectl" >> ~/.bashrc


# download unzip cmd 
sudo apt update
sudo apt install unzip

# download aws cli 
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install


# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Add Helm repo for NGINX Ingress Controller
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install NGINX Ingress Controller via Helm
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --set controller.publishService.enabled=true


