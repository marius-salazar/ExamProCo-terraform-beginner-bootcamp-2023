# Terraform Beginner Bootcamp 2023 - Week 0

- [Semantic Versioning](#semantic-versioning)
- [Terraform CLI Installation](#terraform-cli-installation)
  * [Terraform CLI changes](#terraform-cli-changes)
  * [Creation of Bash Script](#creation-of-bash-script)
  * [Changing the Permission of the Bash Script](#changing-the-permission-of-the-bash-script)
  * [Gitpod Workspace Lifecycle](#gitpod-workspace-lifecycle)
- [Working with Environment Variables (env vars)](#working-with-environment-variables--env-vars-)
  * [Setting up Environment Variables](#setting-up-environment-variables)
  * [Unsetting Environment Variables](#unsetting-environment-variables)
  * [Printing Environment Variables](#printing-environment-variables)
  * [Environment Variables Scope](#environment-variables-scope)
  * [Making Environment Variable Persist in Gitpod](#making-environment-variable-persist-in-gitpod)
- [AWS CLI Installation](#aws-cli-installation)
  * [Installing AWS CLI using the Bash Script](#installing-aws-cli-using-the-bash-script)
  * [Configuring AWS Environment Variables and Checking for AWS Credentials](#configuring-aws-environment-variables-and-checking-for-aws-credentials)
- [Terraform Basics](#terraform-basics)
  * [Terraform Registry](#terraform-registry)
  * [Terraform Console](#terraform-console)
  * [Terraform Init](#terraform-init)
  * [Terraform Plan](#terraform-plan)
  * [Terraform Apply](#terraform-apply)
  * [Terraform Destroy](#terraform-destroy)
  * [Terraform Lock File](#terraform-lock-file)
  * [Terraform State File](#terraform-state-file)
  * [Terraform Directory](#terraform-directory)
- [Terraform Cloud](#terraform-cloud)
  * [Terraform Login](#terraform-login)
  * [Using Bash Script to Generate tfrc file](#using-bash-script-to-generate-tfrc-file)
- [Git Stash](#git-stash)
- [~/.bash_profile](#--bash-profile)
- [References](#references)




## Semantic Versioning

Semantic versioning will be use for tagging on this project. [<sup>[1]</sup>](#references)

Given a version number **MAJOR**.**MINOR**.**PATCH**, increment the:

**MAJOR** version when you make incompatible API changes

**MINOR** version when you add functionality in a backward compatible manner

**PATCH** version when you make backward compatible bug fixes

Basically the format will be like this: `0.1.0`


## Terraform CLI Installation

### Terraform CLI changes

Modified the script in the Gitpod Task File ([.gitpod.yml](.gitpod.yml)) that automate the process of installing Terraform CLI because of gpg keyring changes. Followed the instruction from the terraform website.[<sup>[2]</sup>](#references)

Based on the terraform documentation, you need to identify what flavor of OS you are going to install it into. In this case we are using Linux but in order to identify what flavor it is you can use the command " `cat /etc/os-release` ".[<sup>[3]</sup>](#references)

After running the command `cat /etc/os-release` the result shoud looked like this:

```sh
$ cat /etc/os-release

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Creation of Bash Script

Due to changes in installation procedure I created a new Terraform CLI bash script for the installation command and made it portable using the "`#!/usr/bin/env bash`" as a shebang.[<sup>[4]</sup>](#references)


Note: While creating the bash script I encountered a permission error which looked like this after running the command:

```bash
$ gpg --no-default-keyring \fault-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
```
 The resulting error:
```bash
gpg: failed to create temporary file '/usr/share/keyrings/.#lk0x000055a37160cde0.mariussalaz-terraformbe-zjdk43qqhko.6420': Permission denied
gpg: keyblock resource '/usr/share/keyrings/hashicorp-archive-keyring.gpg': Permission denied
```

![Permission Error](https://github.com/marius-salazar/terraform-beginner-bootcamp-2023/blob/main/assets/Permission%20error%20when%20installing%20the%20terraform%20cli.png)


The solution to this is to add ``sudo`` before the command:

```bash
$ sudo gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint
```

The result after fixing using `sudo` :
```bash
gpg: keybox '/usr/share/keyrings/hashicorp-archive-keyring.gpg' created
gpg: directory '/root/.gnupg' created
gpg: /root/.gnupg/trustdb.gpg: trustdb created
```

![Permission Error workaround](https://github.com/marius-salazar/terraform-beginner-bootcamp-2023/blob/main/assets/Permission%20error%20workaround.png)

The final script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli) which looked like this:

```sh
#!/usr/bin/env bash

sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

sudo gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt-get install terraform -y

terraform --version


```

### Changing the Permission of the Bash Script

In order to make the bash script executable without typing the `source`  command we need to change the permission of the file using `chmod` command.[<sup>[5]</sup>](#references)

Before modifying the permission of the bash script it looked like this:

```sh
$ ls -alh ./bin/install_terraform_cli

-rw-r--r-- 1 gitpod gitpod 603 Oct 14 09:38 ./bin/install_terraform_cli
```
 This is shown by using the  `ls -alh ./bin/install_terraform_cli` command as shown above. Take note that the file is non executable as the permission implies.



 Thus we need to change it to make it an executable file using the command `chmod 744 ./bin/install_terraform_cli`. And it will look like this:

 ```sh
 $ chmod 744 ./bin/install_terraform_cli
 $ ls -alh ./bin/install_terraform_cli

 -rwxr--r-- 1 gitpod gitpod 603 Oct 14 09:38 ./bin/install_terraform_cli
 ```

Notice that after running the command above the user permission was changed into an executable file as indicated by the letter 'x'.


### Gitpod Workspace Lifecycle

Take note of the changes in gitpod workspace lifecycle. Use `before` instead of `init` in your [.gitpod.yml](.gitpod.yml) file.[<sup>[6]</sup>](#references)


This is how it looked before the modification:

```yml
tasks:
  - name: terraform
    init: |
      sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
      curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
      sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
      sudo apt-get update && sudo apt-get install terraform
  - name: aws-cli
    env:
      AWS_CLI_AUTO_PROMPT: on-partial
    init: |
      cd /workspace
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      unzip awscliv2.zip
      sudo ./aws/install
      cd $THEIA_WORKSPACE_ROOT
vscode:
  extensions:
    - amazonwebservices.aws-toolkit-vscode
    - hashicorp.terraform
```


This is when the changes was implemented:

```yml
tasks:
  - name: terraform
    before: |
      source ./bin/install_terraform_cli
  - name: aws-cli
    env:
      AWS_CLI_AUTO_PROMPT: on-partial
    before: |
      cd /workspace
      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
      unzip awscliv2.zip
      sudo ./aws/install
      cd $THEIA_WORKSPACE_ROOT
vscode:
  extensions:
    - amazonwebservices.aws-toolkit-vscode
    - hashicorp.terraform
```

## Working with Environment Variables (env vars)

### Setting up Environment Variables

Environment variables are predetermined values that are typically used to provide the ability to configure a value in your code from outside of your application.[<sup>[7]</sup>](#references)

We can list out all env vars by using the `env` command.[<sup>[8]</sup>](#references)

If you want to filter out specific env vars you can pipe `|` the `env` into a `grep` command.[<sup>[8]</sup>](#references) e.g. `env | grep hello`


In order to set env vars you can use the command `export` in the terminal. [<sup>[9]</sup>](#references)

For example:

```sh
$ export hello='World'
```

### Unsetting Environment Variables

If you want to unset the created env vars you use the `unset` command in the terminal. [<sup>[10]</sup>](#references)

For example:

```sh
$ unset hello
```

### Printing Environment Variables

We can print env vars by using the `echo` command in the terminal. e.g. `echo $hello`


### Environment Variables Scope

Env Vars set in one terminal is not carried over to another terminal or a newly opened terminal.

In order for it to be globally available in all bash terminals and future bash terminals you need to set env vars in your bash profile.[<sup>[10]</sup>](#references)


### Making Environment Variable Persist in Gitpod

We can make env vars persist in gitpod by storing them in Gitpod Secrets Storage.[<sup>[11]</sup>](#references)

```sh
$ gp env hello='World'

```

All future workspaces that will be launch will set the env vars for all bash terminals


## AWS CLI Installation

### Installing AWS CLI using the Bash Script

We are going to install AWS CLI using bash script. First I created a new file in the bin directory named [install_aws_cli](install_aws_cli). We will put our bash script in this file which consist of the instructions on how to install the AWS CLI on Linux x86 specifically.[<sup>[12]</sup>](#references)


### Configuring AWS Environment Variables and Checking for AWS Credentials

In order to grant access to AWS CLI for our AWS Account we need to use an access keys that is generated from IAM user. We can do this through AWS Environment Variables.[<sup>[13]</sup>](#references)

To check if our AWS credentials is configured correctly we can run the command [<sup>[14]</sup>](#references):

```sh
aws sts get-caller-identity
```

The result should look similar to this format:

```json
{
    "UserId": "AKIAIOSFODNN7EXAMPLE",
    "Account": "122333444555",
    "Arn": "arn:aws:iam::122333444555:user/marsala-tfboot"
}
```

## Terraform Basics

**Terraform** is an Infrastructure as a Code (Iac) software tool that is used to automate infrastructure provisioning and resource management in the cloud or data center. Its configuration uses a _declarative language_ which means that you define the end state that you want to achieve instead of the steps on how to get it done. [<sup>[15]</sup>](#references) 

### Terraform Registry

If you want to browse for Terraform resources and modules you can find it at [registry.terraform.io](https://registry.terraform.io/).

-**Providers** is an interface to APIs that will allow to create resources in terraform.

This is an example of a _provider_ code in terraform: [<sup>[16]<sup>](#references)

```json

terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

provider "random" {
  # Configuration options
}

```


-**Modules** are Terraform configuration _templates_ to make things easier, modular and portable.

This is an example of a _module_ code block in terraform: [<sup>[17]</sup>](#references)

```json

module "s3-bucket_example_complete" {
  source  = "terraform-aws-modules/s3-bucket/aws//examples/complete"
  version = "3.15.1"
}
```

### Terraform Console

If you want to browse the list of Terraform commands you can run `terraform` in the console.


### Terraform Init

In every new project in Terraform we should run the `terraform init` command in order to prepare our working directory for other commands. It will download the binaries of the terraform providers that we will use in the project.

This is how the it looked like after running `terraform init` in the console:

```sh

$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/random versions matching "3.5.1"...
- Installing hashicorp/random v3.5.1...
- Installed hashicorp/random v3.5.1 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```


### Terraform Plan

After initializing terraform we can now run `terraform apply` to audit the resources to be provisioned and if you have done some changes in the previous infrastructure e.g. you added/deleted new resources, it will all be shown on the console.

For example after running `terraform plan` that console will show something like this:

```sh

$ terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_string.bucket_name will be created
  + resource "random_string" "bucket_name" {
      + id          = (known after apply)
      + length      = 16
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + numeric     = true
      + result      = (known after apply)
      + special     = false
      + upper       = true
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + random_bucket_name = (known after apply)

```


### Terraform Apply

By running `terraform apply` terraform will start provisioning the resources that was shown in `terraform plan` and all the changes that has been made. Terraform will prompt us for approval when this command is run but we can automate it by adding --auto-approve flag like shown below.

The result will look similar to this:

```sh

$ terraform apply --auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # random_string.bucket_name will be created
  + resource "random_string" "bucket_name" {
      + id          = (known after apply)
      + length      = 16
      + lower       = true
      + min_lower   = 0
      + min_numeric = 0
      + min_special = 0
      + min_upper   = 0
      + number      = true
      + numeric     = true
      + result      = (known after apply)
      + special     = false
      + upper       = true
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + random_bucket_name = (known after apply)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

random_string.bucket_name: Creating...
random_string.bucket_name: Creation complete after 0s [id=a8PdW3RzpuHlyQbn]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

random_bucket_name = "a8PdW3RzpuHlyQbn"

```

### Terraform Destroy

`terraform destroy` command will destroy the resources that was created e.g. S3 buckets.


### Terraform Lock File

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used for this project.

Terraform Lock File **should be committed** to your version control system e.g. GitHub.


### Terraform State File


`.terraform.tfstate` contain information about the current state of your infrastructure. This **should not be committed** to your version control system because it can contain sensitive data. Losing this file means you won't be able to know the current state of your infrastrucure!


`.terraform.tfstate.backup` it contains information about the previous file state.


### Terraform Directory

`.terraform` directory contains binaries o the terraform providers.



## Terraform Cloud

### Terraform Login

Upon running the command `terraform login` a token is being asked to proceed. By following this link [tokens](https://app.terraform.io/app/settings/tokens?source=terraform-login) you can generate a new token to be used.

At first I encountered an error from the generated token. What I did is I cancelled the very first prompt that appeared and proceed to click the **Create an API token** button. The generated token was then entered to the prompt in the bash terminal.

However we can also manually create a file in a specific directory in order not to enter the token to the prompt everytime we run terraform login.

To create the file and put it on the specific directory which is `/home/gitpod/.terraform.d` we can use this command:

```sh
touch /home/gitpod/.terraform.d/credentials.tfrc.json
```

Then open the file using this command:

```sh
open /home/gitpod/.terraform.d/credentials.tfrc.json
```

After opening the file replace the token with the generated value.

```json
{
  "credentials": {
    "app.terraform.io": {
      "token": "YOUR-TERRAFORM-CLOUD-TOKEN"
    }
  }
}
```

### Using Bash Script to Generate tfrc file

In order to automate the process of generating a token to login in terraform cloud we have created a bash script to do this. Which look like this:

[/bin/generate_tfrc_credentials](/bin/generate_tfrc_credentials)

```sh
#!/usr/bin/env bash

# Define target directory and file
TARGET_DIR="/home/gitpod/.terraform.d"
TARGET_FILE="${TARGET_DIR}/credentials.tfrc.json"

# Check if TERRAFORM_CLOUD_TOKEN is set
if [ -z "$TERRAFORM_CLOUD_TOKEN" ]; then
    echo "Error: TERRAFORM_CLOUD_TOKEN environment variable is not set."
    exit 1
fi

# Check if directory exists, if not, create it
if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
fi

# Generate credentials.tfrc.json with the token
cat > "$TARGET_FILE" << EOF
{
  "credentials": {
    "app.terraform.io": {
      "token": "$TERRAFORM_CLOUD_TOKEN"
    }
  }
}
EOF

echo "${TARGET_FILE} has been generated."
```




## Git Stash

If you forget to create a new issue and you were working all along on the main branch, you can utilize the `git stash save` to temporarily save your changes while you tried to switch into to your new branch.

Supposed that you already created the new branch, you can type `git pull` then `git fetch` and `git add .` in your main branch to be up to date. Now after that you can now use the `git stash save` command to temporarily store your changes in the main branch and transfer it later to the supposed to be branch that you should be working on.

Then proceed to switching branch by using `git checkout **name of the branch**`. Finally you can now restore your changes that your worked on in the main branch into to the supposed designated branch by using the command `git stash apply` in your bash terminal.

## ~/.bash_profile

If you made changes in ~/.bash_profile it will not take effect right away unless you reload it. In order to do that we can run the command `source ~/.bash_profile`.

For example after setting the alias for terraform using `alias tf="terraform"` in the `.bash_profile` we can run `source ~/.bash_profile` to make the changes take effect right away.


## References

-[Semantic Versioning](https://semver.org/) <sup>[1]</sup>

-[Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) <sup>[2]</sup>

-[Checking for Linux Flavor](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/) <sup>[3]</sup>

-[Making Linux Script Portable](https://www.cyberciti.biz/tips/finding-bash-perl-python-portably-using-env.html) <sup>[4]</sup>

-[Changing Permissions](https://www.pluralsight.com/blog/it-ops/linux-file-permissions) <sup>[5]</sup>

-[Gitpod Workspace Lifecycle](https://www.gitpod.io/docs/configure/workspaces/tasks) <sup>[6]</sup>

-[Environment Variables](https://www.freecodecamp.org/news/what-are-environment-variables-and-how-can-i-use-them-with-gatsby-and-netlify/) <sup>[7]</sup>

-[Listing Env Vars](https://www.cyberciti.biz/faq/linux-list-all-environment-variables-env-command/) <sup>[8]</sup>

-[Setting up Env Vars](https://www.twilio.com/blog/how-to-set-environment-variables-html) <sup>[9]</sup>

-[Unsetting Env Vars](https://www.tecmint.com/set-unset-environment-variables-in-linux/) <sup>[10]</sup>

-[Persisting Env Vars using Gitpod Secret Storage](https://www.gitpod.io/docs/configure/projects/environment-variables) <sup>[11]</sup>

-[Installing AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) <sup>[12]</sup>

-[AWS Environment Variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html) <sup>[13]</sup>

-[AWS get-caller-identity](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/sts/get-caller-identity.html) <sup>[14]</sup>

-[Terraform](https://www.terraform.io/) <sup>[15]</sup>

-[Terraform Random Provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs) <sup>[16]</sup>

-[Terraform-aws-modules/s3 bucket](https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest/examples/complete) <sup>[17]</sup>
