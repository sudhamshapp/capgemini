terraform console then give it like <resource-type.resource-name>- this is like python3 on the cli
resource type and resource name
Your infrastructure matches the configuration
desired state is our configuration file and existing state is statefile

we have private key locally and copy the public key onto aws
we can store the statefile in a remote backend such as s3 bucket on aws, where any team member can access to it and manage the infrastructure
Terraform will use statefile each time when we do Terraform apply/plan/destoy (current state and desired state)
terraform.tfstate, terraform.tfstate.backup, terraform.lock.hcl


terraform show - gives information about statefile that we already provisioned

terraform state -h
terraform state list - show us list of all resources the statefile is managing - summary of all my resources that reside in my terraform statefile
terraform state show <resource-type.resource.name> <Basically renders the statefile in a easier to read manner>


Terraform uses the state file to determine the changes to make to your infrastructure so that it will match your configuration.

local variables are used to reduce repeating the same expressions or values over and over in your code

terraform init - initializes the backend/provider plugins initialize terraform working directory - it won't touches the statefile
terraform init -upgrade
terraform init -reconfigure
terraform version

terraform validate - validates configuration/checks whether the configuration syntactically valid

terraform plan - dry run/preview changes/generating a terraform plan/basically it reads existing statefile if one exists and lets us know whether its up to date

terraform plan -out <filename that we want to store our plan>
terraform plan -refresh-only - drift detection
  
terraform apply/ terraform apply -auto-approve

terraform destoy
terraform -version

terraform -help

code configuration block types include - terraform resource/provider/data/modules/input variable/local variable/output variable block

terraform variables has order of precedence

we can refer the variables.tf stuff in the locals block through interpolation

data block - helps terraform to go and query data and we can use the pulled in data in the terraform configuration 

modules - for modules the source could be local path or remote location where it's located

terraform output -json/ terraform output

provisioners - (remote-exec, local-exec and file provisioner)

terraform init -upgrade

terraform fmt - helps auto-format the terraform code
terraform fmt -recursive
/*
terraform taint  - Imagine you have an EC2 instance that has become unresponsive due to a software issue. You can use terraform taint to mark the instance for recreation:
terraform taint aws_instance.example
terraform apply
This will destroy the unresponsive instance and create a new one, ensuring that your infrastructure remains healthy and consistent.
Marking a resource instance as not fully fucntional
Basically it recreates the instance (destroys and provision a new one)
for any reason, if terraform won't successfully provision an instance it will taint a specific resource
terraform untaint - basically untaint a resource that is tainted
*/

the best alternate of terraform taint is terraform replace

terraform apply -replace=aws_instance.example - this basically destroys and provision new server (terraform taint is deprecated, that's why we must use terraform replace instead of terraform taint)

motto of terraform taint/replace is to replace and recreate the desired blocks

terraform import - associate the existing infra with a terraform configuration

terraform workspaces(new, list, show, select and delete)w.r.to Iac is to utilize the same code base for different environments(dev and prod)

terraform workspace new <arbitarynamethatyouwannagive>

terraform show - shows the infrastructure

in the tags block we can inlude this syntax

tags {
    Environment = terraform.workspace - this automatically resolves the workspace we're resided
}

Debugging terraform
export TF_LOG  = TRACE(we can setup TF_LOG to one of the log levels TRACE, debug, info, warn or error to change the verbosity of the logs, with trace being the most verbose)

to enable the logging path
export TF_LOG_PATH = "couldbeanyfilename.tx"
Disable logging
export TF_LOG=""
export TF_LOG_PATH=""
You are having trouble with executing Terraform and want to enable the most verbose logs. What log level should you set for the TF_LOG environment variable? - The answer is TRACE

====================================================
interview question to remove a specific resource
You are managing multiple resources using Terraform running in AWS. You want to destroy all the resources except for a single web server. How can you accomplish this?

To destroy all resources except for a single web server in Terraform, you can use the `terraform state rm` command to remove the resources you want to keep from the state file temporarily. This way, when you run `terraform destroy`, it will not affect the resources that are no longer in the state file. After the destruction, you can re-import the resources back into the state file.

### Steps to Accomplish This

1. **Identify the Resource to Keep**: Determine the resource you want to keep, for example, a web server.

2. **Remove the Resource from the State File**:
   ```sh
   terraform state rm aws_instance.web_server
   ```

3. **Destroy All Other Resources**:
   ```sh
   terraform destroy
   ```

4. **Re-import the Resource Back into the State File**:
   ```sh
   terraform import aws_instance.web_server <resource_id>
   ```

### Example

Assume you have the following resources defined in your Terraform configuration:

```hcl
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

resource "aws_instance" "db_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket"
  acl    = "private"
}
```

To keep only the `web_server` instance:

1. **Remove `web_server` from the state file**:
   ```sh
   terraform state rm aws_instance.web_server
   ```

2. **Destroy all other resources**:
   ```sh
   terraform destroy
   ```

3. **Re-import `web_server` back into the state file**:
   ```sh
   terraform import aws_instance.web_server <web_server_instance_id>
   ```

Replace `<web_server_instance_id>` with the actual instance ID of your web server.

This approach ensures that the `web_server` instance remains intact while all other resources are destroyed.

Would you like more details on any of these steps or have other questions about Terraform?

=====================================================================================================

terraform modules - Main way to package and re-use resource configuration within terraform   

modules are just terraform configuration inside a folder
terraform modules could be anything in the list mentioned - https://developer.hashicorp.com/terraform/language/modules/sources
local terraform module(various local paths), public module registry(others have created and shared publicly), source a module from github

terraform state default local backend

terraform.tfstate - is the standard statefile

terraform.tfstate.backup - backup of a statefile

terraform state locking - prevents concurrent modifications to a statefile which coould leads to corruption

Error acquiring the state lock - this command gets dislayed when a candiate A started terraform apply and in the process and candiate B got this error message

only single person has access to the statefile at any given time - aws s3 backend with ddb

aws s3 natively doesn't support statelocking, but in conjunction with ddb it does

we can migrate the statefile from local to any remote service(s3 bucket)

aws credenttial file and export the environment variables but shouldn't hard code the creds and commit into scm

we can give access to remote backend through IAM policies and s3 bucket policies

standard backends helps us store the statefile remotely while performing terraform operations locally via cli

s3 bucket versioning

we can have one remote backend for one working directory

state migration  - how to migrate the statefile from one backend to the another (terraform init -migrate-state)

local backend is the default backend

terraform refresh(configuration drift) - changes are made outside of terraform workflow

terraform refresh(it updates the statefile) then terraform apply(it reverts to the original state) to reconcile the the drift that was occurred/ instead of this we need to use terraform plan -refresh-only then terraform apply(to get the changeslinto the statefile)

Your organization has multiple engineers that have permission to manage Terraform as well as administrative access to the public cloud where these resources are provisioned. If an engineer makes a change outside of Terraform, what command can you run to detect drift and update the state file?(terraform apply -refresh-only)

local variables - 


secure secrets in terraform code - secrets could be username/password/access token, we shouldn't store the secrets in the plain text, we can mark the values to senstive in the variables and output block, we can use the environment variable to set the secret like this - export TF_VAR_nameofthevariablethatwewannagive=sensitivevalue, we can use the hashicorp vault as well

variable colection and structure types - string, number, bool, list, map(key,value)

string - "sudhamsh"

number - 18

bool - true/false

list - ["us-east-1a", "us-east-1b"] - these are sequence of values

map - {name = "sudhamsh", age = 28} - helps store key/value pairs

data block - query or fetch data from the existing resorces where we can use it in our terraform configuration

terraform built-in functions - https://developer.hashicorp.com/terraform/language/functions this has numeric, string, collection, encoding, filesystem, date and time, hash and crypto, ip network and type  conversion functions

terraform graph - visual representation of a configuration or execution plan, the command emits the stuff what was deployed into aws, we can check it visually on this site - http://webgraphviz.com/


terraform resource lifecycles - the order in which terraform creates and destroy the resources
i) create before destroy - the default behaviour in terraform is destroy the resource then create one
ii)use prevent destroy


terraform -install-autocomplete


terraform aws provider - multi region and alias - proviosions same infrastructure in the different regions
===============================**************************************=========================================

how can I deploy same configuration in different regions in terraform?
You need to define multiple provider configurations, each with a different region. Use the alias attribute to differentiate between them.

Define Multiple Providers
provider "aws" {
  region = "us-east-1"
  alias  = "us_east_1"
}

provider "aws" {
  region = "us-west-2"
  alias  = "us_west_2"
}

Use Providers in Resources

Specify the provider to use for each resource by using the provider attribute.


resource "aws_instance" "example_us_east_1" {
  provider = aws.us_east_1
  ami      = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}

resource "aws_instance" "example_us_west_2" {
  provider = aws.us_west_2
  ami      = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}


How do you manage state in Terraform?
Terraform uses state files to keep track of the resources it manages. You can store state locally or remotely using backend configurations like AWS S3, Azure Blob Storage, etc.

What are Terraform workspaces and how do they help?

Workspaces allow you to manage multiple environments (e.g., development, staging, production) within a single Terraform configuration.
Explain the concept of remote state and its benefits.

Remote state allows you to store your state file in a remote location, providing benefits like collaboration, security, and backup.

Explain the purpose of the terraform init command?
The terraform init command initializes a Terraform working directory by downloading and installing the necessary provider plugins.