pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials-id') // Replace with your Jenkins credentials ID for Docker Hub
        GITHUB_REPO_URL = 'https://github.com/your-username/your-repository.git' // Replace with your GitHub repository URL
        DOCKER_REPO = 'your-dockerhub-username' // Replace with your Docker Hub username
        BACKEND_IMAGE = 'backend-image'
        FRONTEND_IMAGE = 'frontend-image'
    }
    
    stages {
        stage('Checkout from GitHub') {
            steps {
                git branch: 'main', url: "${GITHUB_REPO_URL}" // Replace 'main' with your branch if different
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

        stage('Push Docker Images to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials-id') {
                        sh 'docker push ${DOCKER_REPO}/${BACKEND_IMAGE}:latest'
                        sh 'docker push ${DOCKER_REPO}/${FRONTEND_IMAGE}:latest'
                    }
                }
            }
        }
        
        stage('Deploy Infrastructure with Terraform') {
            steps {
                dir('infrastructure') {
                    sh '''
                        terraform init
                        terraform apply -auto-approve
                    '''
                }
            }
        }
    }
}
