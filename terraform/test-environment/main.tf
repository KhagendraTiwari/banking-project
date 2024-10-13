provider "aws" {
  region = "us-east-2"
}

# Data source to check if the test instance already exists based on the Name tag
data "aws_instance" "existing_testserver" {
  filter {
    name   = "tag:Name"
    values = ["testserver"]  # Ensure this matches the instance's name tag
  }
}

# Resource to create a new test instance if it doesn't already exist
resource "aws_instance" "testserver" {
  count         = length(data.aws_instance.existing_testserver.ids) == 0 ? 1 : 0  # Create only if no instance exists
  ami           = "ami-0866a3c8686eaeeba"  # Replace with your desired AMI ID
  instance_type = "t2.micro"                # Choose your instance type
  key_name      = "ktkey"                   # Replace with your key pair name

  tags = {
    Name = "testserver"  # Ensure the tag matches the data source
  }

  # Security group setup to allow all traffic
  vpc_security_group_ids = [aws_security_group.testserver_sg.id]

  # Connection settings for Ansible
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ip_address.txt"
  }
}

# Security group allowing all traffic (inbound and outbound)
resource "aws_security_group" "testserver_sg" {
  name        = "testserver_sg"
  description = "Allow all inbound and outbound traffic"

  # Inbound rules
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"    # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow from any IP address
  }

  # Outbound rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"    # Allow all protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow to any IP address
  }
}

# Output the public IP of the test server
output "testserver_public_ip" {
  value = length(aws_instance.testserver) > 0 ? aws_instance.testserver[0].public_ip : "No instance created"
}
