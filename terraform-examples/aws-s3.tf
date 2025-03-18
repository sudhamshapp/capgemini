provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance"
  }
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "my-example-bucket"
  # acl    = "private"

  depends_on = [aws_instance.example] # this line helps achieve the expectation

  tags = {
    Name = "example-bucket"
  }
}


# Provider Block: Specifies the AWS region.
# EC2 Instance Resource: Creates an EC2 instance with the specified AMI and instance type.
# S3 Bucket Resource: Creates an S3 bucket with a dependency on the EC2 instance, ensuring the bucket is created only after the instance is up.


resource "aws_instance" "thisisthe server" {
  ami           = "qwertyui2345678"
  instance_type = "t2.micro"
  tags = {
    Name       = "sudhamsh"
    enviroment = "dev"
  }
}


resource "s3" "thisistype" {
  bucket = "theuniquebucketofsudhamshatcap"
  acl = true
  
}