# Difference between Security Group and Network ACL in AWS

| Security Group         | Network ACL     |
|------------------------|-----------------|
| Statefull              | Stateless       |
| Instance level         | Subnet level    |
| Supports only allow rules | Supports both allow and deny rules |
| All rules are evaluated before deciding to permit traffic.| Rules are processed in number order when deciding whether allow traffic. |
| First layer of defense for outbound/egress traffic. | Second layer of defense for outbound/egress traffic. |
| Second layer of defense for inbound/ingress traffic. | First layer of defense for inbound/ingress traffic. |
| Security groups are associated with an instance of a service. It can be associated with one or more security groups which has been created by the user. | Multiple subnets can be bound with a single NACL, but one subnet can be bound with a single NACL only, at a time. |