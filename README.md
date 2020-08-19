# Okta Showcase Demo: Using the Okta ASA Terraform Provider on AWS

The following is an example of using [Terraform](https://www.terraform.io/) to deploy AWS infrastructure with Okta Advanced Server Access managing identities on Linux EC2 instances through a local agent that is installed via a userdata script.

[Advanced Server Access](https://www.okta.com/products/advanced-server-access/) is an Okta application that automates identity & access across distributed Linux and Windows server fleets, extending a seamless Single Sign-On experience to SSH and RDP workflows.

This code example deploys a new VPC (default: us-east-2) with a public and private subnet. In the public subnet, a single Ubuntu 16.04 EC2 instance is deployed as a bastion host, and in the private subnet, N (default: 3) Ubuntu 16.04 EC2 instances are deployed. In parallel, a new Okta ASA Project is created, and select Groups are assigned. The EC2 instances spun up are enrolled with the newly created Okta ASA Project, and the target instances are configured to hop through the bastion instance.

## Prerequisites

- An Okta Advanced Server Access Team
- An AWS account 
- Terraform 0.13

## Terraform Providers

- [AWS Provider](https://github.com/terraform-providers/terraform-provider-aws)
- [Okta Advanced Server Access Provider](https://github.com/oktadeveloper/terraform-provider-oktaasa)

## Setup

### Create an Okta ASA Service User

In order to interact with the Okta ASA API, you'll need to create a Service User. Service Users are non-human accounts that are authenticated against the API. This example creates resources via API, so the Service User must belong to a Group that has Admin rights. Follow this [documentation article](https://help.okta.com/en/prod/Content/Topics/Adv_Server_Access/docs/service-users.htm) to create a Service User and an API key. You will need the API key and secret as input variables for Terraform.

### Create an AWS IAM User

In order to create the VPC environment on AWS, you'll need an IAM user with full rights to VPC services and EC2. Follow [this documentation article](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html) to create an IAM User. You will need a key and secret for this user as input variables for Terraform.

## Input Variables

You'll need a number of input variables for this example to execute. Variables can be set as ENV variables locally, in a terraform.tfvars file, or via Terraform Cloud. The AWS and Okta credential input variables are sensitive, and should be stored in a secure location, and never published to a public repository.

### Okta Advanced Server Access

#### `oktaasa_key`, `oktaasa_secret`

The API key and secret for the Service User to interface with the Okta Advanced Server Access API

#### `oktaasa_team`

The name of your Okta Advanced Server Access Team (don't have one? [Sign up here](https://app.scaleft.com/p/signup).)

#### `oktaasa_project`

The name of the Project you would like to create. 

#### `oktaasa_groups`

A list of names of the Groups you would like to assign to the newly created Project. Note: these Groups must already exist in your Okta Advanced Server Access Team.

#### `sftd_version`

The version number of the Okta Advanced Server Access Server Agent (default: 1.44.6)

### Amazon Web Services

#### `access_key`, `secret_key`

The access key and secret for the AWS IAM User to create the AWS environment.

#### `name`

The Name tag value for the created resources

#### `environment`

The Environment tag value for the created resources

### Config

#### `instances`

The number of target EC2 instances to deploy in the private subnet (default: 3)

## Run the example

First, run the command `terraform init` to initialize the providers and modules used.

Then, run the command `terraform apply` and be sure to check Terraform's output for errors. Make sure your Terraform version is at least 0.13.

## Check the output

Give it a few minutes for the environment to spin up. The Okta Advanced Server Access Server Agent is installed via a userdata script included in this repository. When the service first starts up, it enrolls the instance with the newly created Project, and creates the respective local user and group accounts. The Server Agent then communicates with the backend API to get notified of any changes to user status or group membership.

You'll see in your Okta Advanced Server Access Dashboard that the new Project was created, and the Groups were assigned. Every member of the assigned Group is created a local Linux account on each downstream server. The EC2 instances are enrolled with the Project, which means that the users who belong to this Project can connect via SSH through the [Okta Advanced Server Access Client](https://help.okta.com/en/prod/Content/Topics/Adv_Server_Access/docs/sft.htm).

If you are logged into Okta and have the Client installed, from the CLI, you can see the newly created instances by running `sft list-servers`. Login to any one of the target hosts by running `sft ssh <target-instance>`. If your user account is authorized, you will be securely connected via SSH using a short-lived Client Certificate minted on-demand. You will be logged into the EC2 instance as your Okta user account, not a shared user account.








