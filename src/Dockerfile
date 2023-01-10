# using ubuntu distro `6.0-jammy`
FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy AS PUBLISH_STAGE
WORKDIR /build
ADD SampleApp.Web ./SampleApp.Web
ADD SampleApp.Infrastructure ./SampleApp.Infrastructure
ADD SampleApp.Application ./SampleApp.Application
# Update the runtime to linux-x64 if you're running it on a machine with AMD64 chip
RUN dotnet publish SampleApp.Web/SampleApp.Web.csproj -r linux-arm64 -o bin -c Release

FROM mcr.microsoft.com/dotnet/aspnet:6.0-jammy AS RUNTIME_STAGE
WORKDIR /app
COPY --from=PUBLISH_STAGE /build/bin ./