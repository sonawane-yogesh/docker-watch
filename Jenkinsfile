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
                    withCredentials([usernamePassword( credentialsId: 'docker-private-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) 
                    {
                        docker.withRegistry('', 'docker-private-credentials') 
                        {
                            sh "docker login -u ${USERNAME} -p ${PASSWORD}"
                        }
                    }
                }    
            }
        }
        /*
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
        */        
        stage('Build Docker Image') {
            steps {
                script {
                    def imageName = 'docker-watch'
                    def imageTag = env.BUILD_NUMBER
                    // Build the Docker image
                    sh "docker build -t ${imageName}:${imageTag} -f Dockerfile ."
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    def imageName = 'docker-watch'
                    def imageTag = env.BUILD_NUMBER                    
                    // Push the Docker image
                    sh "docker push ${imageName}:${imageTag}"
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