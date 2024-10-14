provider "aws" {
  region = "us-east-2"
}

data "aws_instances" "existing_testserver" {
  filter {
    name   = "tag:Name"
    values = ["testserver"]
  }
}

resource "aws_instance" "testserver" {
  count = length(data.aws_instances.existing_testserver.ids) == 0 ? 1 : 0

  ami           = "ami-0ea3c35c5c3284d82"  # Replace with actual AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "testserver"
  }
}

output "testserver_ip" {
  value = length(aws_instance.testserver) > 0 ? aws_instance.testserver[0].public_ip : "No instance created"
}
