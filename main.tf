provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "dsleuven"
}

resource "azurerm_databricks_workspace" "dbks" {
  location            = var.location
  name                = "ds_leuven_dbks"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "standard"
}

provider "databricks" {
  azure_workspace_resource_id = azurerm_databricks_workspace.dbks.id
}

module "dl_sp" {
  source  = "innovationnorway/service-principal/azuread"
  version = "3.0.0-alpha.1"
  name    = "dsleuven"
  years   = 1
}
