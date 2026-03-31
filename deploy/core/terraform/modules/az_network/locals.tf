locals {
  common_nsg_rules = {
    # Inbound Rules
    NSRC_Platform_AzureLoadBalancer_to_Any = {
      name                       = "NSRC-Platform-AzureLoadBalancer-to-Any"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    }
    NSRC_RFC1918Priv_10_0_0_0_8_to_Any = {
      name                       = "NSRC-RFC1918Priv-10.0.0.0_8-to-Any"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "*"
    }
    NSRC_RFC1918Priv_172_16_0_0_12_to_Any = {
      name                       = "NSRC-RFC1918Priv-172.16.0.0_12-to-Any"
      priority                   = 300
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.16.0.0/12"
      destination_address_prefix = "*"
    }
    NSRC_RFC1918Priv_192_168_0_0_16_to_Any = {
      name                       = "NSRC-RFC1918Priv-192.168.0.0_16-to-Any"
      priority                   = 400
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "192.168.0.0/16"
      destination_address_prefix = "*"
    }
    NSRC_Any_to_Any = {
      name                       = "NSRC-Any-to-Any"
      priority                   = 700
      direction                  = "Inbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    # Required for Application Gateway v2 (AGIC) - health probe ports from GatewayManager
    # https://learn.microsoft.com/en-us/azure/application-gateway/configuration-infrastructure#network-security-groups
    AllowAppGwV2HealthProbe = {
      name                       = "AllowAppGwV2HealthProbe"
      priority                   = 210
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "65200-65535"
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
    }

    # Outbound Rules
    NSRC_RFC1918Priv_10_0_0_0_8_to_Any_Outbound = {
      name                       = "NSRC-RFC1918Priv-10.0.0.0_8-to-Any-Outbound"
      priority                   = 800
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "10.0.0.0/8"
      destination_address_prefix = "*"
    }
    NSRC_RFC1918Priv_172_16_0_0_12_to_Any_Outbound = {
      name                       = "NSRC-RFC1918Priv-172.16.0.0_12-to-Any-Outbound"
      priority                   = 900
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "172.16.0.0/12"
      destination_address_prefix = "*"
    }
    NSRC_RFC1918Priv_192_168_0_0_16_to_Any_Outbound = {
      name                       = "NSRC-RFC1918Priv-192.168.0.0_16-to-Any-Outbound"
      priority                   = 1000
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "192.168.0.0/16"
      destination_address_prefix = "*"
    }
    NSRC_Any_to_Any_Outbound = {
      name                       = "NSRC-Any-to-Any-Outbound"
      priority                   = 4000
      direction                  = "Outbound"
      access                     = "Deny"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    # Required for PostgreSQL Flexible Server Microsoft Entra ID authentication
    # Allows outbound HTTPS to AzureActiveDirectory service tag for AD admin setup
    AllowAzureADOutbound = {
      name                       = "AllowAzureADOutbound"
      priority                   = 3010
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "AzureActiveDirectory"
    }
    # Required for PostgreSQL Flexible Server - outbound to Azure Storage for WAL files and HA
    # https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-networking-private
    AllowStorageOutbound = {
      name                       = "AllowStorageOutbound"
      priority                   = 3020
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "Storage"
    }
    # Required for PostgreSQL Flexible Server - internal traffic on port 5432
    # Needed for HA failover and replication within the subnet
    AllowPostgreSQLInSubnet = {
      name                       = "AllowPostgreSQLInSubnet"
      priority                   = 3030
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "5432"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
  }
  # Azure Bastion specific NSG rules
  bastion_nsg_rules = {
    AllowHttpsInbound = {
      name                       = "AllowHttpsInbound"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"
    }
    AllowGatewayManagerInbound = {
      name                       = "AllowGatewayManagerInbound"
      priority                   = 130
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "GatewayManager"
      destination_address_prefix = "*"
    }
    AllowAzureLoadBalancerInbound = {
      name                       = "AllowAzureLoadBalancerInbound"
      priority                   = 140
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "AzureLoadBalancer"
      destination_address_prefix = "*"
    }
    AllowBastionHostCommunicationInbound = {
      name                       = "AllowBastionHostCommunicationInbound"
      priority                   = 150
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    }
    AllowBastionHostCommunicationInbound8080 = {
      name                       = "AllowBastionHostCommunicationInbound8080"
      priority                   = 151
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    }
    AllowBastionHostCommunicationInbound5701 = {
      name                       = "AllowBastionHostCommunicationInbound5701"
      priority                   = 152
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "5701"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    }
    AllowSshOutbound = {
      name                       = "AllowSshOutbound"
      priority                   = 161
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    AllowRdpOutbound = {
      name                       = "AllowRdpOutbound"
      priority                   = 162
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    AllowAzureCloudCommunicationOutbound = {
      name                       = "AllowAzureCloudCommunicationOutbound"
      priority                   = 170
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "AzureCloud"
    }
    AllowBastionHostCommunicationOutbound8080 = {
      name                       = "AllowBastionHostCommunicationOutbound8080"
      priority                   = 180
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "8080"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    }
    AllowBastionHostCommunicationOutbound5701 = {
      name                       = "AllowBastionHostCommunicationOutbound5701"
      priority                   = 181
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "5701"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "*"
    }
    AllowGetSessionInformationOutbound = {
      name                       = "AllowGetSessionInformationOutbound"
      priority                   = 190
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "Internet"
    }
  }

  # Merge common NSG rules with any additional rules and bastion rules
  vnet_nsg_rules = merge(local.common_nsg_rules, local.bastion_nsg_rules, var.vnet_nsg_rules)
}
