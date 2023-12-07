pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "docker-watch"
        DOCKER_HUB_REPO = "sonawaneyogeshb/docker-watch"
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        CUSTOM_PATH = "/usr/bin:${env.PATH}"  
        DOCKET_HOST = "unix:///var/run/docker.sock"
    }    
    stages {
        stage('Run npm install') {
            steps {
                echo 'Running npm install command...'
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
            }
        }
        /*
        * working stage, but need to use -p password inline parameter like following stage...
        stage('Docker Login and Push') {
            steps {
                script {
                    def imageName = 'docker-watch'
                    def imageTag = env.BUILD_NUMBER                    
                    withCredentials([usernamePassword(credentialsId: 'docker-private-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh "docker login -u ${USERNAME} --password-stdin"                        
                        sh "docker build -t ${imageName}:${imageTag} -f Dockerfile ."
                        sh "docker tag ${imageName}:${imageTag} sonawaneyogeshb/${imageName}:${imageTag}"
                        sh "docker push sonawaneyogeshb/${imageName}:${imageTag}"
                    }                   
                }
            }
        }
        */ 
        stage('Docker Login and Push Other Try') {
            steps {
                script {
                    def imageName = 'docker-watch'
                    def imageTag = 'latest'; // env.BUILD_NUMBER 
                    withCredentials([usernamePassword(credentialsId: 'docker-private-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        withEnv(["DOCKER_USERNAME=${USERNAME}", "DOCKER_PASSWORD=${PASSWORD}"]) {
                            sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                            sh "docker build -t ${imageName}:${imageTag} -f Dockerfile ."
                            sh "docker tag ${imageName}:${imageTag} sonawaneyogeshb/${imageName}:${imageTag}"
                            sh "docker push sonawaneyogeshb/${imageName}:${imageTag}"
                        }
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