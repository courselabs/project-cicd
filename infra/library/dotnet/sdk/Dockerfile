FROM mcr.microsoft.com/dotnet/sdk:6.0.100-alpine3.14

# Sonar Scanner & JRE dep:
RUN apk add --no-cache openjdk11-jre
RUN dotnet tool install --tool-path /usr/bin dotnet-sonarscanner