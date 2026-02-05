terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.85.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.7.0"
    }
  }

  required_version = ">= 1.7.0"
}

provider "azurerm" {
  features {}

  skip_provider_registration = true
}

provider "azuread" {}

# Data sources
data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

# Azure Container Registry
resource "azurerm_container_registry" "main" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.acr_sku
  admin_enabled       = true

  tags = var.tags
}

# Log Analytics Workspace for Container Apps
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.project_name}-logs"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

# Container Apps Environment
resource "azurerm_container_app_environment" "main" {
  name                       = var.container_app_environment_name
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  tags = var.tags
}

# User Assigned Managed Identity for Container App
resource "azurerm_user_assigned_identity" "container_app" {
  name                = "${var.project_name}-identity"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = var.tags
}

# Role assignment for Container App to pull from ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.container_app.principal_id
}

# Initial Container App
resource "azurerm_container_app" "main" {
  name                         = var.container_app_name
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.container_app.id]
  }

  registry {
    server   = azurerm_container_registry.main.login_server
    identity = azurerm_user_assigned_identity.container_app.id
  }

  template {
    container {
      name   = var.container_app_name
      image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
      cpu    = var.container_cpu
      memory = var.container_memory

      env {
        name  = "ShipTheoryApiUrl"
        value = var.ship_theory_api_url
      }
    }

    min_replicas = var.min_replicas
    max_replicas = var.max_replicas
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 8080

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = var.tags

  depends_on = [azurerm_role_assignment.acr_pull]
}

# Look up the existing Service Principal
data "azuread_service_principal" "github_actions" {
  client_id = var.existing_sp_client_id
}


# Role assignments for GitHub Actions Service Principal
resource "azurerm_role_assignment" "github_actions_contributor" {
  scope                = azurerm_resource_group.main.id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_service_principal.github_actions.object_id
}

resource "azurerm_role_assignment" "github_actions_acr_push" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPush"
  principal_id         = data.azuread_service_principal.github_actions.object_id
}
