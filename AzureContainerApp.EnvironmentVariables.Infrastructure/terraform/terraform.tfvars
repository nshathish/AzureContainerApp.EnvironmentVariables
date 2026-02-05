# Copy this file to terraform.tfvars and customize

# Required: Must be globally unique across all Azure Container Registries
acr_name = "az204labs25304acr"

# Optional: Customize these values
resource_group_name              = "az204labs25304rg"
location                        = "uksouth"
project_name                    = "az204labs25304app"
container_app_environment_name  = "az204labs25304env"
container_app_name              = "az204labs25304app"
ship_theory_api_url             = "https://api.shiptheory.com"

# Optional: Resource sizing
container_cpu    = "0.25"
container_memory = "0.5Gi"
min_replicas     = 0
max_replicas     = 10

# Optional: Tags
tags = {
  Environment = "Development"
  Project     = "az204labs25304app"
  Owner       = "DevTeam"
  ManagedBy   = "Terraform"
}