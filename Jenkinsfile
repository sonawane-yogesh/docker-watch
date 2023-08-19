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
            }
        }
        stage('Publish Docker Image') {
            steps {
                script {                
                    echo 'Building docker image...'
                    docker build -t docker-watch:latest -f Dockerfile .
                    echo 'Docker tag creation...'
                    docker tag docker-watch:latest sonawaneyogeshb/docker-watch:latest
                    echo 'Pushing docker image...'
                    docker push sonawaneyogeshb/docker-watch:latest
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