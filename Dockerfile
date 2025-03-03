# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base

WORKDIR /app

EXPOSE 80

EXPOSE 443

EXPOSE 5000

ENV ASPNETCORE_URLS=http://+:5000

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build

WORKDIR /src

COPY . .

RUN dotnet restore "WebAPI/WebAPI.csproj"

WORKDIR "/src/."

RUN dotnet build "WebAPI/WebAPI.csproj" -c Release -o /app/build

FROM build AS publish

RUN dotnet publish "WebAPI/WebAPI.csproj" -c Release -o /app/publish

FROM base AS final

WORKDIR /app

COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "WebAPI.dll"]
