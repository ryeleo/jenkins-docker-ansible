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
        sh 'which ansible'
        sh 'which ansible-playbook'
        sh 'ls -al'
        sh 'ansible-playbook'
      }
    }
  }
}
