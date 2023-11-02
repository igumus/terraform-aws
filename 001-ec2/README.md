# Provision an EC2 instance in AWS
This project provisions an EC2 instance in AWS.

## Introduction
Amazon Elastic Compute Cloud (EC2) is a part of Amazon Web Services (AWS), that allows users to rent virtual computers on which to run their own applications. EC2 encourages scalable deployment of applications by providing a web service through which a user can boot an Amazon Machine Image (AMI) to configure a virtual machine, which Amazon calls an "instance", containing any software desired. A user can create, launch, and terminate server-instances as needed, paying by the second for active servers – hence the term "elastic". EC2 provides users with control over the geographical location of instances that allows for latency optimization and high levels of redundancy.

## Pre-Requisites
```console
$ make init #initializes project
$ make keygen #generates ssh keys
```

## Objectives
- Using Terraform HCL, query default VPC
- Create keypair for connecting to instance
- Create security group for limiting inbound traffic
- Associate keypair with instance
- Associate security group with instance
- Create instance in default VPC

## Quick Start
```console
$ make apply #applies project
```
By default, this command above try to provision an instance with followings;
-  Name `machine`
-  AMI `Amazon Linux 2023 AMI` (with id `ami-01bc990364452ab3e`) 
-  Type `t2.micro` 
-  Zone `us-east-1a`
-  With generated `ssh keypair`
-  Member of a security group `allow_http_ssh` (which created via this configuration)

The AMI ID, zone, and type can all be set as variables. You can also set the name variable to determine the value set for the Name tag.

## Testing
```console
$ ssh -i "./keys/tut001.pem"  <USER>@<PUBLIC-IP-OF-INSTANCE>
```
After connection established;
- [x] `ssh connection` and `ingress rule` are verified.
- [x] `ping google.com` should work
- [x] install `nginx` and make sure nginx is working. After browse `http://<PUBLIC-IP-OF-INSTANCE>` address and you should see nginx welcome page. 


## Notes
You need to set environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.