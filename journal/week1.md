<<<<<<< Updated upstream
=======
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



## References

- [Workspace Variables for Terraform Cloud](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/variables#variables) <sup>[1]</sup>

- [Input Variables](https://developer.hashicorp.com/terraform/language/values/variables) <sup>[2]</sup>

- [Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure) <sup>[3]</sup>

>>>>>>> Stashed changes
