FROM golang:1.15.14-alpine3.14 AS builder
ENV CGO_ENABLED=0

WORKDIR /go/stock-api
COPY src/stock-api/. .

RUN chmod +x restore.sh && ./restore.sh
RUN chmod +x build.sh  && ./build.sh

# app
FROM alpine:3.14 AS app

ENV POSTGRES_CONNECTION_STRING="host=products-db port=5432 user=postgres password=widgetario dbname=postgres sslmode=disable" \
    CACHE_EXPIRY_SECONDS="45" \
    GOLANG_VERSION="1.15.14" \
    APP_VERSION="0.4.0"

EXPOSE 8080
CMD ["/app/server"]

WORKDIR /cache
WORKDIR /app
COPY --from=builder /server .

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