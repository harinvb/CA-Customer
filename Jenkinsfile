pipeline {
  agent {
    node {
      label 'azure'
    }

  }
  stages {
    stage('Git Checkout') {
      steps {
        git(url: 'git@github.com:harinvb/CA-Customer.git', branch: 'master', poll: true, credentialsId: 'linux-private-key2')
        echo 'Checked out'
      }
    }

    stage('Maven') {
      steps {
        withMaven(publisherStrategy: 'IMPLICIT', mavenSettingsFilePath: '~/.m2') {
          sh 'mvn clean verify'
          sh 'mvn deploy'
        }

      }
    }

  }
}