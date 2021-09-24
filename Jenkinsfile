pipeline {
    agent {
        node {
            label 'azure'
        }
    }
    stages {
        stage('Git Checkout') {
            steps {
                git(url: 'git@github.com:harinvb/CA-Customer.git', branch: "${BRANCH_NAME}", poll: true, credentialsId: 'linux-private-key2')
            }
        }
//        stage('Build') {
//            steps {
//                sh "echo Branch : ${BRANCH_NAME}"
//                sh 'mvn clean verify compile'
//            }
//        }
//        stage('Packaging & Analysis') {
//            parallel {
//                stage('Packaging') {
//                    steps {
//                        sh 'mvn package -Dmaven.test.skip=true'
//                    }
//                }
//                stage('Sonar Analysis') {
//                    steps {
//                        withSonarQubeEnv(installationName: 'sonarcloud', credentialsId: 'SONAR_TOKEN') {
//                            sh 'mvn sonar:sonar -Dsonar.projectKey=CA-Customer -Dmaven.test.skip=true'
//                        }
//                    }
//                }
//                stage('PMD analysis') {
//                    steps {
//                        sh 'mvn pmd:pmd -Dmaven.test.skip=true'
//                        archiveArtifacts 'target/site/*.html'
//                    }
//                }
//            }
//        }
//        stage('Pre Deployment') {
//            parallel {
//                stage('Publishing to Artifactory') {
//                    steps {
//                        withMaven(mavenSettingsFilePath: '/home/jenkins/.m2/settings.xml', publisherStrategy: 'IMPLICIT') {
//                            sh 'mvn deploy'
//                        }
//                    }
//                }
//                stage('Docker Image Build & Publish') {
//                    steps {
//                        withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
//                            sh 'docker login -u ${USERNAME} -p ${PASSWORD}'
//                            sh 'docker build -t ${USERNAME}/customer:${BUILD_ID} .'
//                            sh 'docker push ${USERNAME}/customer:${BUILD_ID}'
//                            sh 'docker logout'
//                        }
//                    }
//                }
//                stage("Preparing Terraform Infrastructure") {
//                    steps {
//                        dir("Terraform") {
//                            sh 'chmod +x ./Infrastructure.sh'
//                            sh './Infrastructure.sh'
//                        }
//                    }
//                }
//            }
//        }
//        stage("Deployment") {
//            parallel {
//                stage("Ansible Configuration and Deployment") {
//                    steps {
//                        dir("Ansible") {
//                            ansiblePlaybook("ansible_java_application.yaml")
//                        }
//                    }
//                }
                stage('Kubernetes') {
                    steps {
                        withCredentials(secret(credentialsId: 'dockerDetails', variable: 'DOCKCRED')) {
                            echo "${DOCKCRED}"
//                            variablesReplaceConfig(
//                                    configs: [
//                                            variablesReplaceItemConfig(
//                                                    name: 'DOCKER_CONFIG',
//                                                    value: "${DOCKCRED}"
//                                            ),
//                                            variablesReplaceItemConfig(
//                                                    name: 'TAG',
//                                                    value: "${BUILD_NUMBER}"
//                                            )
//                                    ],
//                                    fileEncoding: 'UTF-8',
//                                    filePath: 'Deployment.yaml',
//                                    variablesPrefix: '#{',
//                                    variablesSuffix: '}#'
//                            ,emptyValue: " ")
//                        }
//                        withCredentials([file(credentialsId: 'kubeConfig', variable: 'KUBECRED')]){
//                            sh 'kubectl --kubeconfig $KUBECRED apply -f Deployment.yaml'
//                        }
//                    }
                }
            }
        }
    }
    post {
        always {
            cleanWs(deleteDirs: true, notFailBuild: true)
        }
    }
}
