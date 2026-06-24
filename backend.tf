terraform {
  backend "azurerm" {
    resource_group_name  = "prod-vmss-rg"
    storage_account_name = "tfstatepro2604vmss"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
