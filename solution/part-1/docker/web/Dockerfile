FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS builder

WORKDIR /src
COPY src/web/ .

RUN chmod +x restore.sh && ./restore.sh
RUN chmod +x build.sh  && ./build.sh

# app image
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine

ENV Widgetario__ProductsApi__Url="http://products-api/products" \
    Widgetario__StockApi__Url="http://stock-api:8080/stock" \
    DOTNET_VERSION="6.0" \
    APP_VERSION="1.0.0"

ENTRYPOINT ["dotnet", "/app/Widgetario.Web.dll"]

WORKDIR /app
COPY --from=builder /out/ .