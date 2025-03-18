# To avoid repetitive code, you can use the `for_each` meta-argument along with a map to define your instances and their configurations. This approach allows you to manage multiple instances in a more concise and maintainable way.

### Example Configuration:

# ```hcl
provider "aws" {
  region = "us-west-2"
}

locals {
  instances = {
    instance1 = {
      ami           = "ami-12345678"
      instance_type = "t2.micro"
      volume_size   = 8
    }
    instance2 = {
      ami           = "ami-12345678"
      instance_type = "t2.small"
      volume_size   = 16
    }
    instance3 = {
      ami           = "ami-12345678"
      instance_type = "t2.medium"
      volume_size   = 32
    }
    instance4 = {
      ami           = "ami-12345678"
      instance_type = "t2.large"
      volume_size   = 64
    }
  }
}

resource "aws_instance" "example" {
  for_each = local.instances

  ami           = each.value.ami
  instance_type = each.value.instance_type

  tags = {
    Name = each.key
  }

  root_block_device {
    volume_size = each.value.volume_size
    volume_type = "gp2"
  }
}
# ```

### Explanation:
# 1. **Provider Block**: Specifies the AWS region.
# 2. **Local Variable**: Defines a map `instances` with the configurations for each instance.
# 3. **EC2 Instance Resource**: Uses the `for_each` meta-argument to iterate over the `instances` map and create an instance for each entry.
#    - **`ami`**: Set to `each.value.ami`.
#    - **`instance_type`**: Set to `each.value.instance_type`.
#    - **`tags`**: The `Name` tag is set to the key of the map entry (`each.key`).
#    - **`root_block_device`**: Configures the EBS volume size using `each.value.volume_size`.

# ### Steps to Apply:
# 1. Save the configuration to a file, e.g., `main.tf`.
# 2. Initialize Terraform:
#    ```sh
#    terraform init
#    ```
# 3. Plan the changes:
#    ```sh
#    terraform plan
#    ```
# 4. Apply the changes:
#    ```sh
#    terraform apply
#    ```

# This configuration will create four EC2 instances with different instance types and EBS volumes in a more concise and maintainable way. Let me know if you need any more help or adjustments!

# Breakdown

# Sure! Let's break down how `each.value` and `each.key` work in Terraform with an example.

### Example Configuration:

# ```hcl
provider "aws" {
  region = "us-west-2"
}

locals {
  instances = {
    instance1 = {
      ami           = "ami-12345678"
      instance_type = "t2.micro"
      volume_size   = 8
    }
    instance2 = {
      ami           = "ami-12345678"
      instance_type = "t2.small"
      volume_size   = 16
    }
    instance3 = {
      ami           = "ami-12345678"
      instance_type = "t2.medium"
      volume_size   = 32
    }
    instance4 = {
      ami           = "ami-12345678"
      instance_type = "t2.large"
      volume_size   = 64
    }
  }
}

resource "aws_instance" "example" {
  for_each = local.instances

  ami           = each.value.ami
  instance_type = each.value.instance_type

  tags = {
    Name = each.key
  }

  root_block_device {
    volume_size = each.value.volume_size
    volume_type = "gp2"
  }
}
# ```

### How `each.key` and `each.value` Resolve:

# 1. **`local.instances`**:
#    ```hcl
   {
     instance1 = {
       ami           = "ami-12345678"
       instance_type = "t2.micro"
       volume_size   = 8
     }
     instance2 = {
       ami           = "ami-12345678"
       instance_type = "t2.small"
       volume_size   = 16
     }
     instance3 = {
       ami           = "ami-12345678"
       instance_type = "t2.medium"
       volume_size   = 32
     }
     instance4 = {
       ami           = "ami-12345678"
       instance_type = "t2.large"
       volume_size   = 64
     }
   }
#    ```

# 2. **Iteration with `for_each`**:
#    - Terraform will iterate over each key-value pair in the `local.instances` map.

# 3. **First Iteration (`instance1`)**:
#    - **`each.key`**: `"instance1"`
#    - **`each.value`**: `{ ami = "ami-12345678", instance_type = "t2.micro", volume_size = 8 }`
#    - **Resolved Values**:
#      - `ami = "ami-12345678"`
#      - `instance_type = "t2.micro"`
#      - `tags = { Name = "instance1" }`
#      - `volume_size = 8`

# 4. **Second Iteration (`instance2`)**:
#    - **`each.key`**: `"instance2"`
#    - **`each.value`**: `{ ami = "ami-12345678", instance_type = "t2.small", volume_size = 16 }`
#    - **Resolved Values**:
#      - `ami = "ami-12345678"`
#      - `instance_type = "t2.small"`
#      - `tags = { Name = "instance2" }`
#      - `volume_size = 16`

# 5. **Third Iteration (`instance3`)**:
#    - **`each.key`**: `"instance3"`
#    - **`each.value`**: `{ ami = "ami-12345678", instance_type = "t2.medium", volume_size = 32 }`
#    - **Resolved Values**:
#      - `ami = "ami-12345678"`
#      - `instance_type = "t2.medium"`
#      - `tags = { Name = "instance3" }`
#      - `volume_size = 32`

# 6. **Fourth Iteration (`instance4`)**:
#    - **`each.key`**: `"instance4"`
#    - **`each.value`**: `{ ami = "ami-12345678", instance_type = "t2.large", volume_size = 64 }`
#    - **Resolved Values**:
#      - `ami = "ami-12345678"`
#      - `instance_type = "t2.large"`
#      - `tags = { Name = "instance4" }`
#      - `volume_size = 64`

### Summary:
# - **`each.key`**: Refers to the current key in the iteration (e.g., `"instance1"`, `"instance2"`).
# - **`each.value`**: Refers to the current value in the iteration, which is a map containing the instance configuration (e.g., `{ ami = "ami-12345678", instance_type = "t2.micro", volume_size = 8 }`).

# This approach allows you to dynamically create multiple instances with different configurations using a single, concise Terraform configuration file.

# Would you like more details or examples on any specific part of this process?