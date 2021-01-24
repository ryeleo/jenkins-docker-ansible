pipeline {
  agent { 
    dockerfile {
      filename 'Dockerfile'
      dir '.'
    }
  }
  stages {
    stage('Checkout repository') {
      steps {
        checkout scm
      }
    }
    stage('Run ansible in docker, eh?') {
      steps {
        sh 'pwd'
        sh 'ls -al'
        sh 'sleep 300'
      }
    }
  }
}
