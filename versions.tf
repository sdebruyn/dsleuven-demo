terraform {
  required_version = "~> 0.13.0"
  required_providers {
    azurerm = {
      version = "~> 2.33.0"
      source  = "hashicorp/azurerm"
    }
    databricks = {
      source  = "databrickslabs/databricks"
      version = "0.2.7"
    }
  }
}
