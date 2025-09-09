data "terraform_remote_state" "prd_eastus2_connectivity" {
  backend   = "azurerm"
  workspace = terraform.workspace
  config = {
    use_azuread_auth = true
    tenant_id        = "d483ed84-f7bf-4078-a58f-fb250feccf8f"
    subscription_id  = "cea31a73-c42c-4b17-b83d-c629142bf942"

    storage_account_name = "steefbeeus2contfstate"
    container_name   = "tfstate"
    key              = "connectivity/coreenv:prd"
    use_azuread_auth = true
    
  }
}

data "terraform_remote_state" "prd_centralus_connectivity" {
  backend   = "azurerm"
  workspace = terraform.workspace
  config = {
    use_azuread_auth = true
    tenant_id        = "d483ed84-f7bf-4078-a58f-fb250feccf8f"
    subscription_id  = "cea31a73-c42c-4b17-b83d-c629142bf942"
    
    storage_account_name = "steefbecuscontfstate"
    container_name       = "tfstate"
    key                  = "connectivity/coreenv:prd"
    use_azuread_auth     = true
  }
}