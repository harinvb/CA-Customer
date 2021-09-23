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

        echo 'Integration Successful'
      }
    }

    stage('Compilation') {
      steps {
        withMaven(publisherStrategy: 'IMPLICIT', mavenSettingsFilePath: '/home/jenkins/.m2/settings.xml') {
          sh 'mvn compile'
        }

        echo 'Compilation Successful'
      }
    }

    stage('Packaging') {
      parallel {
        stage('Packaging') {
          steps {
            withMaven(publisherStrategy: 'IMPLICIT') {
              sh 'mvn package'
            }

          }
        }

        stage('Sonar Analysis') {
          steps {
            withSonarQubeEnv(installationName: 'sonarcloud', credentialsId: 'SONAR_TOKEN') {
              sh 'mvn sonar:sonar -Dsonar.projectKey=CA-Customer'
            }

          }
        }

      }
    }

    stage('Publish to Artifactory') {
      parallel {
        stage('Publish to Artifactory') {
          steps {
            withMaven(mavenSettingsFilePath: '/home/jenkins/.m2/settings.xml', publisherStrategy: 'IMPLICIT') {
              sh 'mvn deploy'
            }

          }
        }

        stage('Publish to Jenkins') {
          steps {
            archiveArtifacts(artifacts: 'target/*.jar', fingerprint: true)
          }
        }

      }
    }

    stage('Publish Test Results') {
      steps {
        junit 'surefire-reports/TEST-*.xml'
      }
    }

  }
}