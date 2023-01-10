data "aws_elastic_beanstalk_solution_stack" "multi_docker" {
  most_recent = true
  name_regex  = "^64bit Amazon Linux 2 (.*) running Docker(.*)$"
}

resource "aws_elastic_beanstalk_application" "sample-app-api" {
  name        = "sample-app-api"
  description = "tf-test-desc"
}

resource "aws_elastic_beanstalk_environment" "sample-app-api-production" {
  name                = "production"
  application         = aws_elastic_beanstalk_application.sample-app-api.name
  solution_stack_name = data.aws_elastic_beanstalk_solution_stack.multi_docker.id
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
}