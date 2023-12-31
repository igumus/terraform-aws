# Definitions 

## What is Bastion Host ?
A bastion host, also known as a jump box or a jump server, acts as a fortified gateway between external networks (e.g., the internet) and internal private networks (private subnets). While this isolation adds an extra layer of security, it can pose challenges when administrators or developers require remote access for maintenance, debugging, or troubleshooting purposes. This is where a bastion host comes into play, it serves as a secure and controlled access point, allowing authorized users to connect to resources within the private network from remote locations. By acting as a single entry point, the bastion host minimizes the exposure of your internal network, reducing the attack surface and strengthening the overall security posture

## What is EC2 ?
Amazon Elastic Compute Cloud (EC2) is a part of Amazon Web Services (AWS), that allows users to rent virtual computers on which to run their own applications. EC2 encourages scalable deployment of applications by providing a web service through which a user can boot an Amazon Machine Image (AMI) to configure a virtual machine, which Amazon calls an "instance", containing any software desired. A user can create, launch, and terminate server-instances as needed, paying by the second for active servers – hence the term "elastic". EC2 provides users with control over the geographical location of instances that allows for latency optimization and high levels of redundancy.

## What is VPC ? 
Amazon Virtual Private Cloud (VPC) is a part of cloud computing service that provides a virtual private cloud, by provisioning a logically isolated section of Amazon Web Services (AWS) Cloud.

Amazon Virtual Private Cloud (VPC) enables you to launch AWS resources into a virtual network that you've defined. This virtual network closely resembles a traditional network that you'd operate in your own data center, with the benefits of using the scalable infrastructure of AWS.

### Key Concepts of VPC
- **Virtual private cloud (VPC)** : A virtual network dedicated to your AWS account.
- **Subnet** : A range of IP addresses in your VPC
- **Route table** : A set of rules (aka routes), that are used to determine where network traffic is directed.
- **Internet gateway** : A gateway that you attach to your VPC to enable communication between resources in your VPC and the internet.
- **VPC endpoint** : Enables you to privately connect your VPC to supported AWS services and VPC endpoint services powered by PrivateLink without requiring an internet gateway, NAT device, VPN connection or AWS Direct Connect connection.
- **CIDR block** : Classless Inter-Domain Routing (CIDR) notation is a way to represent an IP address and its network mask. 

## What is Security Group ?
A security group is a **virtual firewall** designed to protect AWS instances. It sits in front of designated instances and can be applied to **EC2**, **ELB (Elastic Load Balancing)** and **Amazon Relational Database Service**, among others. Security groups have distinctive rules for inbound and outbound traffic. The groups **allow all outbound traffic by default** and **deny any traffic not expressly allowed**. Security groups are also **stateful**, so all outbound traffic will be allowed back in. We can not block a specific IP address using security groups.

## What is Network Access Control List ? 
Network ACL (Access Control List) is a **virtual firewall for subnets**. It **allows** all the inbound or outbound IPv4 traffic and here we create a type of custom network all or each custom network ACL **denies** all inbound and outbound traffic. They are **stateless** and require you to clearly and properly define rules for both inbound and outbound traffic; otherwise, you might have connection issues within your environment. Network ACLs **cover entire subnets** and provide wide net protection that can encompass lots of resources at the same time. **In which all subnet in VPC must be combined with network ACL one subnet -one network ACL at a time.** 

## What is Application LoadBalancer ?
The Application Load Balancer distributes incoming HTTP and HTTPS traffic across multiple targets such as Amazon EC2 instances, microservices, and containers, based on request attributes. When the load balancer receives a connection request, it evaluates the listener rules in priority order to determine which rule to apply, and if applicable, it selects a target from the target group for the rule action. 

We can use an HTTPS listener to offload the work of TLS encryption and decryption to our load banacler. Healthy targets in one or more target groups receive traffic based on the load balancing algorithm, and the routing rules we specify in the listener.