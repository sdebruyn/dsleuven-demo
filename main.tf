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

module "data_lake" {
  depends_on                      = [azurerm_databricks_workspace.dbks, azurerm_resource_group.rg]
  source                          = "datarootsio/azure-datalake/module"
  version                         = "0.5.4"
  data_lake_name                  = "dsleuvendl"
  region                          = var.location
  resource_group_name             = azurerm_resource_group.rg.name
  service_principal_client_id     = module.dl_sp.client_id
  service_principal_client_secret = module.dl_sp.client_secret
  service_principal_object_id     = module.dl_sp.object_id
  storage_replication             = "LRS"
  databricks_workspace_name       = azurerm_databricks_workspace.dbks.name
  provision_synapse               = false
}
