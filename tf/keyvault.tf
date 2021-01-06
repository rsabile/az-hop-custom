data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "deployhpc" {
  name                        = format("%s%s", "kv", random_string.resource_postfix.result)
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  # TODO => Add the option to enable VMs to keep secrets in KV
  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    # QUESTION => Do we need this ?
    certificate_permissions = [
      "get",
      "managecontacts", 
    ]

    # QUESTION => Do we need this ?
    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
      "set",
      "list",
      "delete",
      "purge",
      "recover",
      "restore"
    ]

    # QUESTION => Do we need this ?
    storage_permissions = [
      "get",
    ]
  }

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}
