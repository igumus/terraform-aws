# How To 

## Retrieve instance metadata ?
Because your instance metadata is available from your running instance, you do not need to use the Amazon EC2 console or the AWS CLI. This can be helpful when you're writing scripts to run from your instance. For example, you can access the local IP address of your instance from instance metadata to manage a connection to an external application.

Instance metadata is divided into [categories](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instancedata-data-categories.html).
To view all categories of instance metadata from within a running instance, use the following;

### IPv4
```
http://169.254.169.254/latest/meta-data/
```
The IP addresses are **link-local addresses** and are **valid only from the instance**. 

```console
$ TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"` 
$ curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/
```

### Costs
You are not billed for HTTP requests used to retrieve instance metadata and user data.