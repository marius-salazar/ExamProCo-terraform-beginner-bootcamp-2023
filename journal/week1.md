# Terrafom Beginner Bootcamp 2023 - Week 1

## Terraform and Input Variables

### Terraform Cloud Variables
We can set two types of variables in Terraform Cloud namely: [<sup>[1]</sup>](#references)

- **Environment Variables** - those that are set in bash terminal e.g AWS credentials
- **Terraform Variables** - those that are use as input variables to define parameters usually set in .tfvars file.

We can set Terraform Cloud variables to be __sensitive__ to that they are not shown in the UI.

### Loading Terraform Input Variables

We can load Terraform Variables through the following method: [<sup>[2]</sup>](#references)

- **Using the `-var` flag** - We can use the `-var` flag when running terraform command in the terminal to set an input variable or override a variable in the .tfvars file e.g. `terraform plan -var user_uuid="my-user-uuid"`

- **Using the `-var-file` flag** - We can also use the `-var-file` flag when running terraform command to set multiple variables in a _variable definitions file_ that has an extension of `.tfvars` or `.tfvars.json`. e.g. `terraform plan -var-file="varfile.tfvars"`

-**Using `terraform.tfvars` and `.auto.tfvars`** - By creating a __variable definitions file__ that has a name of `terraform.tfvars` or `any-file-name.auto.tfvars`, terraform will automatically load the variables.

### Variables Definition Precedence in Terraform

Terraform loads variable in the following order: [<sup>[2]</sup>](#references)

1. Environment Variable
2. The `terraform.tfvars` file, if present
3. The `terraform.tfvars.json` file, if present
4. Any `.auto.tfvars` or `.auto.tfvars.json` files, in lexical order of their filename
5. Any -var and -var-file options on the command line, in the order they are provided.

## Root Module Structure

The root module structure is as follows: [<sup>[3]</sup>](#references)
```
PROJECT_ROOT
│
├── main.tf                 # everything else.
├── variables.tf            # stores the structure of input variables
├── terraform.tfvars        # the data of variables we want to load into our terraform project
├── providers.tf            # defined required providers and their configuration
├── outputs.tf              # stores our outputs
└── README.md               # required for root modules
```

## Dealing with Configuration Drift

### What will happen if you loose your state file

If you loose your state file you need to tear down your cloud infrastructure manually. 

You can use `terraform import` but it will not work for all resources so you need to check on terraform providers documentation to which it is supported.

### Fix Manual Configuration

If someone accidentally delete or modifies cloud resources manually through clickOPs, we can fix it by running `terraform plan`.

Terraform plan will compare the state of our infrastructure to the expected state thus fixing _configuration drift_

Then run `terraform apply` to make the changes take effect and restore the state of our infrastructure.

### Fix Missing Resources with  Terraform Import

Another way of dealing with configuration drift is to use terraform import. [<sup>[4]</sup>](#references)

We can run this through this command, 

```sh
$ terraform import aws_s3_bucket.website_bucket bucket-name
```

or incorporate it as a code block like this:

```sh

import {
  to = aws_s3_bucket.bucket
  id = "bucket-name"
}

```




## References

- [Workspace Variables for Terraform Cloud](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables#variables) <sup>[1]</sup>

- [Input Variables](https://developer.hashicorp.com/terraform/language/values/variables) <sup>[2]</sup>

- [Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure) <sup>[3]</sup>

- [Terraform Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import) <sup>[4]</sup>


