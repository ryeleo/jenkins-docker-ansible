pipeline {
  agent { 
    dockerfile {
      filename 'Dockerfile'
      additionalBuildArgs "--build-arg uid=1888 --build-arg gid=1888"
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
