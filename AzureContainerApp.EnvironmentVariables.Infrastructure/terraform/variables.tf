variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-containerapp-demo"
}

variable "location" {
  description = "Azure location for resources"
  type        = string
  default     = "East US"
}

variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
  default     = "mycontainerapp"
}

variable "acr_name" {
  description = "Name of the Azure Container Registry (must be globally unique)"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9]+$", var.acr_name)) && length(var.acr_name) >= 5 && length(var.acr_name) <= 50
    error_message = "ACR name must be 5-50 characters and contain only alphanumeric characters."
  }
}

variable "acr_sku" {
  description = "SKU for Azure Container Registry"
  type        = string
  default     = "Basic"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.acr_sku)
    error_message = "ACR SKU must be Basic, Standard, or Premium."
  }
}

variable "container_app_environment_name" {
  description = "Name of the Container Apps environment"
  type        = string
  default     = "cae-demo"
}

variable "container_app_name" {
  description = "Name of the Container App"
  type        = string
  default     = "ca-demo-app"
}

variable "container_cpu" {
  description = "CPU allocation for the container"
  type        = string
  default     = "0.25"
}

variable "container_memory" {
  description = "Memory allocation for the container"
  type        = string
  default     = "0.5Gi"
}

variable "min_replicas" {
  description = "Minimum number of replicas"
  type        = number
  default     = 0
}

variable "max_replicas" {
  description = "Maximum number of replicas"
  type        = number
  default     = 10
}

variable "ship_theory_api_url" {
  description = "ShipTheory API URL"
  type        = string
  default     = "https://api.shiptheory.com"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "ContainerApp Demo"
    ManagedBy   = "Terraform"
  }
}

variable "existing_sp_client_id" {
  description = "The Client ID (Application ID) of your existing Service Principal"
  type        = string
}
