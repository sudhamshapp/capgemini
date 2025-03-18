variable "thiscouldbeanything" { # this is through variable.tf file
    description = "cidr block for AZ"
    type = string
    default = "10.0.202.0/24"
}
# when we wanna override the above stuff through cli, we can do it like this - export TF_VAR_thiscouldbeanything = 10.0.202.0/24 then do a terraform plan(basically it takes the precedence over the default value)
# then thiscouldbeanyfilename.tfvars have the precedence over the above stuff
# terraform apply -var variables_sub_az="us-east-1e" -var variables_sub_cidr="10.0.203.0/24" - this will take precedence over the above stuff

# variable<enviroment variable<tfvars<cli