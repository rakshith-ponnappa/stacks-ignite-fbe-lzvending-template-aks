# Get the current subscription details
data "azurerm_subscription" "current" {}

# (Optional but robust) Resolve the role definition to avoid hardcoding GUIDs
data "azurerm_role_definition" "network_contributor" {
  name  = "Network Contributor"
  scope = data.azurerm_subscription.current.id
}

data "azurerm_user_assigned_identity" "aks_nodepool_network_contributor" {
  name                = "${var.cluster_name}-agentpool"
  resource_group_name = "MC-${var.resource_group_name}"
  depends_on          = [module.aks]
}
