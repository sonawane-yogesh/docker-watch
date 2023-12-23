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
            agent {
                docker { image 'node:16-alpine' }
            }
            steps {
                script {
                    try {
                        echo 'running npm install...'
                        sh 'npm install'
                        echo 'complated npm install'
                        echo 'running executing tests...'
                        sh "npm run test"
                        echo 'completed executing tests'
                        def coverageDir = "${WORKSPACE}/coverage/lcov-report"
                        if (fileExists(coverageDir)) {
                            dir(coverageDir) {
                                publishHTML([
                                    allowMissing: false,
                                    alwaysLinkToLastBuild: false,
                                    keepAll: false,
                                    reportDir: '',
                                    reportFiles: 'index.html',
                                    reportName: 'coverage-report',
                                    reportTitles: '',
                                    useWrapperFileDirectly: true
                                ])
                            }
                        } else {
                            error("Coverage directory not found: ${coverageDir}")
                        }
                    } catch (Exception exception) {
                        echo "Caught exception: ${exception.message}"
                    }                    
                }                
            }
        }
        stage('Publish HTML Reports') {
            steps {
                script {
                    def coverageDir = "${WORKSPACE}/coverage/lcov-report"
                    if (fileExists(coverageDir)) {
                        dir(coverageDir) {
                            publishHTML([
                                allowMissing: false,
                                alwaysLinkToLastBuild: false,
                                keepAll: false,
                                reportDir: '',
                                reportFiles: 'index.html',
                                reportName: 'Code Coverage Report',
                                reportTitles: '',
                                useWrapperFileDirectly: true
                            ])
                        }
                    } else {
                        error("Coverage directory not found: ${coverageDir}")
                    }
                }
            }
        }
        // commented out following stage for other stages to complete.
        /*       
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
        */   
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