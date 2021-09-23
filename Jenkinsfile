//file:noinspection GroovyAssignabilityCheck
pipeline {
  agent {
    //noinspection GroovyAssignabilityCheck
    node {
      label 'azure'
    }
  }
  stages {
    stage('Print Info') {
      steps {
        echo "Running ${env.BUILD_ID} on ${env.JENKINS_URL}"
      }
    }

    stage('Git Checkout') {
      steps {
        git(url: 'https://github.com/harinvb/CA-Customer.git', branch: 'master')
        echo "Checked out from Repository"
      }
    }

    stage('build') {
    }

    stage('Sonar Qube Analysis'){
      steps{
        withSonarQubeEnv(credentialsId: 'SONAR_TOKEN',installationName: 'sonarcloud') {
          sh "mvn sonar:sonar -Dsonar.projectKey=CA-Customer"
        }
      }
    }

    stage('PMD analysis'){
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
         rtMavenRun pom: 'pom.xml',goals: 'deploy', tool: 'maven'
         archiveArtifacts artifacts: '**/target/*.jar',fingerprint: true
       }
    }
    stage('Publish Test Results'){
      steps{
        junit 'target/surefire-reports/*.xml'
      }
    }
  }
}