pipeline {
    agent any

    environment {
        DOCKER_IMAGE_NAME = "docker-watch"
        DOCKER_HUB_REPO = "sonawaneyogeshb/docker-watch"
        DOCKER_IMAGE_TAG = "1.${BUILD_NUMBER}.0"

        GIT_HELM_REPO = "docker-watch-helm"
        GIT_EMAIL = "sonawaneyogeshb@gmail.com"

        COVERAGE_DIR = "coverage"
    }

    options {
        timestamps()
        ansiColor('xterm')
    }

    stages {

        stage('Verify Branch') {
            steps {
                script {
                    if (env.BRANCH_NAME != 'yogeshs') {
                        currentBuild.result = 'NOT_BUILT'
                        error("Skipping build for branch: ${env.BRANCH_NAME}")
                    }
                }
            }
        }

        stage('Build') {
            steps {
                sh 'echo Building...'
            }
        }

        // =========================================================
        // CHECKOUT SOURCE CODE
        // =========================================================

        stage('Checkout Source') {
            steps {
                checkout scm
            }
        }

        // =========================================================
        // VERIFY TOOLS
        // =========================================================

        stage('Verify Tools') {
            steps {
                sh 'node -v'
                sh 'npm -v'
                sh 'docker --version'
                sh 'git --version'
            }
        }

        // =========================================================
        // INSTALL DEPENDENCIES
        // =========================================================

        stage('Install Dependencies') {
            steps {
                echo 'Installing npm dependencies...'
                sh 'npm install'
            }
        }

        // =========================================================
        // RUN TESTS
        // =========================================================

        stage('Run Tests') {
            steps {
                echo 'Running tests...'
                sh 'npm run test'
            }
        }

        // =========================================================
        // PUBLISH COVERAGE REPORT
        // =========================================================

        stage('Publish Coverage Report') {
            steps {
                script {
                    if (fileExists("${COVERAGE_DIR}")) {
                        publishHTML([
                            allowMissing: true,
                            alwaysLinkToLastBuild: true,
                            keepAll: true,
                            reportDir: "${COVERAGE_DIR}",
                            reportFiles: 'index.html',
                            reportName: 'Coverage Report'
                        ])
                    } else {
                        echo "Coverage directory not found: ${COVERAGE_DIR}"
                    }
                }
            }
        }

        // =========================================================
        // BUILD DOCKER IMAGE
        // =========================================================

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'

                sh """
                    docker build \
                    -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} \
                    -f Dockerfile .
                """
            }
        }

        // =========================================================
        // DOCKER LOGIN
        // =========================================================

        stage('Docker Login') {
            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-private-credentials',
                        usernameVariable: 'DOCKER_USERNAME',
                        passwordVariable: 'DOCKER_PASSWORD'
                    )
                ]) {

                    sh '''
                        echo "$DOCKER_PASSWORD" | docker login \
                        -u "$DOCKER_USERNAME" \
                        --password-stdin
                    '''
                }
            }
        }

        // =========================================================
        // PUSH DOCKER IMAGE
        // =========================================================

        stage('Push Docker Image') {
            steps {
                echo 'Tagging Docker image...'

                sh """
                    docker tag \
                    ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} \
                    ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}
                """

                echo 'Pushing Docker image...'

                sh """
                    docker push \
                    ${DOCKER_HUB_REPO}:${DOCKER_IMAGE_TAG}
                """
            }
        }

        // =========================================================
        // PREPARE WORKSPACE
        // =========================================================

        stage('Prepare Workspace') {
            steps {
                sh 'rm -rf __temp'
                sh 'mkdir -p __temp'
            }
        }

        // =========================================================
        // CLONE HELM REPOSITORY
        // =========================================================

        stage('Clone Helm Repository') {
            steps {
                dir('__temp') {
                    withCredentials([
                        usernamePassword(
                            credentialsId: 'git-credentials',
                            usernameVariable: 'GIT_USERNAME',
                            passwordVariable: 'GIT_PASSWORD'
                        )
                    ]) {

                        sh '''
                            git clone -b yogeshs \
                            https://$GIT_USERNAME:$GIT_PASSWORD@github.com/$GIT_USERNAME/$GIT_HELM_REPO.git
                        '''
                    }
                }
            }
        }

        // =========================================================
        // UPDATE HELM IMAGE TAG
        // =========================================================

        stage('Update Helm Deployment') {
            steps {
                dir("__temp/${GIT_HELM_REPO}") {

                    sh """
                        sed -i \
                        's|^  tag:.*|  tag: \"${DOCKER_IMAGE_TAG}\"|' \
                        values.yaml
                    """

                    sh 'cat values.yaml'
                }
            }
        }

        // =========================================================
        // COMMIT AND PUSH CHANGES
        // =========================================================

        stage('Commit And Push Changes') {
            steps {
                dir("__temp/${GIT_HELM_REPO}") {

                    withCredentials([
                        usernamePassword(
                            credentialsId: 'git-credentials',
                            usernameVariable: 'GIT_USERNAME',
                            passwordVariable: 'GIT_PASSWORD'
                        )
                    ]) {

                        sh "git config --global user.email '${GIT_EMAIL}'"
                        sh "git config --global user.name 'Jenkins CI'"

                        sh 'git add .'

                        sh '''
                            git diff --cached --quiet || \
                            git commit -m "changed-image-tag-${DOCKER_IMAGE_TAG}-via-pipeline"
                        '''

                        sh '''
                            git push \
                            https://$GIT_USERNAME:$GIT_PASSWORD@github.com/$GIT_USERNAME/$GIT_HELM_REPO.git \
                            HEAD:yogeshs
                        '''
                    }
                }
            }
        }

        // =========================================================
        // OPTIONAL HELM VALIDATION
        // =========================================================

        stage('Helm Validation') {
            when {
                expression { return false }
            }

            steps {
                dir("__temp/${GIT_HELM_REPO}") {
                    sh 'helm lint .'
                    sh 'helm template .'
                }
            }
        }
    }

    // =========================================================
    // POST ACTIONS
    // =========================================================

    post {

        success {
            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed.'
        }

        always {
            echo 'Cleaning workspace...'
            cleanWs()
        }
    }
}