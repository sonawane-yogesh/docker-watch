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
        stage('Docker Login and Push') {
            steps {
                script {
                    def imageName = 'docker-watch'
                    def imageTag = env.BUILD_NUMBER
                    /*
                    def dockerLoginCommand = "docker login -u sonawaneyogeshb --password-stdin"
                    withCredentials([usernamePassword(credentialsId: 'docker-private-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh "(echo ${PASSWORD} | ${dockerLoginCommand})"
                    }
                    */
                    
                    withCredentials([usernamePassword(credentialsId: 'docker-private-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh "docker login -u ${USERNAME} -p ${PASSWORD}"                        
                        sh "docker build -t ${imageName}:${imageTag} -f Dockerfile ."
                        sh "docker tag ${imageName}:${imageTag} sonawaneyogeshb/${imageName}:${imageTag}"
                        sh "docker push sonawaneyogeshb/${imageName}:${imageTag}"
                    }
                   
                }
            }
        } 
        stage('Docker Login and Push Other Try') {
            steps {
                script {
                    def imageName = 'docker-watch'
                    def imageTag = env.BUILD_NUMBER
                    withCredentials([usernamePassword(credentialsId: 'docker-private-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        // Use environment variables to pass credentials to the Docker command
                        withEnv(["DOCKER_USERNAME=${USERNAME}", "DOCKER_PASSWORD=${PASSWORD}"]) {
                            // Docker login
                            sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                            // Build and tag the Docker image
                            sh "docker build -t ${imageName}:${imageTag} -f Dockerfile ."
                            sh "docker tag ${imageName}:${imageTag} sonawaneyogeshb/${imageName}:${imageTag}"
                            // Push the Docker image
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