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
By default, this command above try to provision an instance with followings;
- Creates a custom vpc with name `main` and cidr `10.0.0.0/16`
- Creates a security group (`allow_http_ssh`) to limit access to instances.
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
    - Machine#1 (`bastion`):
        - places in public subnet
        - Has `allow_ssh` security group attached (accepts ssh connection from internet, connects only instances which has `allow_ssh_from_bastion` security group)
    - Machine#2 (`machine-public`)
        - places in public subnet
        - Has `allow_http` and `allow_ssh_from_bastion` security groups attached
    - Machine#3 (`machine-private`)
        - places in private subnet
        - Has only `allow_ssh_from_bastion` security group attached
    - Machine#4 (`machine-private-no-bastion`)
        - places in private subnet
        - Has no `allow_ssh_from_bastion` security group attached

## Testing
Machines;
- `bastion`  : (`bastion`) which runs inside public subnet.
- `machine1` : (`machine-public`)  which runs inside public subnet, has public ip, can access to internet.
- `machine2` : (`machine-private`) which runs inside private subnet, has no public ip, no access to internet.
- `machine3` : (`machine-private-no-bastion`) which runs inside private subnet, has no public ip, no access to internet, with no ssh allowed.

```console
$ scp -i "./keys/tut002.pem" keys/tut002.pem ec2-user@<bastion-PUBLIC-IP>:~/
$ ssh -i "./keys/tut002.pem"  ec2-user@<bastion-PUBLIC-IP>
```
- [x] ssh to bastion host
- [x] ssh to `machine1` from `bastion`
- [x] install `nginx` and make sure nginx is working. Browse `http://<machine1-PUBLIC-IP>` address.
- [x] try to ssh to other machines from `machine1` (cannot establish any connection)
- [x] ssh to `machine2` from `bastion`
- [x] try to ssh to other machines from `machine2` (cannot establish any connection)
- [x] ssh to `machine3` from `bastion` (you cannot establish any connection to the machine. Because security group `allow_ssh_from_bastion` not attached to the machine)

## Notes
You need to set environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.