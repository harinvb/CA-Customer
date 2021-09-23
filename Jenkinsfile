//file:noinspection GroovyAssignabilityCheck
pipeline {
  agent {
    //noinspection GroovyAssignabilityCheck
    node {
      label 'azure'
    }
  }
  stages {
    stage('Print Message') {
      steps {
        echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
      }
    }

    stage('Git') {
      steps {
        git(url: 'https://github.com/harinvb/CA-Customer.git', branch: 'master')
      }
    }

    stage('build') {
      steps {
        withMaven {
          sh 'mvn compile package'
        }
//        withMaven {
//          sh 'mvn deploy'
//        }
        withSonarQubeEnv(credentialsId: 'SONAR_TOKEN',installationName: 'sonarcloud') {
          sh 'mvn sonar:sonar -Dsonar.projectKey=CA-Customer'
        }
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
    stage('Publish Artifacts') {
       steps {
           archiveArtifacts(artifacts: '**/target/*.jar',fingerprint: true)
       }
    }
  }
}