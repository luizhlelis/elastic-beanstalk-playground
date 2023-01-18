# elastic-beanstalk-playground

🫘 Just playing a bit with AWS Elastic Beanstalk for containers

## Pre requisites

- [.NET 6.0](https://dotnet.microsoft.com/en-us/download): to run, build, test the project locally;
- [dotnet-ef tool](https://docs.microsoft.com/en-us/ef/core/cli/dotnet): to create new migrations;
- [Docker](https://www.docker.com/products/docker-desktop/): to run everything inside containers.

## Running commands

To up all the app and dependencies containerized, type the following command in the [src](./src) folder:

```shell
docker-compose up --build
```

> **NOTE:** the command above will up the web application, SqlServer and will execute all the existing migrations.
> That's enough to run everything, but even though, if you want to run the app locally using containerized dependencies,
> you must try the commands below.

To run the SqlServer, type the following command in
the [src](./src) folder:

```shell
docker-compose up sql-server-database
```

To up the existent migrations in SqlServer, type the following command in
the [src](./src) folder:

```shell
docker-compose up --build migrations
```

> **NOTE:** there are two docker-compose files, one to run locally, and another one to be deployed in Elastic Beanstalk [infra/docker-compose.yml](infra/docker-compose.yml)

If you want to create a new migration (after an entity model update, for example), type the following command in
the [root](./) folder:

```shell
dotnet ef migrations add <migration-name> --project src/SampleApp.Infrastructure/SampleApp.Infrastructure.csproj --startup-project src/SampleApp.Web/SampleApp.Web.csproj --context SampleAppContext --verbose
```

To run all the automated test, type the following command in the [src](./src) folder:

```shell
dotnet test
```

If you're running the app in docker, open the following link in your browser:

```shell
http://localhost/swagger/index.html
```

Otherwise, if you're running it locally, the port will be different:

```shell
https://localhost:7211/swagger/index.html
```

## Running commands to elastic beanstalk deploy

Retrieve an authentication token and authenticate your Docker client to your registry. Use the AWS CLI:

```shell
aws ecr get-login-password --region <your-aws-region> | docker login --username AWS --password-stdin <your-aws-account-id>.dkr.ecr.us-east-1.amazonaws.com
```

> **NOTE:** If you receive an error using the AWS CLI, make sure that you have the latest version of the AWS CLI and Docker installed.

Build your Docker image using the following command. For information on building a Docker file from scratch see the instructions here . You can skip this step if your image is already built:

```shell
docker build -t sample-app-api .
```

> **NOTE:** if you're using a machine with AMD64 chip (M1/M2) the process is different, take a look at the steps below.

If you're using a machine with AMD64 chip (M1/M2), then update [Dockerfile](src/Dockerfile) publish step to `-r linux-x64`, and instead of the command above, run the following one:

```shell
docker build -t sample-app-api . --platform amd64
```

After the build completes, tag your image so you can push the image to this repository:

```shell
docker tag sample-app-api:latest <your-aws-account-id>.dkr.ecr.us-east-1.amazonaws.com/sample-app-api:latest
```

Run the following command to push this image to your newly created AWS repository:

```shell
docker push <your-aws-account-id>.dkr.ecr.us-east-1.amazonaws.com/sample-app-api:latest
```

Now, you must repeat the same steps for `sample-app-api-migrations`:

```shell
docker build -t sample-app-api-migrations -f Dockerfile.migrations . --platform amd64
docker tag sample-app-api-migrations:latest <your-aws-account-id>.dkr.ecr.us-east-1.amazonaws.com/sample-app-api-migrations:latest
docker push <your-aws-account-id>.dkr.ecr.us-east-1.amazonaws.com/sample-app-api-migrations:latest
```

> Note: for more information on how to set up `nginx` configuration, take a look at [this documentation](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/platforms-linux-extend.html).

## Credentials

There are two pre-created users (created as seed in migrations). You can use the following credentials to login with each one them:

```json
{
  "username": "admin-user",
  "password": "StrongPassword@123"
}
```

```json
{
  "username": "customer-user",
  "password": "StrongPassword@123"
}
```

## Design and Architecture decisions

- Rich Domain Models (behaviors inside the domain entities)

- [Hexagonal architecture](https://alistair.cockburn.us/hexagonal-architecture/)

![hexagonal architecture](./assets/hexagonal.png)

> Font: [Hexagonal Architecture, there are always two sides to
> every story](https://medium.com/ssense-tech/hexagonal-architecture-there-are-always-two-sides-to-every-story-bc0780ed7d9c)

Follow bellow how the `Application` layer was concept:

```shell
\
┣ Application
┃ ┣ 📂 Commands (all commands to trigger this layer)
┃ ┣ 📂 Dtos
┃ ┣ 📂 Ports (ports from hexagonal architecture)
┃ ┣ 📂 Domain
┃    ┣ 📂 Entities (DB entities with behaviors: Rich Domain Models)
┃    ┣ 📂 Enums
┃    ┣ 📂 Handlers (complex behaviors: involves more than one entity)
┃    ┣ 📂 Validators (all validations to prevent incorrect data to travel through other layers)
┃    ┣ 📂 ValueObjects (represents a value and has no identity)
```
