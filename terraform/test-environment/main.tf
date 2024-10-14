provider "aws" {
  region = "us-east-1"
}

data "aws_instances" "existing_testserver" {
  filter {
    name   = "tag:Name"
    values = ["testserver"]
  }
}

resource "aws_instance" "testserver" {
  count = length(data.aws_instances.existing_testserver.ids) == 0 ? 1 : 0

  ami           = "ami-12345678"  # Replace with actual AMI ID
  instance_type = "t2.micro"

  tags = {
    Name = "testserver"
  }
}
