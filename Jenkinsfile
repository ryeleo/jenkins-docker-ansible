pipeline {
  agent { 
    dockerfile {
      filename 'Dockerfile'
      args '--build-arg UID=${sh(script: 'id -u', returnStdout: true).trim()} --build-arg GID=${sh(script: 'id -g', returnStdout: true).trim()}' // Build docker  ready to be run by the jenkins user
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
        sh 'ansible --version'
        sh 'ansible-playbook main.yml'
      }
    }
  }
}
