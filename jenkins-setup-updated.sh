#!/bin/bash

# =========================================================
# Jenkins + Docker-in-Docker Complete Setup
# =========================================================
#
# This setup:
# 1. Creates dedicated Docker network
# 2. Runs Docker-in-Docker daemon
# 3. Builds custom Jenkins image
# 4. Runs Jenkins container
#
# =========================================================
# USAGE
# =========================================================
#
# chmod +x jenkins-setup.sh
# ./jenkins-setup.sh
#
# =========================================================
# ACCESS JENKINS
# =========================================================
#
# http://YOUR_SERVER_IP:9000
#
# Example:
# http://192.168.1.50:9000
#
# =========================================================
# GET INITIAL ADMIN PASSWORD
# =========================================================
#
# docker exec jenkins \
#   cat /var/jenkins_home/secrets/initialAdminPassword
#
# =========================================================

set -e

echo "=================================================="
echo "Starting Jenkins + Docker setup..."
echo "=================================================="

# =========================================================
# CONFIGURATION
# =========================================================

NETWORK_NAME="jenkins"

JENKINS_CONTAINER_NAME="jenkins"

DOCKER_CONTAINER_NAME="jenkins-docker"

JENKINS_IMAGE_NAME="jenkins-blueocean"

JENKINS_IMAGE_TAG="latest"

JENKINS_PORT="9000"

JENKINS_AGENT_PORT="50000"

DOCKER_DAEMON_PORT="2376"

# =========================================================
# CREATE NETWORK
# =========================================================

echo ""
echo "=================================================="
echo "Creating Docker network..."
echo "=================================================="

if docker network inspect ${NETWORK_NAME} >/dev/null 2>&1; then
    echo "Docker network already exists: ${NETWORK_NAME}"
else
    docker network create ${NETWORK_NAME}
    echo "Docker network created: ${NETWORK_NAME}"
fi

# =========================================================
# REMOVE OLD CONTAINERS IF EXIST
# =========================================================

echo ""
echo "=================================================="
echo "Removing old containers if they exist..."
echo "=================================================="

if docker ps -a --format '{{.Names}}' | grep -Eq "^${DOCKER_CONTAINER_NAME}\$"; then
    docker rm -f ${DOCKER_CONTAINER_NAME}
fi

if docker ps -a --format '{{.Names}}' | grep -Eq "^${JENKINS_CONTAINER_NAME}\$"; then
    docker rm -f ${JENKINS_CONTAINER_NAME}
fi

# =========================================================
# CREATE VOLUMES
# =========================================================

echo ""
echo "=================================================="
echo "Creating Docker volumes..."
echo "=================================================="

docker volume create jenkins-data >/dev/null
docker volume create jenkins-docker-certs >/dev/null
docker volume create jenkins-docker-data >/dev/null

echo "Volumes ready."

# =========================================================
# START DOCKER-IN-DOCKER
# =========================================================

echo ""
echo "=================================================="
echo "Starting Docker-in-Docker container..."
echo "=================================================="

docker run \
  --name ${DOCKER_CONTAINER_NAME} \
  --restart unless-stopped \
  --detach \
  --privileged \
  --network ${NETWORK_NAME} \
  --network-alias docker \
  --env DOCKER_TLS_CERTDIR=/certs \
  --volume jenkins-docker-certs:/certs/client \
  --volume jenkins-docker-data:/var/lib/docker \
  --publish ${DOCKER_DAEMON_PORT}:2376 \
  docker:dind

echo "Docker-in-Docker container started."

# =========================================================
# WAIT FOR DOCKER DAEMON
# =========================================================

echo ""
echo "=================================================="
echo "Waiting for Docker daemon to initialize..."
echo "=================================================="

sleep 15

# =========================================================
# BUILD CUSTOM JENKINS IMAGE
# =========================================================

echo ""
echo "=================================================="
echo "Building custom Jenkins image..."
echo "=================================================="

# Change path if needed
docker build \
  -f ./jenkins.pipeline.tools.dockerfile \
  -t ${JENKINS_IMAGE_NAME}:${JENKINS_IMAGE_TAG} \
  .

echo "Custom Jenkins image built successfully."

# =========================================================
# START JENKINS CONTAINER
# =========================================================

echo ""
echo "=================================================="
echo "Starting Jenkins container..."
echo "=================================================="

docker run \
  --name ${JENKINS_CONTAINER_NAME} \
  --restart unless-stopped \
  --detach \
  --network ${NETWORK_NAME} \
  --env DOCKER_HOST=tcp://docker:2376 \
  --env DOCKER_CERT_PATH=/certs/client \
  --env DOCKER_TLS_VERIFY=1 \
  --volume jenkins-data:/var/jenkins_home \
  --volume jenkins-docker-certs:/certs/client:ro \
  --publish ${JENKINS_PORT}:8080 \
  --publish ${JENKINS_AGENT_PORT}:50000 \
  ${JENKINS_IMAGE_NAME}:${JENKINS_IMAGE_TAG}

echo "Jenkins container started."

# =========================================================
# SHOW STATUS
# =========================================================

echo ""
echo "=================================================="
echo "Running Containers"
echo "=================================================="

docker ps

# =========================================================
# SHOW ACCESS INFO
# =========================================================

SERVER_IP=$(hostname -I | awk '{print $1}')

echo ""
echo "=================================================="
echo "Jenkins Setup Completed Successfully"
echo "=================================================="

echo ""
echo "Access Jenkins at:"
echo ""

echo "http://${SERVER_IP}:${JENKINS_PORT}"

echo ""
echo "To get initial admin password:"
echo ""

echo "docker exec ${JENKINS_CONTAINER_NAME} \\"
echo "  cat /var/jenkins_home/secrets/initialAdminPassword"

echo ""
echo "=================================================="
echo "Done."
echo "=================================================="