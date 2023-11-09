# Provision a VPC in AWS
This project provisions a custom VPC in AWS. 

## Pre-Requisites
```console
$ make init #initializes project
```

## Objectives
- Using Terraform HCL, create a custom VPC
- Create public and private subnets for each availability zone within your AWS Region
- Create public and private route tables
- Associate public route table with public subnets
- Associate private route table with private subnets
- Create an internet gateway
- Create a NAT gateway with elastic IP
- Create a bastion host to limit ssh connections

## Quick Start
```console
$ make apply #applies project
```
By default, this command above try to provision an infra with followings;
- Creates a custom vpc with name `main` and cidr `10.0.0.0/16`
- Creates 3 security groups (`sg_instance`, `sg_bastion_host`, `sg_bastion_client`)
    - `sg_instance`: allows ingress http, and all egress traffic
    - `sg_bastion_host`: allows ssh from internet, allows egress ssh traffic to instances that `sg_bastion_client` security group attached
    - `sg_bastion_client`: allows ssh from `sg_bastion_host`, allows egress traffic to anywhere
- Creates 3 private 3 public subnets in `main` vpc
- For public subnet;
    - Creates an internet gateway to access internet (named `main`)
    - Creates a route table (`main-public-rtb`)
    - Adds a internet access route to the route table 
    - Associates the route table with the public subnets
- For private subnet;
    - Creates an nat gateway (named `main`)
    - Creates a route table (`main-private-rtb`)
    - Adds `forward 0.0.0.0/0 to nat gateway` route to the route table 
    - Associates the route table with the private subnets
- Creates 4 machine (two in public subnet, two in private subnet)
    -  AMI `Amazon Linux 2023 AMI` (with id `ami-01bc990364452ab3e`) 
    -  Type `t2.micro` 
    -  With generated `ssh keypair`
    - Machine#1 (`machine-bastion`):
        - places in public subnet
        - Has `sg_bastion_host` security group attached
    - Machine#2 (`machine-public`)
        - places in public subnet
        - Has `sg_bastion_client` and `sg_instance` security groups attached
    - Machine#3 (`machine-private`)
        - places in private subnet
        - Has `sg_bastion_client` security group attached
    - Machine#4 (`machine-private-no-bastion`)
        - places in private subnet
        - Has `sg_instance` security group attached

## Testing
```console
$ scp -i "./keys/tut002.pem" keys/tut002.pem ec2-user@<machine-bastion-PUBLIC-IP>:~/
$ ssh -i "./keys/tut002.pem"  ec2-user@<machine-bastion-PUBLIC-IP>
```
- [x] ssh to `machine-public` should not work
- [x] able to ssh to `machine-bastion`
- [x] able to `curl http://<machine-public-PUBLIC-IP>`
- [x] able to ssh from `machine-bastion` to `machine-public`
- [x] able to ssh from `machine-bastion` to `machine-private`
- [x] not able to ssh from `machine-bastion` to `machine-private-no-bastion`
- [x] able to ping from `machine-bastion` to `google.com`
- [x] able to ping from `machine-public` to `google.com`
- [x] able to ping from `machine-private` to `google.com`
- [x] `machine-private-no-bastion` should not accessible from net or `machine-bastion`
- [x] able to ping from `machine-private-no-bastion` to `google.com` (if it is accessible)

## Notes
You need to set environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.