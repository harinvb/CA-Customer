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
          sh 'mvn compile -Dmaven.test.skip=true'
        }

        echo 'Compilation Successful'
      }
    }

    stage('Packaging & Analysis') {
      parallel {
        stage('Packaging') {
          steps {
            withMaven(publisherStrategy: 'IMPLICIT') {
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
        stage('PMD analysis') {
          steps {
            withMaven(mavenSettingsFilePath: '/home/jenkins/.m2/settings.xml', publisherStrategy: 'IMPLICIT') {
              sh 'mvn pmd:pmd -Dmaven.test.skip=true'
            }

            archiveArtifacts 'target/site/*.html'
          }
        }
      }
    }

    stage('Publish Artifacts and Images') {
      parallel {
        stage('Publishing to Artifactory') {
          steps {
            withMaven(mavenSettingsFilePath: '/home/jenkins/.m2/settings.xml', publisherStrategy: 'IMPLICIT') {
              sh 'mvn deploy -Dmaven.test.skip=true'
            }

          }
        }

        stage('Docker Image Build & Publish') {
          steps {
            withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
              sh 'docker login -u $USERNAME -p $PASSWORD'
              sh 'docker build -t harinvb/customer:${BUILD_ID} .'
              sh 'docker push harinvb/customer:${BUILD_ID}'
              sh 'docker logout'
            }
          }
        }

        stage("Preparing Terraform Infrastructure") {
          steps{
            sh '$(pwd)/Terraform/Infrastructure.sh'
          }
        }
      }
    }
    stage("Ansible Preparation"){
      steps{
        echo("Infrastructure created")
      }
    }
  }
}
