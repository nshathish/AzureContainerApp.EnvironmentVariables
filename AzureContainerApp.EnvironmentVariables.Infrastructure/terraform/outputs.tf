output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.main.name
}

output "acr_login_server" {
  description = "Login server URL for Azure Container Registry"
  value       = azurerm_container_registry.main.login_server
}

output "container_app_environment_name" {
  description = "Name of the Container Apps environment"
  value       = azurerm_container_app_environment.main.name
}

output "container_app_name" {
  description = "Name of the Container App"
  value       = azurerm_container_app.main.name
}

output "container_app_url" {
  description = "URL of the deployed Container App"
  value       = "https://${azurerm_container_app.main.ingress[0].fqdn}"
}

output "github_actions_credentials" {
  description = "Service Principal details for GitHub Actions (client_id only - secret must be obtained separately)"
  value = jsonencode({
    clientId       = data.azuread_service_principal.github_actions.client_id
    subscriptionId = data.azurerm_client_config.current.subscription_id
    tenantId       = data.azurerm_client_config.current.tenant_id
  })
  sensitive = true
}

output "sp_info" {
  value = {
    display_name = data.azuread_service_principal.github_actions.display_name
    object_id    = data.azuread_service_principal.github_actions.object_id
  }
}
