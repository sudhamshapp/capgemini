locals {
  team = "Dev-team"
  appplication = "Automation"
  server_name = "ec2-${var.thiscouldbeanything} - api -${var.thiscomefrominputvariableblock}"
}


locals {
  planet = "earth"
  alternate_planet = "mars"
  essential = "water"
}

locals {
  common_tags = {
    team = "Dev-team"
    appplication = "Automation"
    server_name = "ec2-${var.thiscouldbeanything} - api -${var.thiscomefrominputvariableblock}"
    planet = "earth"
    alternate_planet = "mars"
    essential = "water"

  }
}

resource "aws_instance" "web-server" {
    ami = "qwertyui12345678"
    instance_type = "t2.micro"
    tags = local.common_tags
}