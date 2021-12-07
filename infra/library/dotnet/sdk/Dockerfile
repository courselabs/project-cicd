FROM mcr.microsoft.com/dotnet/sdk:3.1.415-alpine3.14

# Sonar Scanner & JRE dep:
RUN apk add --no-cache openjdk11-jre
RUN dotnet tool install --tool-path /usr/bin dotnet-sonarscanner