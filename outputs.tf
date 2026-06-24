output "resource_group_name" {
  value = data.azurerm_resource_group.rg.name
  #  value = azurerm_resource_group.rg.name
}
