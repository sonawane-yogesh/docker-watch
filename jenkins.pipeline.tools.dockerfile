# File:
# ./docker-files/jenkins.pipeline.tools.dockerfile

FROM jenkins/jenkins:2.504.1-lts-jdk21

USER root

# =========================================================
# INSTALL BASIC TOOLS
# =========================================================

RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    jq \
    vim \
    nano \
    sudo \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common

# =========================================================
# INSTALL DOCKER CLI
# =========================================================

RUN curl -fsSL https://download.docker.com/linux/debian/gpg \
    | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

RUN echo \
    "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
    https://download.docker.com/linux/debian \
    bookworm stable" \
    > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y docker-ce-cli

# =========================================================
# INSTALL NODEJS
# =========================================================

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash -

RUN apt-get install -y nodejs

# =========================================================
# INSTALL KUBECTL
# =========================================================

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s \
    https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# =========================================================
# INSTALL HELM
# =========================================================

RUN curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 \
    | bash

# =========================================================
# INSTALL AWS CLI
# =========================================================

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
    -o "awscliv2.zip"

RUN unzip awscliv2.zip

RUN ./aws/install

# =========================================================
# INSTALL TERRAFORM
# =========================================================

RUN wget https://releases.hashicorp.com/terraform/1.11.4/terraform_1.11.4_linux_amd64.zip

RUN unzip terraform_1.11.4_linux_amd64.zip

RUN mv terraform /usr/local/bin/

# =========================================================
# CLEANUP
# =========================================================

RUN apt-get clean

# =========================================================
# JENKINS USER
# =========================================================

RUN groupadd docker

RUN usermod -aG docker jenkins

USER jenkins

# =========================================================
# PREINSTALL JENKINS PLUGINS
# =========================================================

RUN jenkins-plugin-cli --plugins \
    blueocean \
    docker-workflow \
    workflow-aggregator \
    git \
    github \
    pipeline-stage-view \
    credentials-binding \
    ssh-agent \
    nodejs \
    kubernetes \
    configuration-as-code \
    job-dsl \
    ws-cleanup \
    timestamper \
    ansicolor \
    pipeline-utility-steps