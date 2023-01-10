resource "aws_elastic_beanstalk_application" "sample-app-api" {
  name        = "sample-app-api"
  description = "tf-test-desc"
}

resource "aws_elastic_beanstalk_environment" "sample-app-api-production" {
  name                = "production"
  application         = aws_elastic_beanstalk_application.sample-app-api.name
  solution_stack_name = "Docker Running on 64bit Amazon Linux 2"
}