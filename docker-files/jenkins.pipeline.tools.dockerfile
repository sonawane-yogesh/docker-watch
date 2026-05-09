FROM jenkins/jenkins:lts
USER root
# Install necessary dependencies
RUN apt-get update && apt-get install -y lsb-release curl wget gnupg sudo python3 python3-pip
# Install Docker CLI
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc https://download.docker.com/linux/debian/gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && apt-get update && apt-get install -y docker-ce-cli
# Install Helm CLI
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && chmod +x get_helm.sh && ./get_helm.sh
# Install Minikube
RUN curl -fsSL -o /usr/local/bin/minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x /usr/local/bin/minikube
# Install ArgoCD CLI
RUN curl -fsSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 && chmod +x /usr/local/bin/argocd

USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow"