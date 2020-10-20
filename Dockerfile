FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .

COPY ActionsTest/*.csproj ./ActionsTest/
RUN dotnet restore ActionsTest

# copy everything else and build app
COPY ActionsTest ./ActionsTest/
WORKDIR /app/ActionsTest
RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/core/aspnet:3.1

WORKDIR /app

COPY --from=build /app/ActionsTest/out ./

ENTRYPOINT ["dotnet", "ActionsTest.dll"]

EXPOSE 80
EXPOSE 443
# docker build -t kyamamoto03/vg-server:latest .
#単体実行は docker run -it --rm -p 12345:12345 -p 5000:80 -e GenbaAppFolder="/genbaapp" -v c:\genbaapp:/genbaapp --name vg-server kyamamoto03/vg-server:latest /bin/bash