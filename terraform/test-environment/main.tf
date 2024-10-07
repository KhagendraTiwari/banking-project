provider "aws" {
  region = "us-east-1"
}

# Data source to check if the test instance already exists
data "aws_instance" "existing_testserver" {
  # Use a filter to find an existing instance by its name tag
  filter {
    name   = "tag:Name"
    values = ["testserver"]
  }
}

resource "aws_instance" "testserver" {
  count         = length(data.aws_instance.existing_testserver.*.id) == 0 ? 1 : 0  # Create only if it doesn't exist
  ami           = "ami-0866a3c8686eaeeba"  # Replace with your desired AMI ID
  instance_type = "t2.micro"                # Choose your instance type
  key_name      = "ktkey"                   # Replace with your key pair name

  tags = {
    Name = "testserver"
  }
}

output "testserver_public_ip" {
  value = length(aws_instance.testserver) > 0 ? aws_instance.testserver[0].public_ip : "No instance created"  # Handle case when instance does not exist
}
