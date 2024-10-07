provider "aws" {
  region = "ap-south-1"  # Update the region if necessary
}

resource "aws_instance" "testserver" {
  ami           = "ami-0866a3c8686eaeeba"  # Replace with your desired AMI ID
  instance_type = "t2.micro"      # Choose your instance type
  key_name      = "ktkey" # Replace with your key pair name

  tags = {
    Name = "testserver"
  }
}

resource "aws_instance" "prodserver" {
  ami           = "ami-0866a3c8686eaeeba"  # Replace with your desired AMI ID
  instance_type = "t2.micro"      # Choose your instance type
  key_name      = "ktkey" # Replace with your key pair name

  tags = {
    Name = "prodserver"
  }
}

output "testserver_public_ip" {
  value = aws_instance.testserver.public_ip
}

output "prodserver_public_ip" {
  value = aws_instance.prodserver.public_ip
}
