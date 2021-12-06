FROM postgres:11.6-alpine

COPY src/db/init-products-db.sh /docker-entrypoint-initdb.d/

ENV POSTGRES_PASSWORD=widgetario