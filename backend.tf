terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    #storage_account_name = "" # set at init time
    #container_name       = "" # set at init time
    #key                  = "" # set at init time
  }
}