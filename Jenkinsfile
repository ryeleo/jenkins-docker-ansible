pipeline {
  agent { 
    docker {
      dockerfile true
      label 'nts' // Needs to run on specific 'NTS' agent in my Jenkins environment.
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
        sh 'ls -al'
        sh 'ansible-playbook main.yml'
      }
    }
  }
}
