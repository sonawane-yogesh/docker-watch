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
        stage('Docker Login and Push') {
            steps {
                script {
                    def imageName = 'docker-watch'
                    def imageTag = env.BUILD_NUMBER
                    withCredentials([usernamePassword(credentialsId: 'docker-private-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
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