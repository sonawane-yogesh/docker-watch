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
        stage('Update Helm Chart Repository') {
            agent {
                docker { image 'alpine/k8s:1.25.16' }
            }
            steps {
                script {                    
                    sh script:"""
                        rm -rf __temp
                        mkdir __temp
                        cd ./__temp
                        ls
                        git clone https://sonawane-yogesh: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@github.com/sonawane-yogesh/docker-watch-helm.git
                        cd docker-watch-helm
                        sed -i \'s|^ *image:.*|image: ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}|g\' templates/deployment.yaml
                        git add .
                        git config --global user.email "sonawaneyogeshb@gmail.com"
                        git config --global user.name "sonawaneyogeshb@gmail.com"
                        git commit -m "Updated deployment.yaml"
                        git push            
                    """
                }
            }
        }
    }
}