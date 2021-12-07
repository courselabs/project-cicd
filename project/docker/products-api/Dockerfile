FROM maven:3.6.3-jdk-11 AS builder
ARG SONAR_PROJECT='widgetario-products-api'
ARG SONAR_URL='http://sonarqube:9000'
ARG SONAR_TOKEN=''
ARG SONAR_ENFORCE_GATE='false'

WORKDIR /usr/src/api
COPY src/products-api/. .

RUN chmod +x restore.sh && ./restore.sh
RUN chmod +x build.sh  && ./build.sh

RUN if [ "$SONAR_TOKEN" != "" ] ; then \
        mvn sonar:sonar \
        -Dsonar.projectKey=h$SONAR_PROJECT \
        -Dsonar.host.url=$SONAR_URL \
        -Dsonar.login=$SONAR_TOKEN \
        -Dsonar.qualitygate.wait=$SONAR_ENFORCE_GATE ; \
    fi

# app
FROM openjdk:11.0.12-jre-slim-buster AS app

WORKDIR /app
COPY --from=builder /usr/src/api/target/products-api-0.1.0.jar .

EXPOSE 80
ENTRYPOINT ["java", "-jar", "/app/products-api-0.1.0.jar"]

ENV JRE_VERSION="11.0.12" \
    APP_VERSION="0.4.0"

# CVE scanner
FROM app AS scan
COPY --from=aquasec/trivy:0.21.1 /usr/local/bin/trivy /usr/local/bin/trivy
RUN trivy rootfs -s HIGH --exit-code 1 --no-progress

# final image
FROM app as final

ARG BUILD_VERSION=local
ARG GIT_COMMIT=local
LABEL build_version=${BUILD_VERSION}
LABEL commit_sha=${GIT_COMMIT}