#!/bin/bash

# Add Docker's official GPG key
apt-get update
apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

# Install Docker
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# create Jenkins docker network
docker network create jenkins


# Touch Jenkins Dockerfile
cat <<EOL > Dockerfile
FROM jenkins/jenkins:2.462.2-jdk17
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc https://download.docker.com/linux/debian/gpg
RUN sh -c 'echo "deb [arch=\$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] https://download.docker.com/linux/debian \$(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list'
RUN apt-get update && apt-get install -y docker-ce-cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \\
    && unzip awscliv2.zip \\
    && ./aws/install \\
    && rm -rf awscliv2.zip aws
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"
EOL


# Build the Jenkins Docker image
docker build -t myjenkins-blueocean:2.462.3-1 .


# Run dind docker container
docker run --name jenkins-docker --rm --detach \
  --privileged --network jenkins --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-data:/var/jenkins_home \
  --publish 2376:2376 \
  docker:dind --storage-driver overlay2


# Run Jenkins Docker container
docker run \
  --name jenkins-blueocean \
  --restart=on-failure \
  --detach \
  --network jenkins \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  myjenkins-blueocean:2.462.3-1











######################################################## install jenkins manually 

# # Install java 17
# apt-get install -y openjdk-17-jdk openjdk-17-jre

# # Install Jenkins custom image (you can specify the image command here if needed)
# wget -O /usr/share/keyrings/jenkins-keyring.asc \
#   https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
# echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
#   https://pkg.jenkins.io/debian-stable binary/ | tee \
#   /etc/apt/sources.list.d/jenkins.list > /dev/null
# apt-get update
# apt-get install -y jenkins

# # Start Jenkins
# # systemctl enable jenkins
# systemctl start jenkins







# notes:
# need access to port 8080 from security group
# and http and ssh access 