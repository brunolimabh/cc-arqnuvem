provider "aws" {
  region = "us-east-1"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4   # 4 bytes = 8 caracteres hexadecimais
}

resource "aws_s3_bucket" "lab" {
  bucket = "lab-sprint5-arqnuvem-${random_id.bucket_suffix.hex}"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.lab.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t2.micro"
  key_name      = "control-node-sprint5"

  vpc_security_group_ids = ["sg-05a95a7b66220a2f3"]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y python3 python3-pip
              EOF

  tags = {
    Name = "Sprint5-EC2"
  }
}

output "ec2_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "bucket_name" {
  value = aws_s3_bucket.lab.bucket
}
