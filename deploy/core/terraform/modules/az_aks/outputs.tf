output "aks_resource_group_name" {
  description = "The name of the AKS resource group"
  value       = var.resource_group_name
}

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = module.aks.aks_name
}

output "aks_cluster_id" {
  description = "The aks cluster id"
  value       = module.aks.aks_id
}

output "aks_cluster_private_fqdn" {
  description = "The FQDN for the Kubernetes Cluster when private link has been enabled, which is only resolvable inside the Virtual Network used by the Kubernetes Cluster."
  value       = module.aks.cluster_private_fqdn
}

output "aks_cluster_private_fqdn_cluster_name" {
  description = "AKS for Kubernetes Cluster - API server address xxxx.privatelink.region.azmk8s.io"
  value       = split(".", module.aks.cluster_private_fqdn)[0]
}

output "cluster_ca_certificate" {
  description = "AKS ca certificate"
  value       = module.aks.cluster_ca_certificate
}

output "aks_host" {
  value       = module.aks.host
  description = "host id of cluster"
}

# AKS User Assigned Identity Outputs

output "aks_identity_id" {
  description = "The ID of the user-assigned identity."
  value       = var.create_aks_user_identity ? azurerm_user_assigned_identity.aks_identity[0].id : ""
}

output "aks_identity_client_id" {
  description = "The client ID of the user-assigned identity."
  value       = var.create_aks_user_identity ? azurerm_user_assigned_identity.aks_identity[0].client_id : ""
}

output "aks_identity_principal_id" {
  description = "The principal ID of the user-assigned identity."
  value       = var.create_aks_user_identity ? azurerm_user_assigned_identity.aks_identity[0].principal_id : ""
}

output "aks_identity_name" {
  description = "The name of the user-assigned identity."
  value       = var.create_aks_user_identity ? azurerm_user_assigned_identity.aks_identity[0].name : ""
}

output "oidc_issuer_url" {
  description = "The OIDC issuer URL that is associated with the cluster."
  value       = module.aks.oidc_issuer_url
}

# AGIC (Application Gateway Ingress Controller) Outputs

output "ingress_application_gateway" {
  description = "The AKS cluster's ingress_application_gateway block (gateway name, ID, identity, etc.)"
  value       = module.aks.ingress_application_gateway
}

output "ingress_application_gateway_enabled" {
  description = "Whether AGIC is enabled on the AKS cluster"
  value       = module.aks.ingress_application_gateway_enabled
}
