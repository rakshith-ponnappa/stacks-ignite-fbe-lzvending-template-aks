terraform {
  required_version = ">= 1.13, < 2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.62.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9"
    }
  }
}
