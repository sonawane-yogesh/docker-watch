pipeline {
    agent any
    stages {
        stage('Run npm install') {
            steps {
                echo 'Running npm install command...'
                npm install
            }
        }
        stage('Run start command') {
            steps {
                echo 'Starting server application...'
                npm start
            }
        }
        stage('Deploy with Helm') {
            steps {
                script {
                    def helmChartRepo = 'https://sonawane-yogesh.github.io/docker-watch-helm/'
                    def helmChartName = 'docker-watch-helm'
                    def helmReleaseName = 'latest'
                    sh "helm repo add docker-watch-helm ${helmChartRepo}"
                    sh "helm repo update"
                    sh "helm upgrade --install ${helmReleaseName} ${helmChartName} --namespace docker-watch-namespace -f values.yaml"
                }
            }
        }
    }
}