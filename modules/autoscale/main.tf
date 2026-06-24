resource "azurerm_monitor_autoscale_setting" "autoscale" {
  name                = "vmss-autoscale"
  location            = var.location
  resource_group_name = var.resource_group_name

  target_resource_id = var.vmss_id

  profile {
    name = "default"

    capacity {
      default = 2
      minimum = 2
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = var.vmss_id

        time_grain       = "PT1M"
        time_window      = "PT5M"
        statistic        = "Average"
        time_aggregation = "Average"

        operator  = "GreaterThan"
        threshold = 70
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT5M"
      }
    }
  }
}
