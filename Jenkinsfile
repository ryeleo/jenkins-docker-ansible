def user_id
def group_id
node {
  label 'nts'
  user_id = sh(returnStdout: true, script: 'id -u').trim()
  group_id = sh(returnStdout: true, script: 'id -g').trim()
}

pipeline {
  agent { 
    dockerfile {
      filename 'Dockerfile'
      additionalBuildArgs "--build-arg UID=${user_id} --build-arg GID=${group_id}"
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
