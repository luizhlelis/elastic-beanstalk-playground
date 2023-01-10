# AWS Elastic Beanstalk Infrastructure

## Pre-requisites

- Terraform
- AWS Account
- Service User on IAM with the following permissions:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "elasticbeanstalk:CreateApplication",
                "elasticbeanstalk:CreateApplicationVersion",
                "elasticbeanstalk:UpdateEnvironment",
                "elasticbeanstalk:ValidateConfigurationSettings"
            ],
            "Resource": "*"
        }
    ]
}
```

## Running commands

```shell
export AWS_ACCESS_KEY_ID="<your-access-key-here>"
export AWS_SECRET_ACCESS_KEY="<your-secret-key-here>"
export AWS_REGION="<your-aws-region-here>"
```

```shell
terraform plan
```