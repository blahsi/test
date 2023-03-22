terraform {
  required_version = ">=1.0"
  backend "azurerm" {
    resource_group_name  = "kopicloud-tfstate-rg"
    storage_account_name = "kopicloudiactest"
    container_name       = "core-tfstate"
    key                  = "actions.tfstate"
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
