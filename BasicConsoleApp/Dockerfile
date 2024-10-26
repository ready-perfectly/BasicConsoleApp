FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /opt/src
COPY . ./
RUN dotnet restore
RUN dotnet publish -c Release -o /opt/publish


# Build runtime image
FROM mcr.microsoft.com/dotnet/runtime:8.0
WORKDIR /opt/app
COPY --from=build-env /opt/publish .
ENTRYPOINT ["dotnet", "BasicConsoleApp.dll"]