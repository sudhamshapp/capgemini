/*
The file provisioner copies files or directories from the machine running Terraform to the newly created resource.

In this example, a local file config.cfg is copied to the /tmp directory on the remote server.
*/

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  provisioner "file" {
    source      = "config.cfg"
    destination = "/tmp/config.cfg"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host        = self.public_ip
    }
  }
}