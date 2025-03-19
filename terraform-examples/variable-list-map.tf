variable "listofazs" {
    type = list(string)
    default = [ "us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
  
}

variable "ip" {
    type = map(string)
    default = {
      "prod" = "10.0.150.0/24", 
      "dev" = "10.0.151.0/24"

    }

}

variable "env" { # nested map
    type = map(any)
    default = {
        prod = {
            ip = "10.0.150.0/24", az = "us-east-1a"
        }
        dev = {
            ip = "10.0.151.0/24", az = "us-east-1b"
        }

    }  
}

resource "aws_subnet" "reference-from-above-variable" { # this is for list
  vpc_id = aws_vpc.thiscouldbeanything.id
  cidr_block = "10.0.0.200/24"
  availability_zone = var.listofazs[0]
}


resource "aws_subnet" "reference-from-above-variable" { # this is for map, we are hard coding it here
  vpc_id = aws_vpc.thiscouldbeanything.id
  cidr_block = var.ip["prod"]
  availability_zone = var.listofazs[0]
}

resource "aws_subnet" "reference-from-above-variable" { # this is the dynamic approach using for loop, we can use mix of each.key and each.value based on the situation
  for_each = var.ip
  vpc_id = aws_vpc.thiscouldbeanything.id
  cidr_block = each.value
  availability_zone = var.listofazs[0]
}

resource "aws_subnet" "reference-from-above-variable" { # this is example for nested map with variable env, note - not using the list
  for_each = var.env # it's completely referencing variable block "env"
  vpc_id = aws_vpc.thiscouldbeanything.id
  cidr_block = each.value.ip # here it is referecing varible block with env values i.e.,(each.value is prod and dev respectively)
  availability_zone = each.value.az
}
