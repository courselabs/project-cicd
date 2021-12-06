FROM postgres:11.6-alpine

COPY src/db/init-products-db.sh /docker-entrypoint-initdb.d/

ENV POSTGRES_PASSWORD=widgetario

ARG BUILD_VERSION=local
ARG GIT_COMMIT=local
LABEL BUILD_VERSION=${BUILD_VERSION}
LABEL commit_sha=${GIT_COMMIT}