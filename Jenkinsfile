pipeline {
  agent { 
    dockerfile {
      filename 'Dockerfile'
      args '--user 0:0' // ansible commands fail if not logged in as root:root
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
