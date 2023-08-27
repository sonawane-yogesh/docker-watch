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
        stage('Docker Login') {
            steps {
                script {
                    echo 'hub.docker.com login...'
                    def imageName = 'docker-watch'
                    def imageTag = env.BUILD_NUMBER
                    withCredentials([usernamePassword( credentialsId: 'docker-private-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) 
                    {                        
                        sh "docker login -u ${USERNAME} -p ${PASSWORD}"
                        sh "docker build -t ${imageName}:${imageTag} -f Dockerfile ."
                        sh "docker tag ${imageName}:${imageTag} sonawaneyogeshb/${imageName}:${imageTag}"
                        sh "docker push sonawaneyogeshb/${imageName}:${imageTag}"                     
                    }
                }    
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    echo 'Pushed docker image to hub.docker.com'
                }
            }
        }        
        stage('Kubernetes Deployment') {
            steps {
                script {
                    echo 'Deploying to local Kubernetes...' 
                    sh "kubectl apply -f ./deployment/deployment.yaml"
                }
            }
        }
    }
}