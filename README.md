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



## References

-[Semantic Versioning](https://semver.org/)<sup>[1]</sup>

-[Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)<sup>[2]</sup>

-[Checking for Linux Flavor](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)<sup>[3]</sup>

-[Making Linux Script Portable](https://www.cyberciti.biz/tips/finding-bash-perl-python-portably-using-env.html)<sup>[4]</sup>

-[Changing Permissions](https://www.pluralsight.com/blog/it-ops/linux-file-permissions)<sup>[5]</sup>

-[Gitpod Workspace Lifecycle](https://www.gitpod.io/docs/configure/workspaces/tasks)<sup>[6]</sup>
