resource "azurerm_user_assigned_identity" "identity" {
  name                = "vmss-identity"
  location            = var.location
  resource_group_name = var.resource_group_name
}
