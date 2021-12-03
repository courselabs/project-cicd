#!/bin/sh

cd src
dotnet publish -c Release -o /out Widgetario.Web.csproj --no-restore