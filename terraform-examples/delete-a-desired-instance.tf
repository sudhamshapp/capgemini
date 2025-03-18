# To delete a specific instance out of 10 instances provisioned with Terraform, you can use the `terraform destroy -target` command. This command allows you to target a specific resource for destruction without affecting the others.

### Steps to Delete a Specific Instance:

# 1. **Identify the Instance**: Determine the name of the instance you want to delete from your Terraform configuration.

# 2. **Run the Destroy Command**:
#    ```sh
#    terraform destroy -target aws_instance.example_instance - basically it's resource type and resource name
#    ```

### Example Configuration:

# Assume you have the following configuration with 10 instances:

# ```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example_instance1" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  tags = {
    Name = "example-instance1"
  }
}

resource "aws_instance" "example_instance2" {
  ami           = "ami-12345678"
  instance_type = "t2.small"

  tags = {
    Name = "example-instance2"
  }
}

# ... other instances ...

resource "aws_instance" "example_instance10" {
  ami           = "ami-12345678"
  instance_type = "t2.large"

  tags = {
    Name = "example-instance10"
  }
}
# ```

### To Delete `example_instance2`:

# 1. **Run the Command**:
#    ```sh
#    terraform destroy -target aws_instance.example_instance2
#    ```

# This command will destroy only the `example_instance2` without affecting the other instances[1](https://stackoverflow.com/questions/54314312/destroy-an-ec2-instance-in-terraform)[2](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/aws-destroy).

# ### Explanation:
# - **`-target`**: Specifies the resource to be destroyed.
# - **`aws_instance.example_instance2`**: The name of the instance you want to delete.

# ### Additional Considerations:
# - **State File**: Ensure your Terraform state file is up-to-date and reflects the current state of your infrastructure.
# - **Dependencies**: If the instance has dependencies, Terraform will handle the destruction order to respect those dependencies.

# Would you like more details or help with any specific part of this process?