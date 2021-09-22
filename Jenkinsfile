pipeline {
  agent {
    node {
      label 'azure'
    }

  }
  stages {
    stage('Print Message') {
      steps {
        sh 'echo "Hello  $(hostname)"'
      }
    }

    stage('Git') {
      steps {
        git(url: 'https://github.com/harinvb/CA-Customer.git', branch: 'master')
      }
    }

    stage('build') {
      steps {
        sh 'mvn package'
      }
    }
    
    stage('terraform') {
      steps {
        sh 'terraform --help'
      }
    }
    
    stage('ansible') {
      steps {
        sh 'ansible --help'
      }
    }
    stage('kubernetes') {
      steps {
        sh 'kubectl --help'
      }
    }
  }
}