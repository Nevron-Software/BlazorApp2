# get sdk:6.0 (the actual os) and name it build
# Note! We don't need to get asp.net core runtime image 
# since the app will bi hosted on linux nginx server
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
#set working directory
WORKDIR /src
# copy the project file into the working directory
COPY BlazorApp2.csproj .
# run dotnet restore on the for the project in the container
RUN dotnet restore BlazorApp2.csproj
copy everything from the local folder to the container working folder
COPY . .
# build the app in release mode
RUN dotnet build BlazorApp2.csproj -c Release -o /app/build
# publish the app in release mode
FROM build AS publish
RUN dotnet publish BlazorApp2.csproj -c Release -o /app/publish

# get and install the nginx web server
FROM nginx:alpine AS final
# sett the working directory - this is where the app will live.
WORKDIR /usr/share/nginx/html
# copy the published app to the root folder
COPY --from=publish /app/publish/wwwroot .
# copy the nginx conf file in the container.
COPY nginx.conf /etc/nginx/nginx.conf