# AWS Elastic Beanstalk Infrastructure

## Pre-requisites

- Terraform;
- AWS Account;
- Create an user on IAM with the following permissions: `AmazonEC2FullAccess`, `AmazonS3FullAccess`, `AdministratorAccess-AWSElasticBeanstalk`, `AWSAppRunnerServicePolicyForECRAccess`, `EC2InstanceProfileForImageBuilderECRContainerBuilds`;
- Create IAM Role for `EC2` as `AWS Service` and attach `AWSElasticBeanstalkWebTier`, `AWSElasticBeanstalkMulticontainer`, `AWSElasticBeanstalkWorkerTier` and `AmazonEC2ContainerRegistryReadOnly` policies to it. The IAM role should be named as `aws-elasticbeanstalk-ec2-role`.

## Running commands

```shell
export AWS_ACCESS_KEY_ID="<your-access-key-here>"
export AWS_SECRET_ACCESS_KEY="<your-secret-key-here>"
export AWS_REGION="<your-aws-region-here>"
```

```shell
terraform init
```

```shell
terraform plan -out plan-output
```

```shell
terraform apply plan-output
```