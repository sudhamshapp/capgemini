# terraform output thiscoouldbeanything - it shows the value on the console despite it's a secret
output "thiscouldbeanything" {
    description = "this retrieves public ip of the instance"
    value = resource-type.resource-name.public_ip
    sensitive = true
}