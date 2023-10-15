# Terraform Beginner Bootcamp 2023

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