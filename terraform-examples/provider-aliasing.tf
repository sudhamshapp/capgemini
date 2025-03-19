provider "aws" {
  alias = "east"
  region = "us-east-1"
}

provider "aws" {
  alias = "west"
  region = "us-west-2"
}

resource "aws_instance" "webserver" {
  provider = aws.east
  ami = "qwertyui234567890"
  instance_type = "t2.micro"
}

resource "aws_instance" "webserver-west" {
  provider = aws.west
  ami = "qwertyui234567890"
  instance_type = "t2.micro"
}