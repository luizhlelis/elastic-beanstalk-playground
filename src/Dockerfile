# using ubuntu distro `6.0-jammy`
FROM mcr.microsoft.com/dotnet/sdk:6.0-jammy AS PUBLISH_STAGE
WORKDIR /build
ADD SampleApp.Web ./SampleApp.Web
ADD SampleApp.Infrastructure ./SampleApp.Infrastructure
ADD SampleApp.Application ./SampleApp.Application
ADD Scripts ./scripts
# Update the runtime to linux-x64 if you're running it on a machine with AMD64 chip
RUN dotnet publish SampleApp.Web/SampleApp.Web.csproj -r linux-arm64 -o bin -c Release
RUN ls -all

FROM mcr.microsoft.com/dotnet/aspnet:6.0-jammy AS RUNTIME_STAGE
WORKDIR /app
COPY --from=PUBLISH_STAGE /build/bin ./
COPY --from=PUBLISH_STAGE /build/scripts ./
EXPOSE 80
CMD [ "./wait-for-it.sh", "sql-server-database:1433", "-t", "20", "--", "./start-app.sh" ]
