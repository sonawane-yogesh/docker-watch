pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "docker-watch"
        DOCKER_HUB_REPO = "sonawaneyogeshb/docker-watch"
        DOCKER_IMAGE_TAG = "1.${env.BUILD_NUMBER}.0"
        CUSTOM_PATH = "/usr/bin:${env.PATH}"  
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
                        def coverageDir = "${JOB_URL}/htmlreports/coverage-reports"
                        if (fileExists(coverageDir)) {
                            dir(coverageDir) {
                                publishHTML([
                                    allowMissing: false,
                                    alwaysLinkToLastBuild: false,
                                    keepAll: false,
                                    reportDir: '',
                                    reportFiles: 'index.html',
                                    reportName: 'coverage-reports',
                                    reportTitles: '',
                                    useWrapperFileDirectly: true
                                ])
                            }
                        } else {
                            echo "in else block of coverage report"
                            error("Coverage directory not found: ${coverageDir}")
                        }
                    } catch (Exception exception) {
                        echo "in catch block"
                        echo "Caught exception: ${exception.message}"
                    }                    
                }                
            }
        } 
        // commented out following stage for other stages to complete.
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
        stage('Prepare Workspace') {
            steps {
                script {
                   sh 'rm -rf __temp'
                    dir('__temp') {
                        sh 'ls'
                    }
                }
            }
        }

        stage('Clone Repository') {
            steps {
                dir('__temp') {
                    withCredentials([usernamePassword(credentialsId: 'git-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]){
                        withEnv(["GIT_USERNAME=${USERNAME}", "GIT_PASSWORD=${PASSWORD}"]) {
                            sh("git clone https://$GIT_USERNAME:$GIT_PASSWORD@github.com/sonawane-yogesh/docker-watch-helm.git")
                        }
                    }
                    sh 'cd docker-watch-helm'
                    sh "ls"
                }
            }
        }
        
        stage('Modify Deployment.yaml') {
            steps {
                dir('__temp/docker-watch-helm') {
                    sh("sed -i \'s|^ *image:.*|        image: ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}|g\' templates/deployment.yaml")
                }
            }
        }
        
        stage('Commit Changes') {
            steps {
                dir('__temp/docker-watch-helm') {
                    sh 'git add .'
                    sh 'git config --global user.email "sonawaneyogeshb@gmail.com"'
                    sh 'git config --global user.name "sonawaneyogeshb@gmail.com"'
                    sh 'git commit -m "jenkins-test-from pipeline -- updated deployment.yaml -- via pipeline"'
                }
            }
        }
        
        stage('Push Changes') {
            steps {
                dir('__temp/docker-watch-helm') {
                   withCredentials([usernamePassword(credentialsId: 'git-credentials', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]){
                        withEnv(["GIT_USERNAME=${USERNAME}", "GIT_PASSWORD=${PASSWORD}"]) {
                            sh("git push https://$GIT_USERNAME:$GIT_PASSWORD@github.com/sonawane-yogesh/docker-watch-helm.git")
                        }
                    }
                }
            }
        }
    }
}