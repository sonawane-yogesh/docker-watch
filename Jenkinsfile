pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "docker-watch"
        DOCKER_HUB_REPO = "sonawaneyogeshb/docker-watch"
        DOCKER_IMAGE_TAG = "1.${env.BUILD_NUMBER}.0"
        CUSTOM_PATH = "/usr/bin:${env.PATH}"  
        DOCKET_HOST = "unix:///var/run/docker.sock"
    }    
    stages {
        stage('Run Tests') {
            steps {
                script {
                    try {
                        echo 'starting executing tests...'
                        sh "npm run test"
                        echo 'completed executing tests...'
                    } catch (Exception exception) {
                        echo "Caught exception: ${exception.message}"
                    }                    
                }                
            }
        }       
        stage('Docker Login and Push latest image') {
            steps {
                script {                    
                    withCredentials([usernamePassword(credentialsId: 'docker-private-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        withEnv(["DOCKER_USERNAME=${USERNAME}", "DOCKER_PASSWORD=${PASSWORD}"]) {
                            sh 'docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD'
                            sh "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} -f Dockerfile ."
                            sh "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}"
                            sh "docker push ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}"
                        }
                    }
                }
            }
        }   
        /*          
        stage('Kubernetes Deployment') {
            steps {
                script {
                    echo 'Deploying to local Kubernetes...' 
                    sh "kubectl apply -f ./deployment/deployment.yaml"
                }
            }
        }
        */
        /*
        * working stage, but need to use -p password inline parameter
        stage('Docker Login and Push') {
            steps {
                script {                                      
                    withCredentials([usernamePassword(credentialsId: 'docker-private-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh "docker login -u ${USERNAME} --password-stdin"                        
                        sh "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} -f Dockerfile ."
                        sh "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}"
                        sh "docker push ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}"
                    }                   
                }
            }
        }
        */ 
    }
}