# Provision an Elastic LoadBalancer in AWS
This project provisions an elastic loadbalancer in AWS.

## Pre-Requisites
```console
$ make init #initializes project
```

## Objectives
- Using Terraform HCL, create a custom elastic load balancer
- Create public and private subnet for each availability zone within your AWS Region
- Create public private route tables
- Associate public route table with public subnets, and private route table with private subnets
- Create web server in public and private subnets
- Create target group for instances (which in public and private subnets)
- Create elastic load balancer
- Attach loadbalancer with target group

## Quick Start
```console
$ make apply #applies project
```
By default, this command above try to provision an infrastructure with followings;
- Creates a custom vpc with name `main` and cidr `10.0.0.0/16`
- Creates 2 private 2 public subnets in `main` vpc
- Creates an `Elastic LoadBalancer`
- Creates 2 load balancer target group (one for public instances, and other one for private instances)
- Creates a load balancer listener;
    - Listens on `http 80`
    - Default listener rule whose default action is to route traffic to public target group
    - Custom rule to route %80 of inbound traffic to public target group, and %20 to private target group
- Creates 5 machine (two in public subnet, two in private subnet)
    -  AMI `Amazon Linux 2023 AMI` (with id `ami-01bc990364452ab3e`) 
    -  Type `t2.micro` 
    -  With generated `ssh keypair`
    - Machine#1 (`pub-machine-0`)
        - places in public subnet
        - accepts http traffic from loadbalancer
    - Machine#2 (`pub-machine-1`)
        - places in public subnet
        - accepts http traffic from loadbalancer
    - Machine#3 (`priv-machine-0`)
        - places in private subnet
        - accepts http traffic from loadbalancer
    - Machine#4 (`priv-machine-1`)
        - places in private subnet
        - accepts http traffic from loadbalancer

## Testing
```console
$ curl http://<loadBalancer-DNS-NAME>/
```

## Notes
You need to set environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.