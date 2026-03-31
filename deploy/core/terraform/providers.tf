provider "azurerm" {
  storage_use_azuread = true

  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    storage {
      data_plane_available = false
    }
  }
}

provider "azuread" {
  # Uses the same authentication as azurerm
}

provider "azurerm" {
  alias               = "hub"
  subscription_id     = local.hub_subscription_id
  storage_use_azuread = true

  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    storage {
      data_plane_available = false
    }
  }
}

provider "azurerm" {
  alias               = "management"
  subscription_id     = local.management_subscription_id
  storage_use_azuread = true

  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
    storage {
      data_plane_available = false
    }
  }
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.this.kube_config[0].host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--login",
      "spn",
      "--environment",
      "AzurePublicCloud",
      "--tenant-id",
      data.azurerm_client_config.this.tenant_id,
      "--server-id",
      var.aks_aad_server_app_id,
      "--client-id",
      data.azurerm_client_config.this.client_id,
      "--client-secret",
      var.azure_spn_client_secret,
    ]
  }
}

provider "kubectl" {
  host                   = data.azurerm_kubernetes_cluster.this.kube_config[0].host
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate)
  load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--login",
      "spn",
      "--environment",
      "AzurePublicCloud",
      "--tenant-id",
      data.azurerm_client_config.this.tenant_id,
      "--server-id",
      var.aks_aad_server_app_id,
      "--client-id",
      data.azurerm_client_config.this.client_id,
      "--client-secret",
      var.azure_spn_client_secret,
    ]
  }
}

provider "azapi" {
  # Uses the same authentication as azurerm
}
