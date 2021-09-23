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
        withMaven(publisherStrategy: 'EXPLICIT', mavenSettingsFilePath: '/home/jenkins/.m2/settings.xml') {
          sh 'mvn clean verify'
        }

        echo 'Integration Successful'
      }
    }

    stage('Compilation') {
      steps {
        withMaven(publisherStrategy: 'EXPLICIT', mavenSettingsFilePath: '/home/jenkins/.m2/settings.xml') {
          sh 'mvn compile -Dmaven.test.skip=true'
        }

        echo 'Compilation Successful'
      }
    }

    stage('Packaging & Analysis') {
      parallel {
        stage('Packaging') {
          steps {
            withMaven(publisherStrategy: 'EXPLICIT') {
              sh 'mvn package -Dmaven.test.skip=true'
            }

          }
        }

        stage('Sonar Analysis') {
          steps {
            withSonarQubeEnv(installationName: 'sonarcloud', credentialsId: 'SONAR_TOKEN') {
              sh 'mvn sonar:sonar -Dsonar.projectKey=CA-Customer -Dmaven.test.skip=true'
            }

          }
        }

      }
    }

    stage('Publish & PMD Analysis') {
      parallel {
        stage('Publishing to Artifactory') {
          steps {
            withMaven(mavenSettingsFilePath: '/home/jenkins/.m2/settings.xml', publisherStrategy: 'IMPLICIT') {
              sh 'mvn deploy -Dmaven.test.skip=true'
            }

          }
        }

        stage('PMD analysis') {
          steps {
            withMaven(mavenSettingsFilePath: '/home/jenkins/.m2/settings.xml', publisherStrategy: 'EXPLICIT') {
              sh 'mvn pmd:pmd -Dmaven.test.skip=true'
            }

            archiveArtifacts 'target/site/*.html'
          }
        }

        stage('Docker Image Build') {
          steps {
            sh 'echo docker'
            withCredentials(bindings: 'docker-creds'){
              sh ''' docker login -u $USERNAME -p $PASSWORD
               '''
            }
          }
        }

      }
    }

  }
}