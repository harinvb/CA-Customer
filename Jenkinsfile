pipeline {
    agent {
        node {
            label 'azure'
        }
    }
    stages {
        stage('Git Checkout') {
            steps {
                git(url: 'git@github.com:harinvb/CA-Customer.git', branch: "master", poll: true, credentialsId: 'linux-private-key2')
            }
        }
        stage('Build') {
            steps {
                configFileProvider([configFile(fileId: 'mavenGlobalSettings', variable: 'MGS')]) {
                    sh 'mvn clean verify compile -gs $MGS'
                }
            }
        }
        stage('Packaging') {
            steps {
                configFileProvider([configFile(fileId: 'mavenGlobalSettings', variable: 'MGS'),configFile(fileId: 'datasource', variable: 'DS')]) {
                    sh 'mvn package -gs $MGS $(cat $DS)'
                }
            }
        }
        stage('Docker Imgae build'){
            steps{
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'docker build -t ${USERNAME}/customer:latest .'
                }
            }
        }
        stage('Analysis') {
            parallel {
                stage('Sonar Analysis') {
                    steps {
                        withSonarQubeEnv(installationName: 'sonarcloud', credentialsId: 'SONAR_TOKEN') {
                            configFileProvider([configFile(fileId: 'mavenGlobalSettings', variable: 'MGS')]) {
                                sh 'mvn sonar:sonar -Dsonar.projectKey=CA-Customer -Dmaven.test.skip=true -gs $MGS'
                            }
                        }
                    }
                }
                stage('PMD analysis') {
                    steps {
                        configFileProvider([configFile(fileId: 'mavenGlobalSettings', variable: 'MGS')]) {
                            sh 'mvn pmd:pmd -Dmaven.test.skip=true -gs $MGS'
                        }
                        archiveArtifacts 'target/site/*.html'
                    }
                }
            }
        }
        stage('Pre Deployment') {
            parallel {
                stage('Publishing to Artifactory') {
                    steps {
                        withMaven(globalMavenSettingsConfig: 'mavenGlobalSettings', publisherStrategy: 'IMPLICIT') {
                            configFileProvider([configFile(fileId: 'datasource', variable: 'DS')]) {
                                sh 'mvn deploy $(cat $DS)'
                            }
                        }
                    }
                }
                stage('Publishing to container registry') {
                    steps {
                        withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                            sh 'docker login -u ${USERNAME} -p ${PASSWORD}'
                            sh 'docker push ${USERNAME}/customer:latest'
                            sh 'docker image rm ${USERNAME}/customer:latest'
                            sh 'docker logout'
                        }
                    }
                }
                stage("Preparing Terraform Infrastructure") {
                    steps {
                        dir("Terraform") {
                            sh 'terraform init'
                            sh 'terraform apply -auto-approve'
                            sh 'chmod +x ./Infrastructure.sh'
                            sh './Infrastructure.sh'
                        }
                    }
                }
            }
        }
        stage("Deployment") {
            parallel {
                stage("Ansible Configuration and Deployment") {
                    steps {
                        dir("Ansible") {
                            ansiblePlaybook("ansible_java_application.yaml")
                        }
                    }
                }
                stage('Kubernetes Deployment') {
                    steps {
                        withCredentials([file(credentialsId: 'kubeConfig', variable: 'KUBECRED'),file(credentialsId: 'docker_creds', variable: 'DOCKCRED')]){
                            sh 'kubectl get --kubeconfig $KUBECRED secret docker-creds || kubectl apply --kubeconfig $KUBECRED -f $DOCKCRED'
                            sh 'kubectl apply --kubeconfig $KUBECRED -f Deployment.yaml'
                        }
                    }
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
