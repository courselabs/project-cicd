FROM mcr.microsoft.com/dotnet/sdk:3.1-alpine AS sdk

# Sonar Scanner CLI needs JRE:
ARG OPENJDK_VERSION='11.0.13_p8-r0'
RUN apk add --no-cache \
    openjdk11-jre=${OPENJDK_VERSION}

# Install the scanner:
RUN dotnet tool install --tool-path /usr/bin dotnet-sonarscanner

FROM sdk AS builder
ARG SONAR_PROJECT='widgetario-web'
ARG SONAR_URL='http://sonarqube:9000'
ARG SONAR_TOKEN=''
ARG SONAR_ENFORCE_GATE='false'

WORKDIR /src
COPY src/web/ .

RUN chmod +x restore.sh && ./restore.sh

RUN if [ "$SONAR_TOKEN" != "" ] ; then dotnet sonarscanner begin /k:$SONAR_PROJECT /d:sonar.host.url=$SONAR_URL /d:sonar.login=$SONAR_TOKEN /d:sonar.qualitygate.wait=$SONAR_ENFORCE_GATE ; fi
RUN chmod +x build.sh  && ./build.sh
RUN if [ "$SONAR_TOKEN" != "" ] ; then dotnet sonarscanner end /d:sonar.login=$SONAR_TOKEN ; fi

# app image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine

ENV Widgetario__ProductsApi__Url="http://products-api/products" \
    Widgetario__StockApi__Url="http://stock-api:8080/stock" \
    DOTNET_VERSION="3.1" \
    APP_VERSION="1.0.0" \
    Widgetario__Theme="dark"

ENTRYPOINT ["dotnet", "/app/Widgetario.Web.dll"]

WORKDIR /app
COPY --from=builder /out/ .

ARG BUILD_VERSION=local
ARG GIT_COMMIT=local
LABEL build_version=${BUILD_VERSION}
LABEL commit_sha=${GIT_COMMIT}