pipeline {
    agent any
    
    environment {
        AWS_CREDENTIALS = credentials('aws-credentials-id') // Replace with your Jenkins credentials ID
        DOCKER_REPO = 'your-docker-repo'
        BACKEND_IMAGE = 'talhaboss-backend-1'
        FRONTEND_IMAGE = 'talhaboss-frontend-1'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Backend Docker Image') {
            steps {
                dir('backend') {
                    sh 'docker build -t ${DOCKER_REPO}/${BACKEND_IMAGE}:latest .'
                }
            }
        }
        
        stage('Build Frontend Docker Image') {
            steps {
                dir('frontend') {
                    sh 'docker build -t ${DOCKER_REPO}/${FRONTEND_IMAGE}:latest .'
                }
            }
        }

        stage('Push Docker Images') {
            steps {
                sh 'docker login -u ${DOCKER_USERNAME} -p ${DOCKER_PASSWORD}'
                sh 'docker push ${DOCKER_REPO}/${BACKEND_IMAGE}:latest'
                sh 'docker push ${DOCKER_REPO}/${FRONTEND_IMAGE}:latest'
            }
        }

        stage('Apply Terraform') {
            steps {
                dir('infrastructure') {
                    withAWS(credentials: 'aws-credentials-id', region: 'your-region') {
                        sh '''
                            terraform init
                            terraform apply -auto-approve
                        '''
                    }
                }
            }
        }
    }
}
