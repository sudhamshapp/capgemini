resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo ${aws_instance.example.public_ip} >> ips.txt"
  }
}


# The local-exec provisioner runs commands on the machine where Terraform is executed. This can be useful for tasks like running local scripts or commands.
# In this example, the public IP of the created EC2 instance is appended to a local file ips.txt.

