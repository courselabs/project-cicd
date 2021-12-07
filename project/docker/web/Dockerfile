FROM widgetario/dotnet:sdk:20.12 AS builder

ARG SONAR_PROJECT='widgetario-web'
ARG SONAR_URL='http://sonarqube:9000'
ARG SONAR_TOKEN=''
ARG SONAR_ENFORCE_GATE='false'

WORKDIR /src
COPY src/web/ .

RUN chmod +x restore.sh && ./restore.sh

RUN if [ "$SONAR_TOKEN" != "" ] ; then cd src && dotnet sonarscanner begin /k:$SONAR_PROJECT /d:sonar.host.url=$SONAR_URL /d:sonar.login=$SONAR_TOKEN /d:sonar.qualitygate.wait=$SONAR_ENFORCE_GATE ; fi
RUN chmod +x build.sh  && ./build.sh
RUN if [ "$SONAR_TOKEN" != "" ] ; then cd src && dotnet sonarscanner end /d:sonar.login=$SONAR_TOKEN ; fi

# app image
FROM widgetario/dotnet:aspnet-20.12 AS app

ENV Widgetario__ProductsApi__Url="http://products-api/products" \
    Widgetario__StockApi__Url="http://stock-api:8080/stock" \
    DOTNET_VERSION="3.1" \
    APP_VERSION="1.0.0" \
    Widgetario__Theme="dark"

ENTRYPOINT ["dotnet", "/app/Widgetario.Web.dll"]

WORKDIR /app
COPY --from=builder /out/ .

# CVE scanner
FROM app AS scan
ARG TRIVY_SCAN='0'
COPY --from=aquasec/trivy:0.21.1 /usr/local/bin/trivy /usr/local/bin/trivy
RUN if [ "$TRIVY_SCAN" = "1" ] ; then \
      trivy rootfs -s HIGH --exit-code 1 --no-progress / ; \
    fi

# final image
FROM app as final

ARG BUILD_VERSION=local
ARG GIT_COMMIT=local
LABEL build_version=${BUILD_VERSION}
LABEL commit_sha=${GIT_COMMIT}