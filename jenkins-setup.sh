# To run this file
# chmod +x jenkins-setup.sh
# then
# ./jenkins-setup.sh

# To run docker within Jenkins, follow these steps
# If you are intented to use other network like jenkins for example then use following line and replace --network minikube in docker run commands
# docker network create jenkins

docker run --name jenkins-docker --rm --detach --privileged --network minikube --network-alias docker --env DOCKER_TLS_CERTDIR=/certs --volume jenkins-docker-certs:/certs/client --volume jenkins-data:/var/jenkins_home --publish 2376:2376 docker:dind

# to create image of jenkins-blueocean, please refere custom.jenkins.dockerfile
# build above docker image with following command
# docker build -f ./custom.jenkins.dockerfile -t jenkins-blueocean .

# have a other jenkins.pipeline.tools.dockerfile with more tools so using that
docker build -f ./jenkins.pipeline.tools.dockerfile -t jenkins-blueocean .

# run above image with following docker run command
docker run --name jenkins-blueocean --restart=on-failure --detach --network minikube --env DOCKER_HOST=tcp://docker:2376 --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 --volume jenkins-data:/var/jenkins_home --volume jenkins-docker-certs:/certs/client:ro --publish 8080:8080 --publish 50000:50000 jenkins-blueocean
