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

    stage('Integration') {
      steps {
        withMaven(publisherStrategy: 'IMPLICIT', mavenSettingsFilePath: '/home/jenkins/.m2/settings.xml') {
          sh 'mvn clean verify'
        }
        echo "Integration Successful"
      }
    }

    stage('Compilation') {
      steps {
        withMaven(publisherStrategy: 'IMPLICIT', mavenSettingsFilePath: '/home/jenkins/.m2/settings.xml') {
          sh 'mvn Compile'
        }
        echo "Compilation Successful"
      }
    }
  }
}