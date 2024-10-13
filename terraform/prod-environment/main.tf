provider "aws" {
  region = "us-east-2"
}

# Data source to check if the production instance already exists
data "aws_instance" "existing_prodserver" {
  filter {
    name   = "tag:Name"
    values = ["prodserver"]  # Ensure this matches the instance's name tag
  }
}

# Resource to create a new production instance if it doesn't already exist
resource "aws_instance" "prodserver" {
  count         = length(data.aws_instance.existing_prodserver.ids) == 0 ? 1 : 0  # Create only if no instance exists
  ami           = "ami-0866a3c8686eaeeba"  # Replace with your desired AMI ID
  instance_type = "t2.micro"                # Choose your instance type
  key_name      = "ktkey"                   # Replace with your key pair name

  tags = {
    Name = "prodserver"  # Ensure the tag matches the data source
  }

  # Security group setup to allow all traffic
  vpc_security_group_ids = [aws_security_group.prodserver_sg.id]

  # Connection settings for Ansible
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > prod_ip_address.txt"
  }
}

# Security group allowing all traffic (inbound and outbound) for production server
resource "aws_security_group" "prodserver_sg" {
  name        = "prodserver_sg"
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

# Output the public IP of the production server
output "prodserver_public_ip" {
  value = length(aws_instance.prodserver) > 0 ? aws_instance.prodserver[0].public_ip : "No instance created"
}
