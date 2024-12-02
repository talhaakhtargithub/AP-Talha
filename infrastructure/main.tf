provider "aws" {
  region = "eu-north-1"  # Set your desired AWS region
}

# Define an S3 Bucket to store the model
resource "aws_s3_bucket" "model_bucket" {
  bucket = "sentiment-model-bucket-unique"  # Ensure this name is globally unique
  acl    = "private"
}

# Define IAM Role for EC2 to access AWS resources (S3, Secrets Manager)
resource "aws_iam_role" "ec2_role" {
  name               = "ec2_instance_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Define IAM Policy for S3 access (allow EC2 to interact with the S3 bucket)
resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3AccessPolicy"
  description = "Allow EC2 instance to access S3 bucket"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:PutObject"]
        Effect   = "Allow"
        Resource = "arn:aws:s3:::sentiment-model-bucket-unique/*"
      }
    ]
  })
}

# Attach the S3 access policy to the EC2 role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  policy_arn = aws_iam_policy.s3_access_policy.arn
  role       = aws_iam_role.ec2_role.name
}

# Define Secrets Manager to store the token securely
resource "aws_secretsmanager_secret" "model_token_secret" {
  name = "sentiment-model-token"
}

resource "aws_secretsmanager_secret_version" "model_token_secret_value" {
  secret_id     = aws_secretsmanager_secret.model_token_secret.id
  secret_string = jsonencode({
    token = "your-sensitive-token-value"
  })
}

# Define EC2 instance with the IAM role that has access to S3 and Secrets Manager
resource "aws_instance" "model_instance" {
  ami           = "ami-08eb150f611ca277f"  # Use the provided valid AMI ID for Ubuntu 24.04
  instance_type = "t3.micro"  # Choose an instance type as per your requirement

  key_name = "ok"  # Ensure you have created this key pair in AWS before deployment

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  security_groups = [aws_security_group.app_sg.name]

  tags = {
    Name = "SentimentModelEC2"
  }
}

# Attach the EC2 role to the instance through an instance profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# Output EC2 instance public IP
output "instance_public_ip" {
  value = aws_instance.model_instance.public_ip
}

# Optional: Security Group to allow HTTP/HTTPS access to EC2 instance
resource "aws_security_group" "app_sg" {
  name        = "app_security_group"
  description = "Allow HTTP/HTTPS access"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
