# Creating an EC2 Instance w/ Terraform 
# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# create a keypair in terraform code
# this assigns the public_key portion
# private key portion is saved to a local file later
resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

# create a private key
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# save the private key to a local file
resource "local_file" "TF_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "TF_key.pem"
}

# Create EC2 instance w/ name of key_pair
resource "aws_instance" "mdexample" {
  ami           = "ami-0cff7528ff583bf9a"
  instance_type = "t2.micro"
  key_name      = "TF_key"
}

# go to the console, select your instance, click Connect and follow instructions to connect to your instance
