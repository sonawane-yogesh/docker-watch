pipeline {
  agent any 
  environment {
    DOCKERHUB_CREDENTIALS = credentials('docker-private-credentials')
  }
  stages {
   
    stage('Login') {
      steps {
        sh 'echo $DOCKERHUB_CREDENTIALS_PSW | sudo docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'                		
	    echo 'Login Completed' 
      }
    }
    stage('Push') {
      steps {
        sh './jenkins/push.sh'
      }
    }
  }
}
