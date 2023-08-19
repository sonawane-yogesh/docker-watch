pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "docker-watch"
        DOCKER_HUB_REPO = "sonawaneyogeshb/docker-watch"
        DOCKER_TAG = "${env.BUILD_NUMBER}"  // You can use any versioning strategy here
    }
    stages {
        stage('Run npm install') {
            steps {
                echo 'Running npm install command...'
                // npm install
            }
        }
        stage('Run start command') {
            steps {
                echo 'Starting server application...'
            }
        }
        stage('Checkout') {
            steps {
                echo 'Checkout'
                // checkout scm
            }
        }
        stage('Initialize') {
            steps {
                script {
                    def dockerHome = tool 'Jenkins-docker'
                    env.PATH = "${dockerHome}/bin:${env.PATH}"
                }
            }            
        }
        stage('Docker Login') {
            steps {
                script {
                    echo 'hub.docker.com login...'                    
                    sh "docker login -u sonawaneyogeshb@gmail.com -p NjSoft@123"                        
                }    
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                script {
                    echo 'Building docker image...'
                    def dockerImage = docker.build("${DOCKER_IMAGE_NAME}:${DOCKER_TAG}", ".")                    
                    // Tag the image with latest and push to Docker Hub
                    dockerImage.push()
                    dockerImage.tag("${DOCKER_IMAGE_NAME}:latest")
                    dockerImage.push()                    
                    // Tag the image with the specified version and push to Docker Hub
                    dockerImage.tag("${DOCKER_HUB_REPO}:${DOCKER_TAG}")
                    dockerImage.push()
                }
            }
        }
        /*
        stage('Publish Docker Image') {
            steps {
                script {                
                    echo 'Building docker image...'
                    docker build -t docker-watch:latest -f Dockerfile .
                    echo 'Docker tag creation...'
                    docker tag docker-watch:latest sonawaneyogeshb/docker-watch:latest
                    echo 'Pushing docker image...'
                    docker push sonawaneyogeshb/docker-watch:latest
                }    
            }
        }
        */
        stage('Deploy with Helm') {
            steps {
                script {
                    echo 'Updating helm charts...'                    
                    /* 
                    def helmChartRepo = 'https://sonawane-yogesh.github.io/docker-watch-helm/'
                    def helmChartName = 'docker-watch-helm'
                    def helmReleaseName = 'latest'
                    sh "helm repo add docker-watch-helm ${helmChartRepo}"
                    sh "helm repo update"
                    sh "helm upgrade --install ${helmReleaseName} ${helmChartName} --namespace docker-watch-namespace -f values.yaml" 
                    */
                }
            }
        }
    }
}