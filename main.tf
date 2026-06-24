data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}


#resource "azurerm_resource_group" "rg" {
#  name     = var.resource_group_name
#  location = var.location
#}

module "network" {
  source              = "./modules/network"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

module "nsg" {
  source              = "./modules/nsg"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  public_subnet_id  = module.network.public_subnet_id
  private_subnet_id = module.network.private_subnet_id
}

module "loadbalancer" {
  source              = "./modules/loadbalancer"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

module "managed_identity" {
  source              = "./modules/managed-identity"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
}

module "keyvault" {
  source              = "./modules/keyvault"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ghcr_username = var.ghcr_username
  ghcr_token    = var.ghcr_token
}

module "redis" {
  source              = "./modules/redis"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  subnet_id = module.network.private_subnet_id

  redis_dns_zone_id = module.private_dns.dns_zone_id
  #  redis_dns_zone_id = azurerm_private_dns_zone.redis.id
}

module "private_dns" {
  source              = "./modules/private-dns"
  resource_group_name = data.azurerm_resource_group.rg.name

  vnet_id = module.network.vnet_id
}

module "vmss" {
  source = "./modules/vmss"

  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  subnet_id       = module.network.private_subnet_id
  backend_pool_id = module.loadbalancer.backend_pool_id

  admin_username = var.admin_username
  ssh_public_key = var.ssh_public_key

  identity_id = module.managed_identity.identity_id

  cloud_init = filebase64("${path.root}/scripts/cloud-init.yaml")
}

module "autoscale" {
  source = "./modules/autoscale"

  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  vmss_id = module.vmss.vmss_id
}
