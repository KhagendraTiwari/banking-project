provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "prodserver" {
  ami           = "ami-0866a3c8686eaeeba"  # Replace with your desired AMI ID
  instance_type = "t2.micro"                # Choose your instance type
  key_name      = "ktkey"                   # Replace with your key pair name

  tags = {
    Name = "prodserver"
  }
}

output "prodserver_public_ip" {
  value = aws_instance.prodserver.public_ip
}
