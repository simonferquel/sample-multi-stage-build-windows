FROM microsoft/dotnet:1.1.1-sdk-nanoserver AS build-dotnet
WORKDIR /src/dotnet-app
COPY ./src/dotnet-app/dotnetapi.csproj /src/dotnet-app/dotnetapi.csproj
RUN dotnet restore
COPY ./src/dotnet-app /src/dotnet-app
RUN dotnet publish -c Release -r win10-x64 -o c:\\bin

FROM golang:1.8.0-nanoserver AS build-go
COPY ./src/go-app /src/go-app
WORKDIR /src/go-app
RUN go build

FROM microsoft/nanoserver
EXPOSE 80
COPY --from=build-dotnet c:\\bin c:\\dotnetapp
COPY --from=build-go c:\\src\\go-app\\go-app.exe c:\\go-app.exe
COPY ./run.bat c:\\run.bat
ENTRYPOINT C:\\run.bat
