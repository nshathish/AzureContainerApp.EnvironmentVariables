# Base image for running the app
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
USER $APP_UID
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Stage for building the application
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copy all project files into container
COPY . .

# Switch to project directory
WORKDIR /src/AzureContainerApp.EnvironmentVariables

# Restore dependencies
RUN dotnet restore "AzureContainerApp.EnvironmentVariables.csproj"

# Build the project
RUN dotnet build "AzureContainerApp.EnvironmentVariables.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Stage for publishing the application
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
WORKDIR /src/AzureContainerApp.EnvironmentVariables
RUN dotnet publish "AzureContainerApp.EnvironmentVariables.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Final runtime image
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AzureContainerApp.EnvironmentVariables.dll"]
