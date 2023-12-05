pipeline {
  agent any 
  environment {
    DOCKERHUB_CREDENTIALS = credentials('docker-private-credentials')
  }
  stages {
    stage('Build') {
      steps {
        sh './jenkins/build.sh'       
      }
    }
    stage('Login') {
      steps {
        sh './jenkins/login.sh'
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
