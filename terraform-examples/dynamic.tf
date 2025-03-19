# dynamic blocks acts much like a for loop
# this is the standard way of creating sg
resource "aws_security_group" "main" {
    name = "core-sg"
    vpc_id = aws_vpc.vpc.id
    ingress {
        description = "Port 443"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "Port 80"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
# Convert Security Group to use dynamic block

locals {
    ingress_rules = [{
    port = 443
    description = "Port 443"
    },
    {
    port = 80
    description = "Port 80"
    }
    ]
}
resource "aws_security_group" "main" {
    name = "core-sg"
    vpc_id = aws_vpc.vpc.id
    dynamic "ingress" {
        for_each = local.ingress_rules  # we can use the variable block or local block for this dynamic stuff
        content {
        description = ingress.value.description
        from_port = ingress.value.port
        to_port = ingress.value.port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    }
}