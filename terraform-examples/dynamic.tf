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



# The `ingress.value.from_port` is part of the dynamic block in Terraform, which iterates over the `var.ingress_rules` list. Each element in this list is an object containing the `from_port`, `to_port`, `protocol`, and `cidr_blocks` attributes. The `ingress.value` refers to the current element in the iteration.

# Here's a breakdown of how it works:

# 1. **Variable Definition**: The `ingress_rules` variable is defined as a list of objects.
#    ```hcl
   variable "ingress_rules" {
     type = list(object({
       from_port   = number
       to_port     = number
       protocol    = string
       cidr_blocks = list(string)
     }))
     default = [
       {
         from_port   = 80
         to_port     = 80
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
       },
       {
         from_port   = 443
         to_port     = 443
         protocol    = "tcp"
         cidr_blocks = ["0.0.0.0/0"]
       }
     ]
   }
#    ```

# 2. **Dynamic Block**: The `dynamic "ingress"` block iterates over `var.ingress_rules`.
#    ```hcl
   dynamic "ingress" {
     for_each = var.ingress_rules
     content {
       from_port   = ingress.value.from_port
       to_port     = ingress.value.to_port
       protocol    = ingress.value.protocol
       cidr_blocks = ingress.value.cidr_blocks
     }
   }
#    ```

# In this setup:
# - `for_each = var.ingress_rules` tells Terraform to iterate over each element in the `ingress_rules` list.
# - `ingress.value` refers to the current element in the iteration.
# - `ingress.value.from_port` accesses the `from_port` attribute of the current element.

# So, when Terraform processes the dynamic block, it will replace `ingress.value.from_port` with the actual value from the corresponding element in the `ingress_rules` list.

# If you have any more questions or need further clarification, feel free to ask!