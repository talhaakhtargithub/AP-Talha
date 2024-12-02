pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
        S3_BUCKET_NAME = "my-model-bucket"
    }

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/your-repo.git'
            }
        }

        stage('Set Up AWS Infrastructure with Terraform') {
            steps {
                script {
                    sh 'terraform init'
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Download Model from S3') {
            steps {
                script {
                    sh '''
                    aws s3 cp s3://$S3_BUCKET_NAME/model.tar.gz .
                    tar -xzf model.tar.gz
                    '''
                }
            }
        }

        stage('Build and Deploy Docker Containers') {
            steps {
                script {
                    sh 'docker-compose up --build -d'
                }
            }
        }

        stage('Clean Up') {
            steps {
                script {
                    sh 'terraform destroy -auto-approve'
                }
            }
        }
    }
}
