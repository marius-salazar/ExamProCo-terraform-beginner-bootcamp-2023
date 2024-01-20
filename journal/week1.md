# Terrafom Beginner Bootcamp 2023 - Week 1

## Fixing Tags

If you messed up tagging your commits you can fix it by deleting your tags. You can delete local tag or remotely by using the following command: [<sup>[1]</sup>](#references)


- Deleting Local Git Tags

```sh
$ git tag -d <tag_name>
```
For example:

```sh
$ git tag -d v1.0
Deleted tag 'v1.0' (was 808b598)
```

- Deleting Remote Tags

```
$ git push --delete origin tagname
```
For example:

```
$ git push --delete origin v1.0

To https://github.com/SCHKN/repo.git
 - [deleted]         v1.0
```

Checkout the commit that you want to retag. Grab the SHA from your GitHub histroy

```sh
git checkout <SHA>
git tags M.M.P
git push --tags
git checkout main
```

## Terraform and Input Variables

### Terraform Cloud Variables
We can set two types of variables in Terraform Cloud namely: [<sup>[2]</sup>](#references)

- **Environment Variables** - those that are set in bash terminal e.g AWS credentials
- **Terraform Variables** - those that are use as input variables to define parameters usually set in .tfvars file.

We can set Terraform Cloud variables to be __sensitive__ to that they are not shown in the UI.

### Loading Terraform Input Variables

We can load Terraform Variables through the following method: [<sup>[3]</sup>](#references)

- **Using the `-var` flag** - We can use the `-var` flag when running terraform command in the terminal to set an input variable or override a variable in the .tfvars file e.g. `terraform plan -var user_uuid="my-user-uuid"`

- **Using the `-var-file` flag** - We can also use the `-var-file` flag when running terraform command to set multiple variables in a _variable definitions file_ that has an extension of `.tfvars` or `.tfvars.json`. e.g. `terraform plan -var-file="varfile.tfvars"`

-**Using `terraform.tfvars` and `.auto.tfvars`** - By creating a __variable definitions file__ that has a name of `terraform.tfvars` or `any-file-name.auto.tfvars`, terraform will automatically load the variables.

### Variables Definition Precedence in Terraform

Terraform loads variable in the following order: [<sup>[3]</sup>](#references)

1. Environment Variable
2. The `terraform.tfvars` file, if present
3. The `terraform.tfvars.json` file, if present
4. Any `.auto.tfvars` or `.auto.tfvars.json` files, in lexical order of their filename
5. Any -var and -var-file options on the command line, in the order they are provided.

## Root Module Structure

The root module structure is as follows: [<sup>[4]</sup>](#references)
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

Another way of dealing with configuration drift is to use terraform import. [<sup>[5]</sup>](#references)

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

### Fix Using Terraform Refresh

Terraform Refresh run an apply command but only locally.

```tf
terraform apply -refresh-only -auto-approve

```
## Terraform Modules

### Terraform Module Structure

A module should be place in a `modules` directory when locally developing modules but you can name it whatever you like.

### Passing Input Variable

We can pass input variable to our module.

The module has to declare the terraform variables in its own variable.tf.

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Module Sources

Using source we can import the modules from various places e.g. [<sup>[6]</sup>](#references)

- locally
- Github
- Terraform Registry 


```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```


## Considerations when using ChatGPT to write terraform modules

LLMs such as ChatGPT may not be trained on the latest documentation or information about terraform, so it may produce an older examples that are deprecated often affecting providers.


## Working with Files in Terraform

### Path Variable

In Terraform there is a special variable called `path` that allows us to reference local path. [<sup>[7]</sup>](#references)

- **path.module** = get the path of the current module
- **path.root** = get the path of the root module of the configuration
- **path.cwd** = is the filesystem path of the original working directory from where you ran Terraform before applying any -chdir argument.
- **terraform.workspace** = is the name of the currently selected workspace.

### Fileexist Function
 It is a built-in terraform function that can be use to check the existence of a file. [<sup>[8]</sup>](#references)

Example:

```tf
 validation {
    condition     = fileexists (var.index_html_filepath)
    error_message = "The provided path for index.html does not exist."
  }
```
 In the code above the fileexists was used to check if the file **index_html_filepath** is existing.


### Etag and Filemd5

In our terraform module main.tf file, we used an Etag in the resource block of creating an aws_s3_object.

An Etag is used to track changes on the contents of the object uploaded to S3 bucket. It uses an md5 that hashes the contents of a given file. For example if the contents of index.html are change, then it will compare it the previous hashes of the same file does knowing if there are changes to the contents of the file. [<sup>[9]</sup>](#references)

## References



- [Deleting Local and Remote Tags on GIT](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/) <sup>[1]</sup>

- [Workspace Variables for Terraform Cloud](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables#variables) <sup>[2]</sup>

- [Input Variables](https://developer.hashicorp.com/terraform/language/values/variables) <sup>[3]</sup>

- [Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure) <sup>[4]</sup>

- [Terraform Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import) <sup>[5]</sup>

- [Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources) <sup>[6]</sup>

- [Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info) <sup>[7]</sup>

- [Fileexist Function](https://developer.hashicorp.com/terraform/language/functions/fileexists) <sup>[8]</sup>

- [Filemd5](https://developer.hashicorp.com/terraform/language/functions/filemd5) <sup>[9]</sup>