resource "azurerm_managed_redis" "redis" {
  name                = "prodredis124"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku_name = "Balanced_B3"

  identity {
    type = "SystemAssigned"
  }

  default_database {}

}

resource "azurerm_private_endpoint" "redis" {
  name                = "redis-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name

  subnet_id = var.subnet_id

  private_service_connection {
    name                           = "redis-psc"
    private_connection_resource_id = azurerm_managed_redis.redis.id
    is_manual_connection           = false

    subresource_names = ["redisEnterprise"]
  }

  private_dns_zone_group {
    name = "default"

    private_dns_zone_ids = [
      var.redis_dns_zone_id
    ]
  }
}



#resource "azurerm_redis_cache" "redis" {
#  name                = "prodredis123"
#  location            = var.location
#  resource_group_name = var.resource_group_name

#  capacity = 1
#  family   = "P"
#  sku_name = "Premium"

# minimum_tls_version = "1.2"

#public_network_access_enabled = false

#redis_configuration {
# maxmemory_reserved = 2
#maxmemory_delta    = 2
#maxmemory_policy   = "allkeys-lru"
#}
#}


#resource "azurerm_private_endpoint" "redis" {
# name                = "redis-private-endpoint"
# location            = var.location
# resource_group_name = var.resource_group_name

#subnet_id = var.subnet_id

# private_service_connection {
#  name                           = "redis-psc"
#   private_connection_resource_id = azurerm_redis_cache.redis.id
#
#   subresource_names = ["redisCache"]
#
#   is_manual_connection = false
# }
#}

