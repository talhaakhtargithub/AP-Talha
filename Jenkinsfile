pipeline {
    agent any

    environment {
        // Hardcoded AWS credentials
        AWS_ACCESS_KEY_ID     = 'AKIA4DMVQXWXO4YV6WGC'  // AWS access key
        AWS_SECRET_ACCESS_KEY = '5GbGYHDvCB7OpyFqp4uPsBc7VI+w4BcwoPTpBp5u'  // AWS secret key
        S3_BUCKET_NAME        = "sentiment-model-bucket-unique"  // Your S3 bucket name
    }

    stages {
        stage('Checkout Code') {
            steps {
                // Clone your GitHub repository
                git 'https://github.com/talhaakhtargithub/AP-Talha.git'  // Replace with your GitHub repository URL
            }
        }

        stage('Set Up AWS Infrastructure with Terraform') {
            steps {
                script {
                    // Initialize and apply Terraform configuration
                    sh 'terraform init -chdir=infrastructure'
                    sh 'terraform apply -auto-approve -chdir=infrastructure'
                }
            }
        }

        stage('Download Model from S3') {
            steps {
                script {
                    // Download the model from S3 bucket
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
                    // Build and run the containers using Docker Compose
                    sh 'docker-compose -f docker-compose.yml up --build -d'
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up resources..."
            sh 'docker-compose -f docker-compose.yml down'  // Clean up after running the pipeline
        }
    }
}
