pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "docker-watch"
        DOCKER_HUB_REPO = "sonawaneyogeshb/docker-watch"
        DOCKER_IMAGE_TAG = "1.${env.BUILD_NUMBER}.0"
        GIT_HELM_REPO = "docker-watch-helm"
        GIT_EMAIL = "${GIT_EMAIL}"
        KUBECONFIG = "/home/lablink/.kube/config"
    }    
    stages {        
        stage("Run Tests") {
            agent {
                docker { image "node:16-alpine" }
            }
            steps {
                script {
                    try {
                        echo "running npm install..."
                        sh "npm install"
                        echo "complated npm install"
                        echo "running executing tests..."
                        sh "npm run test"
                        echo "completed executing tests"                        
                        def coverageDir = "${JOB_URL}/htmlreports/coverage-reports"
                        if (fileExists(coverageDir)) {
                            dir(coverageDir) {
                                publishHTML([
                                    allowMissing: false,
                                    alwaysLinkToLastBuild: false,
                                    keepAll: false,
                                    reportDir: "",
                                    reportFiles: "index.html",
                                    reportName: "coverage-reports",
                                    reportTitles: "",
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
        stage("Docker Login and Push latest image") {
            steps {
                script {                    
                    withCredentials([usernamePassword(credentialsId: "docker-private-credentials", usernameVariable: "USERNAME", passwordVariable: "PASSWORD")]) {
                        withEnv(["DOCKER_USERNAME=${USERNAME}", "DOCKER_PASSWORD=${PASSWORD}"]) {
                            sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                            sh "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} -f Dockerfile ."
                            sh "docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}"
                            sh "docker push ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}"
                        }
                    }
                }
            }
        } 
        stage("Prepare Workspace") {
            steps {
                script {
                    sh "rm -rf __temp"
                    dir("__temp") {
                        sh "ls"
                    }
                }
            }
        }

        stage("Clone Repository") {
            steps {
                dir("__temp") {
                    withCredentials([usernamePassword(credentialsId: "git-credentials", usernameVariable: "USERNAME", passwordVariable: "PASSWORD")]) {
                        withEnv(["GIT_USERNAME=${USERNAME}", "GIT_PASSWORD=${PASSWORD}"]) {
                            sh ("git clone https://$GIT_USERNAME:$GIT_PASSWORD@github.com/$GIT_USERNAME/${GIT_HELM_REPO}.git")
                            sh ("cd ${GIT_HELM_REPO}")
                        }
                    }
                }
            }
        }
        
        stage("Modify Deployment.yaml") {
            steps {
                dir("__temp/${GIT_HELM_REPO}") {
                    sh ("sed -i \'s|^ *image:.*|        image: ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}|g\' templates/deployment.yaml")
                }
            }
        }
        
        stage("Commit Changes") {
            steps {
                dir("__temp/${GIT_HELM_REPO}") {
                    withCredentials([usernamePassword(credentialsId: "git-credentials", usernameVariable: "USERNAME", passwordVariable: "PASSWORD")]) {
                        withEnv(["GIT_USERNAME=${USERNAME}", "GIT_PASSWORD=${PASSWORD}"]) {
                            sh "git add ."
                            sh "git config --global user.email ${GIT_EMAIL}"
                            sh "git config --global user.name ${GIT_EMAIL}"
                            sh "git commit -m changed-image-tag--${DOCKER_IMAGE_TAG}--via-pipeline"
                            sh ("git push https://$GIT_USERNAME:$GIT_PASSWORD@github.com/$GIT_USERNAME/${GIT_HELM_REPO}.git")
                        }
                    }    
                }
            }
        }
        // TODO: working on following stage to get it work
        /*
        stage("Install Helm Chart") {
            steps {
                dir("__temp/${GIT_HELM_REPO}") {
                    sh ("helm lint .")
                    sh ("helm template .")
                    sh ("helm install --dry-run ${DOCKER_IMAGE_NAME} ./")
                    sh ("helm install ${DOCKER_IMAGE_NAME} ./")
                }
            }
        }
        */
    }
}